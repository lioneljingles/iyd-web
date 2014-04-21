$ ->
  
  # JQUERY OBJECTS
  
  $overlay = $('#overlay')
  
  
  # INTERACTION EVENTS
  
  $('#overlay').on 'click', 'form .form-row .tag', (event) ->
    if event.target.tagName.toLowerCase() != 'input'
      $(this).closest('.tag').find('input[type="checkbox"]').click()
      
  $('#overlay').on 'click', 'form .form-row #select-image', (event) ->
    $(this).closest('.form-row').find('input#image').click()
  
  # AJAX EVENTS
  $('a[data-remote="true"]').bind 'ajax:success', (event, data, xhr) ->
    $overlay.show('fast').find('.content').html(data)
    $overlay.find('.close').click ->
      $overlay.hide 'fast', ->
        $(this).find('.content').empty()