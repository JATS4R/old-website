$(document).ready(function() {
   
  fetch("http://localhost:8080/git/jats4r/validator/dtds.yaml")
    .then(function(response) {
      return response.text();
    })
    .then(function(yaml_str) {
      var dtds = jsyaml.load(yaml_str).dtds;

      dtds.forEach(function(dtd) {
        // Compute nlm_niso, version, flavor, table model, mml version
        var path = dtd.path;
        var path_segs = path.split("/");

        dtd.nlm_niso = path_segs[0] == "nlm-dtd" ? "NLM" : "NISO";
        dtd.version = path_segs[2];
        dtd.flavor = path_segs[1];
        dtd.table_model = path.match(/oasis/i) != null ? "OASIS" : "HTML";
        // FIXME: earlier DTDs don't use MML at all, right?
        dtd.mml_version = path.match(/mml3/i) != null ? "3" : "2";
      });

      var table_fields = [ 'nlm_niso', 'version', 'flavor', 'table_model', 'mml_version' ];
      var table_defs = {
        flavor: {
            cell: function(d) {
              return d == "articleauthoring" ? "Authoring" :
                d.charAt(0).toUpperCase() + d.slice(1);
            }
        },
        table_model: {
            cell: function(d) {
              return d + " tables";
            }
        },
        mml_version: {
            cell: function(d) {
              return "MML " + d;
            }
        }
      }

      var tbody = $('.topic-table tbody');

      function compare_per_list(a, b, list) {
        return list.indexOf(a) - list.indexOf(b);
      }
      function compare_version(a, b) {
        var av = a.split(".");
        var bv = b.split(".");
        var c = av[0] - bv[0] || av[1].localeCompare(bv[1]);
        console.log("av: %o, bv: %o, c = " + c, av, bv);
        return -c;
      }


      //table.append(tbody);
      dtds
          .sort(function(a, b) {
            return compare_per_list(a.nlm_niso, b.nlm_niso, ['NISO', 'NLM']) ||
                   compare_version(a.version, b.version) ||
                   compare_per_list(a.flavor, b.flavor, 
                      ['archiving', 'publishing', 'articleauthoring']) ||
                   compare_per_list(a.table_model, b.table_model, 
                      ['HTML', 'OASIS']) ||
                   (a.mml_version - b.mml_version);
          })
          .forEach(function(dtd, i) {
            var cls = 'row' + i%2 + ' ' + dtd.flavor;
            var tr = $('<tr class="' + cls + '">');
            tbody.append(tr);

            table_fields.forEach(function(tf) {
                var tdef = table_defs[tf];
                var cell = tdef && tdef.cell ? tdef.cell(dtd[tf]) : dtd[tf];
                tr.append( $('<td>').text(cell) )
              });
          })

    })
  ;





});
