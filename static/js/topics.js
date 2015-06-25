$(function() {
  var tyml = $.ajax("static/topics.yaml")
    .done(function(content) {
      var topics = jsyaml.load(content);
      // Sort first by priority, then alphabetical
      var topic_names = Object.keys(topics);
      topic_names.sort(function(a, b) {
        var a_p = topics[a].priority != null ? topics[a].priority : 100;
        var b_p = topics[b].priority != null ? topics[b].priority : 100;
        if (a_p != b_p) return a_p - b_p;
        return a > b ? 1 : a < b ? -1 : 0;
      });
      console.log("%o", topic_names);

      // Assign a priority even for those that don't have one
      $.each(topic_names, function(i, tn) { 
        topics[tn].priority = i + 1;
      });


      var tbody = $('#topic-table tbody');
      $.each(topic_names, function(i, tname) {
        var t = topics[tname];
        var issue_href = "https://github.com/JATS4R/elements/labels/" + tname;
        var example_href = "https://github.com/JATS4R/elements/blob/master/" + tname + ".md";
        var see_also = t["see-also"] 
          ? t["see-also"].map(function(a){
                            return "<span style='white-space: nowrap'>" + a + "</span>";
                         })
                         .join(", ")
          : '&nbsp;';
        var status_href = 
          t.status == 'final' ? 'http://jats4r.org/recommendations/' + tname + '.html'
                              : 'https://github.com/JATS4R/elements/wiki/' + tname;
        var status_label = t.status == 'final' ? "✓ " + t.status : t.status 
        
        var tr = $('<tr class="row' + i % 2 + '">').append(
          $('<td class="center">').html(t.priority != null ? t.priority : ''),
          $('<td>').html("<strong><span style='white-space: nowrap'>" + tname + 
            "</span></strong>"),
          $('<td>').html(t.description),
          $('<td class="center links">').html(
            '<a href="' + issue_href + 
              '"><span class="fa fa-exclamation-circle"></span></a> ' +
            '<a href="' + example_href + 
              '"><span class="fa fa-code"></span></a>'
          ),
          $('<td class="center">').html(
            '<a href="' + status_href + '">' + status_label + '</a>'),
          $('<td>').html(see_also)
        );
        tbody.append(tr);
      });
    })
    .fail(function() {
      alert("Failed to load topics. Please try again. If the problem persists, " +
            "please send and email to jats4r@googlegroups.com.");
    });


});