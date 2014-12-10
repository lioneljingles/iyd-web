$ ->
  
  row = 0
  has_more = true
  loading_count = 1
  search = ''
  tag = ''
  district = -1
  
  $landing = $('#main.landing')
  $template = $(this).find('.row.template').clone()
  $search = $('#search.field')
  $district = $('#district.field')
  $tag = $('#tag.field')
  $footer = $('footer')
  $controls = $('#controls.organizations')
  
  if window.location.hash
    tag = window.location.hash.substring(1)
    $tag.find("li:contains('#{tag}')").each ->
      $tag.find('.current').text($(this).text())
  
  $('body').on 'click', 'ul.tags li a', ->
    $this = $(this)
    clearFields()
    tag = $this.text()
    $tag.find("li:contains('#{tag}')").each ->
      $tag.find('.current').text($this.text())
    getOrgs()
  
  $controls.on 'click', (event) ->
    $target = $(event.target)
    if $target.is('#search .icon')
      search = $search.find('input').val()
      getOrgs()
    else if $target.is('a.btn')
      clearFields()
      getOrgs()
    else if $target.is('.field li')
      $field = $target.closest('.field')
      if $field.is($district)
        district = if $target.hasClass('none') then -1 else $target.attr('data-value')
      else if $field.is($tag)
        tag = if $target.hasClass('none') then '' else $target.text()
      getOrgs()
  
  $search.find('input').keydown (event) ->
    if event.keyCode == 13
      search = $(this).val()
      getOrgs()
  
  clearFields = ->
    search = ''
    tag = ''
    district = -1
    $search.find('input').val('')
    $tag.find('.current').text($tag.find('.none').text())
    $district.find('.current').text($district.find('.none').text())
  
  addRow = (count) ->
    $.get '/org-list', {row: row, district: district, tag: tag, search: search}, (data) ->
      if (data.success == true)
        $landing.find(".row[data-row='#{data.row}'] .tile").each (i, tile) ->
          $tile = $(tile).removeClass('loading')
          if i of data.orgs
            org = data.orgs[i]
            $cover = $tile.find('.cover').css('background-image': "url('#{org.image}')")
            $cover.find('.title .name').text(org.name)
            $cover.find('.title .location').html(org.location)
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
              $landing.find('p.none').hide()
          else
            has_more = false
            if row == 0 and i == 0
              $landing.find('p.none').show()
              $tile.closest('.row').hide()
              $landing.find('.row.template').remove()
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
    if tag
      location.hash = tag
    $('body').animate({scrollTop: 0}, 'fast') if $('body').scrollTop() > 0
    $landing.find('.row').each (i, element) ->
      $row = $(element)
      if $row.attr('data-row') == '0'
        isComplete = true if i == 2
        $row.find('.tile').addClass('loading').find('.cover').css('background-image': '')
      else
        $row.remove()
    unless isComplete
      $landing.find('.row:gt(0)').remove()
      $row = $template.clone()
      $row.attr('data-row': row)
      $landing.append($row)
    addRow(row)
  
  if $landing.length > 0
    addRow(row)
    $('body').scrollTop(0) if $(window).scrollTop() > 0
    $(window).on 'scroll.infinite', ->
      if has_more and loading_count < 5
        if $(window).scrollTop() + $(window).height() >= $footer.offset().top - 10
          row++
          loading_count++
          $row = $template.clone()
          $row.attr('data-row': row)
          $landing.append($row)
          addRow(row)


