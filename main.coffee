---
---

$ ->
  FB = new Firebase('https://jollytime.firebaseIO.com')
  auth = new FirebaseSimpleLogin(FB, (error, user) ->
    if error
      # an error occurred while attempting login
      console.log error
    else if user
      # user authenticated with Firebase
      logged_in(user)
    else
      logged_out()
  )

  logged_in = (user) ->
    console.log "User email: " + user.email
    $('.email').show()
    $('.email').text(user.email)
    $('.login').hide()
    $('.logout').show()
    $('.current_views').show()

  logged_out = ->
    console.log "logged out"
    $('.email').text('')
    $('.email').hide()
    $('.login').show()
    $('.logout').hide()
    $('.current_views').hide()

  $('.login').click ->
    auth.login('google')

  $('.logout').click ->
    auth.logout()

  $('.send').click ->
    text = $('.input').val()
    if text?
      msg = $( "<div></div>", {text: text})
      $('.thread').append(msg)
      $('.input').val('')

