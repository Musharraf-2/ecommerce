document.addEventListener("turbolinks:load", function() {
  $('#search_key').on('input', function(e) {
    Rails.ajax({
      url: '/products/search?key=' + e.target.value,
      type: "get",
      success: function(results) {
        console.log(results);
        $('#search').empty();
        results.forEach(function(result) {
          $('#search').append('<div style="background-color: white"><a style="text-decoration: none; color: black;" href="products/' + result.id + '">' + result.title + '</a></div><hr>');
         });
      },
      error: function(err) {
        alert(err);
      }
    });
  });
})
