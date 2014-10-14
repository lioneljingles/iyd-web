$ ->

  
  # JQUERY OBJECTS
  
  $overlay = $('#overlay')
  $nav = $('header ul.nav')
  $userMenu = $('header ul#user-menu')
  $main = $('#main.landing')
  $footer = $('footer')
  $template = $(this).find('.row.template').clone()
  $search = $('#search.field')
  $district = $('#district.field')
  $tag = $('#tag.field')
  
  
  # STATE VARIABLES
  
  row = 0
  has_more = true
  loading_count = 1
  search = ''
  tag = ''
  district = 0
  if window.location.hash
    tag = window.location.hash.substring(1)
    $tag.find("li:contains('#{tag}')").each ->
      $tag.find('.current').text($(this).text())
  
  # FUNCTIONS
  
  showFormErrors = ($form, errors) ->
    for error, message of errors
      $form.find('#' + error).addClass('error').after($('<div>', {class: 'note error'}).text(message))
    $('html, body').animate({ scrollTop: $form.find('.error').first().offset().top - 40 }, 'fast')
  
  
  # SELECT / OPTION DROPDOWNS
  
  $('body').on 'click', '.select', ->
    $select = $(this)
    if $select.hasClass('open')
      $select.removeClass('open')
    else
      $('.select').not($select).removeClass('open')
      $select.addClass('open')
  
  $('body').on 'click', '.select ul.options li', ->
    $option = $(this)
    $select = $option.closest('.select')
    $select.find('.current').text($option.text())
  
  $search.find('input').keydown (event) ->
    if event.keyCode == 13
      clearDistrict()
      clearTag()
      search = $(this).val()
      getOrgs()
  
  $search.find('.icon').click ->
    clearDistrict()
    clearTag()
    search = $search.find('input').val()
    getOrgs()
  
  $district.find('li').click ->
    clearSearch()
    clearTag()
    district = if $(this).hasClass('none') then 0 else $(this).attr('data-value')
    getOrgs()
  
  $tag.find('li').click ->
    clearSearch()
    clearDistrict()
    tag = if $(this).hasClass('none') then '' else $(this).text()
    getOrgs()
    
  $main.on 'click', 'ul.tags li a', ->
    clearSearch()
    clearDistrict()
    tag = $(this).text()
    $tag.find("li:contains('#{tag}')").each ->
      $tag.find('.current').text($(this).text())
    getOrgs()
  
  $('body').on 'click', '#district.select li', ->
    $('input#org_district').val($(this).attr('data-value'))
    
  
  # MENUS
  
  $('body').click (event) ->
    if $userMenu.is(':visible')
      $userMenu.slideUp('fast') 
      $nav.find('li.user.selected').removeClass('selected')
    unless $(event.target).closest('.select').length
      $('.select').removeClass('open')
  
  $nav.find('li.user a').click (event) ->
    $li = $(this).closest('li')
    if $li.hasClass('selected')
      $li.removeClass('selected')
    else
      $li.addClass('selected')
      event.stopPropagation()
      $userMenu.slideDown('fast')
  
  
  # OVERLAY
  
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
  
  $('body').on 'submit', 'form', (event) ->
    $form = $(this)
    errors = {}
    $form.find('.form-row div.error').remove()
    $form.find('input, textarea').each (index, input) ->
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
    unless App.Utils.isEmpty(errors)
      showFormErrors($form, errors)
      event.preventDefault()
    
  unless App.Utils.isEmpty(App.errors)
    showFormErrors($('form').first(), App.errors)
  
  
  # AJAX EVENTS
  
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
        $nav.addClass('logged-in')
        $userMenu.find('li.org-link a').attr(href: data.url).find('span').text(data.org)
        $nav.find('li.user span.email').text(data.email)
        $overlay.hide 'fast', ->
          $(this).find('.content').empty()
      else
        $(this).find('.error').show('fast')
    else if $target.closest('li').hasClass('logout')
      $nav.removeClass('logged-in')
    else
      $overlay.css(top: $(window).scrollTop() + 80).show('fast').find('.content').html(data)
  
  
  # INTERNAL FUNCTIONS
  
  clearSearch = ->
    search = ''
    $search.find('input').val('')
  
  clearTag = ->
    tag = ''
    $tag.find('.current').text($tag.find('.none').text())
  
  clearDistrict = ->
    district = 0
    $district.find('.current').text($district.find('.none').text())
  
  addRow = (count) ->
    $.get '/org-list', {row: row, district: district, tag: tag, search: search}, (data) ->
      if (data.success == true)
        $main.find(".row[data-row='#{data.row}'] .tile").each (i, tile) ->
          $tile = $(tile).removeClass('loading')
          if i of data.orgs
            org = data.orgs[i]
            $cover = $tile.find('.cover').css('background-image': "url('#{org.image}')")
            $cover.find('.title .name').text(org.name)
            $cover.find('.title .location').text(org.location)
            $tile.find('.org-info .summary').text(org.summary)
            $tile.find('a.button, a.title, a.info').attr(href: org.path)
            $tile.find('a.contact').attr(href: org.contact)
            $tile.find('ul.tags').empty()
            for name in org.tags
              $a = $('<a>', 
                href: "/\##{name}"
                class: 'tag'
              ).text(name)
              $li = $('<li>').append($a)
              $tile.find('ul.tags').append($li)
            has_more = data.has_more
            loading_count--
            if row == 0
              $tile.closest('.row:hidden').show()
              $main.find('p.none').hide()
          else
            has_more = false
            if row == 0 and i == 0
              $main.find('p.none').show()
              $tile.closest('.row').hide()
              $main.find('.row.template').remove()
            else if row == 0 and i == 1
              $tile.closest('.row').remove()
            else if row != 0 and i == 0
              $tile.closest('.row').remove()
            else
              $tile.remove()
            return false
  
  getOrgs = ->
    row = 0
    has_more = true
    loading_count = 1
    isComplete = false
    if search
      tag = ''
      location.hash = ''
      district = 0
    else if district
      tag = ''
      location.hash = ''
    else if tag
      location.hash = tag
    $('body').animate({scrollTop: 0}, 'fast') if $('body').scrollTop() > 0
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
  
  if $main.length > 0
    addRow(row)
    $('body').scrollTop(0) if $(window).scrollTop() > 0
    $(window).on 'scroll.infinite', ->
      if has_more and loading_count < 5
        if $(window).scrollTop() + $(window).height() >= $footer.offset().top - 10
          row++
          loading_count++
          $row = $template.clone()
          $row.attr('data-row': row)
          $main.append($row)
          addRow(row)





