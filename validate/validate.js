

// SAXON API: http://www.saxonica.com/ce/user-doc/1.1/html/api/
// onSaxonLoad is called when Saxon has finished loading
var onSaxonLoad = function() {

  // First fetch the YAML file that describes all of the DTDs
  var dtds;
  fetch("dtds.yaml")
    .then(function(response) {
      return response.text();
    })
    .then(function(yaml_str) {
      console.log(yaml_str);
      var dtds = jsyaml.load(yaml_str);



      var xslt = {
        errors:   'jats4r-level-errors.xsl',
        warnings: 'jats4r-level-warnings.xsl',
        info:     'jats4r-level-info.xsl'
      };

      var statusNode = document.getElementById('status');
      statusNode.textContent = 'Choose a JATS XML file to validate.';

      var input = document.getElementById('input');
      var phaseNode = document.getElementById('phase');
      var revalidate = document.getElementById('revalidate');
      var results = document.getElementById('results');

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
          var phase = phaseNode.value;

          reader.onload = function() {
              // Parse the input file
              var doc, pe, parse_error = false;
              var xml = this.result;

              var schemaFiles = [
                'JATS-journalpublishing1.dtd'
              ];

              // This produces an array of strings, each of which is the contents of
              // one of the schema files above.
              Promise.all(schemaFiles.map(function(schemaFile) {
                return fetch('../dtd/flat/' + schemaFile).then(function(response) {
                  return response.text();
                });
              }))

              // After all of the schema files have loaded:
              .then(function(schemas) {
                statusNode.textContent = 'Validating…';

                var filename = input.files[0].name;

                var result = xmllint.validateXML({
                	xml: [filename, xml],
                    arguments: ['--noent', '--loaddtd', '--dtdvalid', 'JATS-journalpublishing1.dtd', filename],
                    schemaFiles: schemas.map(function(schema, i) {
                      return [schemaFiles[i], schema];
                    }),
                });

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
              }, 
              function(err) {
                console.error(err);
              });
          }

          reader.readAsText(input.files[0]);
      }

      // listen for file selection, or for a press on the "revalidate" button
      input.addEventListener('change', validateFile);
      revalidate.addEventListener('click', validateFile);


    });
}
