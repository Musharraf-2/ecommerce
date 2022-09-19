document.addEventListener("turbolinks:load", function() {
  $('#search_key').on('input', function(e) {
    Rails.ajax({
      url: './products/search?key=' + e.target.value,
      type: "get",
      success: function(results) {
        console.log(results);
        $('#search').empty();
        results.forEach(function(result) {
          $('#search').append('<a href="products/' + result.id + '">' + result.title + '</a><br />');
         });
      },
      error: function(err) {
        alert(err);
      }
    });
  });
})
