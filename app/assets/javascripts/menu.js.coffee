$ ->
  
  $overlay = $('#overlay')
  $nav = $('header ul.nav')
  $userMenu = $('header ul#user-menu')
  
  
  # OVERLAY
  
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

  $('body').on 'click', 'a[data-remote="true"]', (event) ->
    $target = $(this)
    message = ''
    if $target.hasClass('register') and $nav.find('li.logout:visible').length > 0
      message = 'You must log out before registering.'
    if $target.attr('id') == 'reset-password'
      email = $overlay.find('form input#email').val()
      if App.Utils.isValidEmail(email)
        $target.attr(href: $target.attr('href') + '?email=' + encodeURIComponent(email))
      else
        message = 'Please enter your e-mail address to reset your password.'
    if message
      alert(message)
      event.preventDefault()
      event.stopPropagation()
  
  
  # AJAX LINKS
  
  $('body').on 'ajax:success', 'a[data-remote="true"], form[data-remote="true"]', (event, data, xhr) ->
    $target = $(event.target)
    if $target.attr('id') == 'login-form'
      if data.success == true
        location.reload()
      else
        $(this).find('.error').show('fast')
    else if $target.closest('li').hasClass('logout')
      location.reload()
    else
      $overlay.css(top: $(window).scrollTop() + 80).show('fast').find('.content').html(data)
  
  
  # SELECT / OPTION DROPDOWNS
  
  $('body').on 'click', (event) ->
    $target = $(event.target)
    if $target.is('li.user, li.user *')
      $li = $target.closest('li.user')
      if $li.hasClass('selected')
        $li.removeClass('selected')
        $userMenu.removeClass('open')
      else
        $li.addClass('selected')
        $userMenu.addClass('open')
    else if $target.is('.select, .select >, .select span.current')
      $select = $target.closest('.select')
      if $select.hasClass('open')
        $select.removeClass('open')
      else
        $('.select').not($target).removeClass('open')
        $select.addClass('open')
    else if $target.is('.select ul.options li')
      $select = $target.closest('.select').removeClass('open')
      $select.find('.current').text($target.text())
      $select.closest('.form-row').find('input[type="hidden"]').val($target.attr('data-value'))
    else
      $('.select.open').removeClass('open')
      $('li.user.selected').removeClass('selected')

