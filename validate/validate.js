// SAXON API: http://www.saxonica.com/ce/user-doc/1.1/html/api/
// onSaxonLoad is called when Saxon has finished loading
var onSaxonLoad = function() {

  // Various DOM elements
  var statusNode = document.getElementById('status');
  var input = document.getElementById('input');
  var phaseNode = document.getElementById('phase');
  var revalidate = document.getElementById('revalidate');
  var results = document.getElementById('results');

  // Which XSLT to use depending on the level selected
  var xslt = {
    errors:   'jats4r-level-errors.xsl',
    warnings: 'jats4r-level-warnings.xsl',
    info:     'jats4r-level-info.xsl'
  };


  // Some classes for holding information about a dtd, as read from the dtds.yaml file
  function Dtd(dtd_data) {
    var self = this;
    self.data = dtd_data;

    var path = dtd_data.path;
    this.path = path;
    this.dir = path.replace(/(.*)\/.*/, "$1");
    this.filename = path.replace(/.*\//, "");;
  }

  function DtdDatabase(db) {
    var self = this;
    self.db = db;

    var dtd_by_fpi = {};
    db.dtds.forEach(function(dtd_data) {
      dtd_by_fpi[dtd_data.fpi] = new Dtd(dtd_data);
    });
    self.dtd_by_fpi = dtd_by_fpi;
  }



  // This function gets called when we've finished reading the DTD, or, if there is no DTD,
  // immediately when the validation begins.
  // If there is no DTD, this will be called with only one argument.
  function do_validate(contents, dtd_filename, dtd_contents) {
    statusNode.textContent = 'Validating…';

    var filename = input.files[0].name;

    var result = xmllint.validateXML({
      xml: [filename, contents],
      arguments: ['--noent', '--loaddtd', '--dtdvalid', 'JATS-journalpublishing1.dtd', filename],
      schemaFiles: [[dtd_filename, dtd_contents]]
    });
  /*
    var result = xmllint.validateXML({
      xml: [filename, contents],
      arguments: ['--noent', filename]
    });
  */

    //console.log(result);

    if (result.stderr.length) {
      //statusNode.textContent = 'Failed validation';
      //document.getElementById('lint').textContent = result.stderr;
      var msg_div = document.createElement("pre");
      msg_div.textContent = result.stderr;
      displayError("Failed DTD validation", msg_div);
      statusNode.textContent = 'Finished';
    } 
    else {
      statusNode.textContent = 'Validated';

      var doc, pe;
      var parse_error = false;
      try {
        doc = Saxon.parseXML(result.stdout);
      }
      catch (e) {
        parse_error = true;
      }
      if (!doc) { parse_error = true; }
      if (!parse_error) {
        pe = doc.querySelector("parsererror");
      }
      if (parse_error || pe) {
        if (!pe) { pe = "Unable to parse the input XML file."; }
        displayError("Error parsing input file", pe);
        //results.insertBefore(pe, null);
        //var h = document.createElement("h2");
        //h.textContent = "Error parsing input file";
        //results.insertBefore(h, pe);
        statusNode.textContent = 'Finished';
        return;
      }

      // run the Schematron tests
      // FIXME:  need to parameterize the version number
      var phase = phaseNode.value;
      Saxon.run({
        stylesheet: '../generated-xsl/0.1/' + xslt[phase],
        source: doc,
        method: 'transformToDocument',
        success: function(processor) {
            statusNode.textContent = 'Converting…';

            // Convert the output XML to HTML. When done, this calls updateHTMLDocument,
            // which uses the @href attribute in the <xsl:result-document> element in the
            // stylesheet to update the #result element in the HTML page.

            Saxon.run({
                stylesheet: 'svrl-to-html.xsl',
                source: processor.getResultDocument(),
                method: 'updateHTMLDocument'
            });

            statusNode.textContent = 'Finished';
        }
      });
    }
  }



  // First fetch the YAML file that describes all of the DTDs
  fetch("dtds.yaml")
    .then(function(response) {
      return response.text();
    })
    .then(function(yaml_str) {
      console.log(yaml_str);
      var dtds = new DtdDatabase(jsyaml.load(yaml_str));

      console.log("db = %o", dtds.db);




      statusNode.textContent = 'Choose a JATS XML file to validate.';


      function displayError(head, msg) {
        var msg_div;
        if (msg instanceof Element) {
          msg_div = msg;
        }
        else {
          msg_div = document.createElement("div");
          msg_div.textContent = msg;
        }
        if (msg)
        results.insertBefore(msg_div, null);
        var h = document.createElement("h2");
        h.textContent = head;
        results.insertBefore(h, msg_div);
      }

      function validateFile() {
          // clear any previous results
          results.textContent = '';
          if (!input.files.length) {
            statusNode.textContent = "Please select a file first!";
            return;
          }
          statusNode.textContent = 'Processing…';

          var reader = new FileReader();

          reader.onload = function() {
              // Get the contents of the xml file
              var contents = this.result;

              // Look for a doctype declaration
              if (m = contents.match("<!DOCTYPE\\s+\\S+\\s+PUBLIC\\s+\\\"(.*?)\\\"\\s+\\\"(.*?)\\\"\\s*>")) {
                var fpi = m[1];
                var sysid = m[2];
              }
              var dtd = dtds.dtd_by_fpi[fpi] || null;
              if (dtd) { 
                var dtd_filename = dtd.filename;
                var dtd_path = "flat-dtds/" + dtd.path;

                // Fetch the flattened DTD
                fetch(dtd_path).then(function(response) {
                  return response.text();
                })

                // After the schema file has loaded:
                .then(
                  function(dtd_contents) {
                    do_validate(contents, dtd_filename, dtd_contents);
                  },
                  function(err) {
                    console.error(err);
                  }
                );
              }
              else {
                do_validate(contents);
              }
          }

          reader.readAsText(input.files[0]);
      }

      // listen for file selection, or for a press on the "revalidate" button
      input.addEventListener('change', validateFile);
      revalidate.addEventListener('click', validateFile);


    });
}
