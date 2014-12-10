$ ->
  
  
  # FUNCTIONS
  
  showFormErrors = ($form, errors) ->
    for error, message of errors
      $form.find('#' + error).addClass('error').after($('<div>', {class: 'note error'}).text(message))
    $('html, body').animate({ scrollTop: $form.find('.error').first().offset().top - 40 }, 'fast')
  
  
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