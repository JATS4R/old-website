// SAXON API: http://www.saxonica.com/ce/user-doc/1.1/html/api/

// onSaxonLoad is called when Saxon has finished loading
var onSaxonLoad = function() {
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
        	// Parse the input file
        	var doc = Saxon.parseXML(this.result);
        	var pe = doc.querySelector("parsererror div");
        	if (pe) {
        		var cls = document.createAttribute("class");
        		cls.value = "error";
        		pe.setAttributeNode(cls);
        		pe.removeAttribute("style");
        		results.insertBefore(pe, null);
        		var h = document.createElement("h2");
        		h.textContent = "Error parsing input file";
        		results.insertBefore(h, pe);
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

        reader.readAsText(input.files[0]);
    }

    // listen for file selection, or for a press on the "revalidate" button
    input.addEventListener('change', validateFile);
    revalidate.addEventListener('click', validateFile);
}
