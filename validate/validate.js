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
                'iso8879/isobox.ent',
                'iso8879/isocyr1.ent',
                'iso8879/isocyr2.ent',
                'iso8879/isodia.ent',
                'iso8879/isolat1.ent',
                'iso8879/isolat2.ent',
                'iso8879/isonum.ent',
                'iso8879/isopub.ent',
                'iso9573-13/isoamsa.ent',
                'iso9573-13/isoamsb.ent',
                'iso9573-13/isoamsc.ent',
                'iso9573-13/isoamsn.ent',
                'iso9573-13/isoamso.ent',
                'iso9573-13/isoamsr.ent',
                'iso9573-13/isogrk3.ent',
                'iso9573-13/isomfrk.ent',
                'iso9573-13/isomopf.ent',
                'iso9573-13/isomscr.ent',
                'iso9573-13/isotech.ent',
                'JATS-articlemeta1.ent',
                'JATS-backmatter1.ent',
                'JATS-base-test1.dtd',
                'JATS-chars1.ent',
                'JATS-common1.ent',
                'JATS-default-classes1.ent',
                'JATS-default-mixes1.ent',
                'JATS-display1.ent',
                'JATS-format1.ent',
                'JATS-funding1.ent',
                'JATS-journalmeta1.ent',
                'JATS-journalpub-oasis-custom-classes1.ent',
                'JATS-journalpub-oasis-custom-modules1.ent',
                'JATS-journalpubcustom-classes1.ent',
                'JATS-journalpubcustom-mixes1.ent',
                'JATS-journalpubcustom-models1.ent',
                'JATS-journalpubcustom-modules1.ent',
                'JATS-journalpublishing-oasis-article1.dtd',
                'JATS-journalpublishing1.dtd',
                'JATS-link1.ent',
                'JATS-list1.ent',
                'JATS-math1.ent',
                'JATS-mathmlsetup1.ent',
                'JATS-modules1.ent',
                'JATS-nlmcitation1.ent',
                'JATS-notat1.ent',
                'JATS-oasis-namespace1.ent',
                'JATS-oasis-namespace1a.ent',
                'JATS-oasis-tablesetup1.ent',
                'JATS-para1.ent',
                'JATS-phrase1.ent',
                'JATS-references1.ent',
                'JATS-related-object1.ent',
                'JATS-section1.ent',
                'JATS-XHTMLtablesetup1.ent',
                'JATS-xmlspecchars1.ent',
                'mathml/mmlalias.ent',
                'mathml/mmlextra.ent',
                'mathml2-qname-1.mod',
                'mathml2.dtd',
                'oasis-exchange.ent',
                'xhtml-inlstyle-1.mod',
                'xhtml-table-1.mod',
                'xmlchars/isogrk1.ent',
                'xmlchars/isogrk2.ent',
                'xmlchars/isogrk4.ent'
            ]

            Promise.all(schemaFiles.map(function(schemaFile) {
                return fetch('../dtd/1.0/' + schemaFile).then(function(response) {
                    return response.text();
                });
            })).then(function(schemas) {
                statusNode.textContent = 'Validating…';

                var filename = input.files[0].name;

                var result = xmllint.validateXML({
                	xml: [filename, xml],
                    arguments: ['--noent', '--dtdvalid', 'JATS-journalpublishing1.dtd', filename],
                    schemaFiles: schemas.map(function(schema, i) {
                        return [schemaFiles[i], schema];
                    }),
                });

                //console.log(result);

                if (result.stderr.length) {
                    statusNode.textContent = 'Failed validation';
                    document.getElementById('lint').textContent = result.stderr;
                } else {
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
                        if (!pe) {
                            pe = document.createElement("div");
                            pe.textContent = "Unable to parse the input XML file.";
                        }
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
            }, function(err) {
                console.error(err);
            });
        }

        reader.readAsText(input.files[0]);
    }

    // listen for file selection, or for a press on the "revalidate" button
    input.addEventListener('change', validateFile);
    revalidate.addEventListener('click', validateFile);
}
