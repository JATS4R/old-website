// onSaxonLoad is called when Saxon has finished loading
var onSaxonLoad = function() {
  var processor;
  var parser = new DOMParser;
  var serializer = new XMLSerializer();
  var outputNode = document.getElementById('output');

  // load XSL
  var xhr = new XMLHttpRequest;
  xhr.open('GET', 'generated-xsl/jats4r-errlevel-0.xsl');
  xhr.responseType = 'document';

  xhr.onload = function() {
    processor = Saxon.newXSLT20Processor(this.response);

    outputNode.textContent = 'Choose a JATS XML file to validate.';

    var input = document.createElement('input');
    input.setAttribute('type', 'file');

    var form = document.createElement('form');
    form.appendChild(input);

    document.body.insertBefore(form, document.body.firstChild);

    // listen for selected file
    input.addEventListener('change', function() {
      outputNode.textContent = 'Processing…';

      var reader = new FileReader;
      reader.responseType = 'document';

      reader.onload = function(e) {
        var text = reader.result.replace(/^\s*<\?xml.+/, ''); // remove the XML declaration

        // run Schematron tests
        var doc = parser.parseFromString(text, 'application/xml');
        var result = processor.transformToDocument(doc);
        outputNode.textContent = 'Converted';

        // load the output stylesheet
        var xhr = new XMLHttpRequest;
        xhr.open('GET', 'output.xsl');
        xhr.responseType = 'document';

        xhr.onload = function() {
            outputNode.textContent = 'Converting…';

            // convert the output XML to HTML
            Saxon.run({
                stylesheet: this.response,
                source: result
            });

            outputNode.textContent = 'Finished';
        }

        xhr.send();
      }

      reader.readAsText(this.files[0]);
    });
  }

  xhr.send();
}
