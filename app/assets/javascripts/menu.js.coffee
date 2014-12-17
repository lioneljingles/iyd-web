$ ->
  
  $overlay = $('#overlay')
  $nav = $('header ul.nav')
  $userMenu = $('header ul#user-menu')
  
  
  # AJAX LINKS

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

