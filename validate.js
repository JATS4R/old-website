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

    outputNode.textContent = '';

    var input = document.createElement('input');
    input.setAttribute('type', 'file');
    document.body.appendChild(input);

    // listen for selected file
    input.addEventListener('change', function() {
      outputNode.textContent = 'Processing…';

      var reader = new FileReader;
      reader.responseType = 'document';

      reader.onload = function(e) {
        var text = reader.result.replace(/^\s*<\?xml.+/, ''); // remove the XML declaration

        var doc = parser.parseFromString(text, 'application/xml');
        var fragment = processor.transformToDocument(doc);
        var output = serializer.serializeToString(fragment);

        outputNode.textContent = output;
      }

      reader.readAsText(this.files[0]);
    });
  }

  xhr.send();
}