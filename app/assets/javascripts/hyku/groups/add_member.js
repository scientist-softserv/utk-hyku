$(document).on('turbolinks:load', function() {
  $('.js-group-user-search__submit, .js-group-user-add').hide();
  $('.js-group-user-search').on('submit', function(e){ e.preventDefault(); });

  var userQueryPath = function(query){
    return $('.js-group-user-search')
             .attr('action')
             .split('?')[0] + '?uq=' + query;
  };

  var userQuery = function(query, syncResults, asyncResults){
    return $.getJSON(userQueryPath(query), function(data){
      return asyncResults(data);
    });
  };

  var resultTemplate = function(data){
    return '<div class="js-typeahead__suggestion">' + data.text + '</div>';
  };

  $('.js-group-user-search__query').typeahead({
    minLength: 3,
    highlight: true
  }, {
    name: 'users',
    display: 'text',
    source: userQuery,
    templates: {
      empty: [
        '<div class="js-typeahead__empty-message">',
        '  No accounts match the current query.',
        '</div>'
      ].join('\n'),
      suggestion: resultTemplate
    }
  });

  $('.js-group-user-search__query')
    .bind('typeahead:select', function(ev, suggestion) {
      $('.js-group-user-add__id').val(suggestion.id);
      $('.js-group-user-add').submit();
    });
});
