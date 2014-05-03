$ ->
  
  
  # JQUERY OBJECTS
  
  $overlay = $('#overlay')
  
  
  # FUNCTIONS
  
  showFormErrors = ($form, errors) ->
    for error, message of errors
      $form.find('#' + error).addClass('error').after($('<div>', {class: 'note error'}).text(message))
    $('html, body').animate({ scrollTop: $form.find('.error').first().offset().top - 40 }, 'fast');
  
  
  # INTERACTION EVENTS
  
  $overlay.on 'click', '.close', ->
    $overlay.hide 'fast', ->
      $(this).find('.content').empty()
  
  $overlay.on 'click', 'form .form-row .tag', (event) ->
    if event.target.tagName.toLowerCase() != 'input'
      $(this).closest('.tag').find('input[type="checkbox"]').click()
      
  $overlay.on 'click', 'form .form-row .select-file', ->
    $(this).closest('.form-row').find('input[type="file"]').click()
    
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

  
  # FORM VALIDATIONS
  
  $('body').on 'submit', 'form', ->
    $form = $(this)
    errors = {}
    $form.find('.form-row div.error').remove()
    $form.find('input, textarea').each (index, input) ->
      $input = $(input)
      id = $input.attr('id')
      value = $input.val()
      $input.removeClass('error')
      if value.replace(/\s+/g, '') == ''
        errors[id] = 'Field cannot be blank.'
      else if id == 'email' and not App.Utils.isValidEmail(value)
        errors[id] = 'Please enter a valid email address.'
      else if id == 'password' and value.length < 6
        errors[id] = 'Your password must have at least 6 characters.'
      else if id == 'password_confirmation' and value != $form.find('input#password')
        errors[id] = 'Password and password confirmation don\'t match.'
      else if id == 'website' and not App.Utils.isValidUrl(value)
        errors[id] = 'Please enter a valid website URL.'
    if App.Utils.isEmpty(errors)
      true
    else
      showFormErrors($form, errors)
      false
    
  unless App.Utils.isEmpty(App.errors)
    showFormErrors($('form').first(), App.errors)
  
  
  # AJAX EVENTS
  
  $('body').on 'click', 'a[data-remote="true"]', (event) ->
    $target = $(this)
    message = ''
    if $target.hasClass('register') and $('header ul li.logout:visible').length > 0
      message = 'You must log out before registering.'
    if $target.attr('id') == 'reset-password'
      email = $overlay.find('form input#email').val()
      if App.Utils.isValidEmail(email)
        $target.attr(href: $target.attr('href') + '?email=' + email)
      else
        message = 'Please enter your e-mail address to reset your password.'
    if message
      alert(message)
      event.preventDefault()
      event.stopPropagation()
  
  $('body').on 'ajax:success', 'a[data-remote="true"], form[data-remote="true"]', (event, data, xhr) ->
    $target = $(event.target)
    if $target.attr('id') == 'login-form'
      if data.success == true
        $('header ul').addClass('logged-in')
        $('header li.org-link a').attr(href: data.url).find('span').text(data.name)
        $overlay.hide 'fast', ->
          $(this).find('.content').empty()
      else
        $(this).find('.error').show('fast')
    else if $target.closest('li').hasClass('logout')
      $('header ul').removeClass('logged-in')
    else
      $overlay.show('fast').find('.content').html(data)
  
  
  # INFINITE FRONT PAGE
  
  $main = $('#main.landing')
  $footer = $('footer')
  
  $template = $(this).find('.row.template').clone()
  row = 0
  tag_id = ''
  has_more = true
  loading_count = 1
  
  addRow = (row) ->
    $.get '/org-list', {row: row, tag_id: tag_id}, (data) ->
      if (data.success == true)
        $main.find(".row[data-row='#{data.row}'] .tile").each (i, tile) ->
          $tile = $(tile).removeClass('loading')
          if i of data.orgs
            org = data.orgs[i]
            $cover = $tile.find('.cover').css('background-image': "url('#{org.image}')")
            $cover.find('.title').text(org.title)
            $tile.find('.org-info .summary').text(org.summary)
            $tile.find('a').attr(href: org.path)
            has_more = data.has_more
            loading_count--
          else
            $tile.remove()
  
  if $main.length > 0
    addRow(row)
    $(window).on 'scroll.infinite', ->
      if has_more and loading_count < 5
        if $(window).scrollTop() + $(window).height() >= $footer.offset().top - 10
          row++
          loading_count++
          $row = $template.clone()
          $row.attr('data-row': row)
          $main.append($row)
          addRow(row)
      else if not has_more
        $(window).off 'scroll.infinite'
  
  
  # TAG LOGIC
  
    $('.tag').click ->
      $tag = $(this)
      if not $tag.hasClass('selected')
        $('.tag.selected').removeClass('selected')
        $tag.addClass('selected')
      if $tag.hasClass('all')
        tag_id = ''
      else
        tag_id = $tag.attr('data-id')
      $main.find('.row').each (i, row) ->
        $row = $(row)
        if $row.attr('data-row') == '0'
          row = 0
          has_more = true
          loading_count = 1
          addRow(row)
          $row.find('.tile').addClass('loading').find('.cover').css('background-image': '')
        else
          $row.remove()












