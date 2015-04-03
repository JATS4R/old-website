// SAXON API: http://www.saxonica.com/ce/user-doc/1.1/html/api/

// onSaxonLoad is called when Saxon has finished loading
var onSaxonLoad = function() {
    var statusNode = document.getElementById('status');
    statusNode.textContent = 'Choose a JATS XML file to validate.';

    var input = document.getElementById('input');

    // listen for selected file
    input.addEventListener('change', function() {
        // clear any previous results
        document.querySelector('#results').textContent = '';

        statusNode.textContent = 'Processing…';

        var reader = new FileReader;

        reader.onload = function() {
            // run the Schematron tests
            Saxon.run({
                stylesheet: 'generated-xsl/jats4r-level-info-0.xsl',
                source: Saxon.parseXML(this.result),
                method: 'transformToDocument',
                success: function(processor) {
                    statusNode.textContent = 'Converting…';

                    // convert the output XML to HTML
                    Saxon.run({
                        stylesheet: 'svrl-to-html.xsl',
                        source: processor.getResultDocument(),
                        method: 'updateHTMLDocument'
                    });

                    statusNode.textContent = 'Finished';
                }
            });
        }

        reader.readAsText(this.files[0]);
    });

}
