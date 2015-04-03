// SAXON API: http://www.saxonica.com/ce/user-doc/1.1/html/api/

// onSaxonLoad is called when Saxon has finished loading
var onSaxonLoad = function() {
    var xslt = {
        errors:   'jats4r-level-errors-0.xsl',
        warnings: 'jats4r-level-warnings-0.xsl',
        info:     'jats4r-level-info-0.xsl'
    };

    var statusNode = document.getElementById('status');
    statusNode.textContent = 'Choose a JATS XML file to validate.';

    var input = document.getElementById('input');
    var phaseNode = document.getElementById('phase');
    var revalidate = document.getElementById('revalidate');
    var results = document.getElementById('results');

    function validateFile() {
        // clear any previous results
        results.textContent = '';
        if (input.files.length == 0) {
            statusNode.textContent = "Please select a file first!";
            return;
        }
        statusNode.textContent = 'Processing…';

        var reader = new FileReader;
        var phase = phaseNode.value;

        reader.onload = function() {
            // run the Schematron tests
            Saxon.run({
                stylesheet: 'generated-xsl/' + xslt[phase],
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

        reader.readAsText(input.files[0]);
    }

    // listen for file selection, or for a press on the "revalidate" button
    input.addEventListener('change', validateFile);
    revalidate.addEventListener('click', validateFile);
}
