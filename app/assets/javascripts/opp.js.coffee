$ ->
  
  row = 0
  has_more = true
  isLoading = false
  district = -1
  position = -1
  duration = -1
  
  $footer = $('footer')
  $opps = $('ul#opportunities')
  $loading = $opps.find('p.loading')
  $none = $opps.find('p.none')
  $template = $opps.find('li.template').clone().removeClass('template')
  $controls = $('#controls.opportunities')
  $district = $('#district.field')
  $position = $('#position.field')
  $duration = $('#duration.field')
  
  $controls.on 'click', (event) ->
    $target = $(event.target)
    if $target.is('.field li')
      $field = $target.closest('.field')
      value = if $target.hasClass('none') then -1 else $target.attr('data-value')
      hasChanged = true
      $field.find('span.current').text($target.text())
      if $field.is($district) and district != value
        district = value
      else if $field.is($position) and position != value
        position = value
      else if $field.is($duration) and duration != value
        duration = value
      else
        hasChanged = false
      if hasChanged
        row = 0
        has_more = true
        getOpps()
    else if $target.is('a.btn')
      $controls.find('.field .select').each (i, field) ->
        $field = $(field)
        $field.find('span.current').text($field.find('ul.options li.none').text())
      district = -1
      position = -1
      duration = -1
      getOpps()
  
  getOpps = ->
    isLoading = true
    has_more = true
    $none.hide()
    if row == 0
      $opps.children('li').remove()
      $loading.show()
    $.get '/opp-list', {row: row, district: district, position: position, duration: duration}, (data) ->
      isLoading = false
      $loading.hide()
      if data.opps and data.opps.length
        for opp in data.opps
          $li = $template.clone()
          $li.find('.cover').css('background-image': "url('#{opp.image}')")
          $li.find('h3').text(opp.title)
          $li.find('p.position span').text(opp.position)
          $li.find('p.duration span').text(opp.duration)
          $li.find('p.description').replaceWith(window.App.Utils.insertBreaks(opp.description))
          $li.find('.cover .name').text(opp.org_name)
          $li.find('.cover .location').html(opp.org_location)
          $li.find('.cover a').attr(href: opp.org_path)
          $li.find('a.btn').attr(href: opp.contact_path)
          $loading.before($li)
      else if data.opps
        has_more = false
        if data.row == 0
          $none.show()
  
  if $opps.length > 0
    getOpps()
    $(window).on 'scroll.infinite', ->
      if has_more and not isLoading
        if $(window).scrollTop() + $(window).height() >= $footer.offset().top - 10
          row++
          getOpps()
