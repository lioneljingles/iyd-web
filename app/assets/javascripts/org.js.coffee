$ ->
  
  $('.org-info p.description').each (i, p) ->
    $p = $(p)
    $p.replaceWith(window.App.Utils.insertBreaks($p.html()))