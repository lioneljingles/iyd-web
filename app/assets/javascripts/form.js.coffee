$ ->
  
  $overlay = $('#overlay, #content > form')
  
  
  # FUNCTIONS
  
  showFormErrors = ($form, errors) ->
    for error, message of errors
      $form.find('#' + error).addClass('error').after($('<div>', {class: 'note error'}).text(message))
    $('html, body').animate({ scrollTop: $form.find('.error').first().offset().top - 40 }, 'fast')
  
  
  # FORM UI
  
  $overlay.on 'click', (event) ->
    $target = $(event.target)
    if $target.hasClass('close')
      $overlay.hide 'fast', ->
        $target.find('.content').empty()
    if $target.hasClass('tag')
      if event.target.tagName.toLowerCase() != 'input'
        $target.closest('.tag').find('input[type="checkbox"]').click()
    if $target.hasClass('select-file')
      $target.closest('.form-row').find('input[type="file"]').click()
    if $target.is('.radio label')
      $target.closest('.radio').find('input[type="radio"]').click()
    if $target.is('input#opp_duration_dates')
      $target.closest('form').find('#date-fields').addClass('open')
    if $target.is('input#opp_duration_ongoing')
      $target.closest('form').find('#date-fields').removeClass('open')
    
  $overlay.on 'change', 'form .form-row input[type="file"]', ->
    filename = this.files[0].name
    $row = $(this).closest('.form-row')
    if (/\.(gif|jpg|jpeg|tiff|png)$/i).test(filename)
      $row.find('span.file-name').text(this.files[0].name)
      $row.find('a.select-file').text('(change...)')
    else
      alert('Invalid image file. Please select one of the following types of files: gif, jpg, jpeg, tiff, png')
      $(this).replaceWith($(this).clone())
      $row.find('span.file-name').text('')
      $row.find('a.select-file').text('Select Image...')
  
  
  # FORM VALIDATION
  
  $('body').on 'submit', 'form', (event) ->
    $form = $(this)
    errors = {}
    $form.find('.form-row div.error').remove()
    $form.find('input:not(:radio), textarea').each (index, input) ->
      $input = $(input)
      id = $input.attr('id') || ''
      value = $input.val()
      $input.removeClass('error')
      if value.replace(/\s+/g, '') == '' and not $input.attr('data-optional')
        errors[id] = 'Field cannot be blank.'
      else if id.indexOf('email') >= 0 and not App.Utils.isValidEmail(value)
        errors[id] = 'Please enter a valid email address.'
      else if id.indexOf('password') >= 0 and value.length < 6
        errors[id] = 'Your password must have at least 6 characters.'
      else if id.indexOf('password_confirmation') >= 0 and value != $form.find('input[id*="_password"]').val()
        errors[id] = 'Password and password confirmation don\'t match.'
      else if id.indexOf('website') >= 0 and value and not App.Utils.isValidUrl(value)
        errors[id] = 'Please enter a valid website URL.'
      else if id.indexOf('summary') >= 0 and value.length > 400
        errors[id] = 'Summary is too long. Please use 400 characters or less.'
      else if id.indexOf('number') >= 0
        value = value.replace(/[^\d.-]/g, '')
        if value
          $input.val(value)
        else
          errors[id] = 'Phone number is invalid.'
      else if id.indexOf('date') >= 0 and $('#opp_duration_dates:checked').length > 0
        timestamp = Date.parse(value)
        if isNaN(timestamp) and (value or id.indexOf('start_date') >= 0)
          errors[id] = 'Please enter a valid date.'
        else if id.indexOf('start_date') >= 0 and timestamp < Date.now()
          errors[id] = 'The start date must be in the future.'
        else if id.indexOf('end_date') >= 0
          startTimestamp = Date.parse($('#opp_start_date').val())
          if !isNaN(startTimestamp) and startTimestamp >= Date.parse(value)
            errors[id] = 'The end date must be after the start date.'
                
    unless App.Utils.isEmpty(errors)
      showFormErrors($form, errors)
      event.preventDefault()
    
  unless App.Utils.isEmpty(App.errors)
    showFormErrors($('form').first(), App.errors)