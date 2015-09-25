$(function() {

  
  // FIXME: fetch these two yaml files concurrently, using Promises
  $.ajax("../validator/schema/versions.yaml")
    .done(function(versions_yaml) {
      var versions = jsyaml.load(versions_yaml);

      // FIXME: sort the version numbers first
      var latest_version = versions[versions.length - 1];


      $.ajax("static/topics.yaml")
        .done(function(content) {
          var topics = jsyaml.load(content);

          // Create a hash indexed by name

          // Sort first by priority, then alphabetical
          var topic_names = topics.map(function(t) { return t.name; });

          // Assign a priority to each
          $.each(topics, function(i, t) { 
            t.priority = i + 1;
          });


          var tbody = $('.topic-table tbody');
          $.each(topics, function(i, t) {
            var tname= t.name;
            var issue_href = "https://github.com/JATS4R/JATS4R-Participant-Hub/labels/" + tname;
            var example_href = 
              "https://github.com/JATS4R/JATS4R-Participant-Hub/blob/master/examples/" + 
              tname + ".md";
            var see_also = t["see-also"] 
              ? ' See also: ' + 
                t["see-also"].map(function(a){
                    return "<span style='white-space: nowrap'>" + a + "</span>";
                  })
                  .join(", ")
              : '';


            var recs = '&nbsp;';
            if (t.recs) {
              var rec_base_url = "http://jats4r.org/recommendations/";

              // Construct an array of hyperlinks to each recommendation
              var rec_hyperlinks =
                t.recs.map(function(r) {
                  // The URL to the recommendation depends on version
                  var rec_url = 
                    (r.version && r.version.match(/^\d/)) 
                      ? rec_base_url + 
                        ( r.version == latest_version ? '' : r.version + "/") +
                        tname + ".html"
                      : r.url;
                  return "<a href='" + rec_url + "'>" + r.version + "</a>";
                });
              recs = "<span style='white-space: nowrap'>" + 
                rec_hyperlinks.join(", ") + "</span>";
            }

            var tr = $('<tr class="row' + i % 2 + '">').append(
              $('<th>').html("<span style='white-space: nowrap'>" + tname + 
                "</span>"),
              $('<td>').html(t.description + see_also),
              $('<td class="center links">').html(
                '<a href="' + issue_href + 
                  '"><span class="fa fa-exclamation-circle"></span></a> ' +
                '<a href="' + example_href + 
                  '"><span class="fa fa-code"></span></a>'
              ),
              $('<td class="center">').html(recs)
            );
            tbody.append(tr);
          });
        })
        .fail(function() {
          alert("Failed to load topics. Please try again. If the problem persists, " +
                "please send and email to jats4r@googlegroups.com.");
        });


    });

});