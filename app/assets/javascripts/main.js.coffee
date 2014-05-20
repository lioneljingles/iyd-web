$ ->

  
  # JQUERY OBJECTS
  
  $overlay = $('#overlay')
  $userMenu = $('header ul#user-menu')
  
  
  # FUNCTIONS
  
  showFormErrors = ($form, errors) ->
    for error, message of errors
      $form.find('#' + error).addClass('error').after($('<div>', {class: 'note error'}).text(message))
    $('html, body').animate({ scrollTop: $form.find('.error').first().offset().top - 40 }, 'fast');
  
  
  # INTERACTION EVENTS
  
  $('body').click (event) ->
    if $userMenu.is(':visible')
      $userMenu.slideUp('fast') 
      $('header ul.nav li.user.selected').removeClass('selected')
  
  $('header ul.nav li.user a').click (event) ->
    $li = $(this).closest('li')
    if $li.hasClass('selected')
      $li.removeClass('selected')
    else
      $li.addClass('selected')
      event.stopPropagation()
      $userMenu.slideDown('fast')
  
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
      else if id == 'number'
        value = value.replace(/[^\d.-]/g, '')
        if value
          $input.val(value)
        else
          errors[id] = 'Phone number is invalid.'
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
      $overlay.css(top: $(window).scrollTop() + 80).show('fast').find('.content').html(data)
  
  
  # INFINITE FRONT PAGE
  
  $main = $('#main.landing')
  $footer = $('footer')
  
  $template = $(this).find('.row.template').clone()
  row = 0
  has_more = true
  loading_count = 1
  tag = window.location.hash.substring(1)
  
  addRow = (count) ->
    $.get '/org-list', {row: row, tag: tag}, (data) ->
      if (data.success == true)
        $main.find(".row[data-row='#{data.row}'] .tile").each (i, tile) ->
          $tile = $(tile).removeClass('loading')
          if i of data.orgs
            org = data.orgs[i]
            $cover = $tile.find('.cover').css('background-image': "url('#{org.image}')")
            $cover.find('.title').text(org.name)
            $tile.find('.org-info .summary').text(org.summary)
            $tile.find('a.button, a.title, a.info').attr(href: org.path)
            $tile.find('a.contact').attr(href: org.contact)
            has_more = data.has_more
            loading_count--
          else
            has_more = false
            if ((row == 0 and i == 1) or (row != 0 and i == 0))
              $tile.closest('.row').remove()
            else
              $tile.remove()
            return false
  
  if $main.length > 0
    addRow(row)
    $(window).scrollTop(0) if $(window).scrollTop() > 0
    $(window).on 'scroll.infinite', ->
      if has_more and loading_count < 5
        if $(window).scrollTop() + $(window).height() >= $footer.offset().top - 10
          row++
          loading_count++
          $row = $template.clone()
          $row.attr('data-row': row)
          $main.append($row)
          addRow(row)  
  
  # TAG LOGIC
  
  if tag
    $('.tag').each (i, element) ->
      $tag = $(element)
      if $tag.text() == tag
        $('.tag.selected').removeClass('selected')
        $tag.addClass('selected')
  
  $('.tag').click ->
    $tag = $(this)
    if $tag.hasClass('selected')
      return
    else
      $('.tag.selected').removeClass('selected')
      $tag.addClass('selected')
      if $tag.hasClass('all')
        tag = ''
      else
        tag = $tag.text()
      window.location.hash = '#' + tag
      row = 0
      has_more = true
      loading_count = 1
      isComplete = false
      $main.find('.row').each (i, element) ->
        $row = $(element)
        if $row.attr('data-row') == '0'
          isComplete = true if i == 2
          $row.find('.tile').addClass('loading').find('.cover').css('background-image': '')
        else
          $row.remove()
      unless isComplete
        $main.find('.row:gt(0)').remove()
        $row = $template.clone()
        $row.attr('data-row': row)
        $main.append($row)
      addRow(row)






