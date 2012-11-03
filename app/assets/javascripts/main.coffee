$(window).load ->
  $("#loading").fadeOut()

  $('.playlists a').click ->
    $playlist = $(@)

    pos = $playlist.index()

    if $playlist.hasClass('active')
      return

    $('.playlists a').removeClass('active')
    $playlist.addClass('active')
    $('.title h2').text($playlist.data('title'))
    $('.embeds iframe').attr('src', $playlist.data('url'))

    $currentBg = $('.backgrounds .background.active')
    $nextBg = $('.backgrounds .background').eq(pos)

    $currentBg.hide().removeClass('active')
    $nextBg.show().addClass('active')