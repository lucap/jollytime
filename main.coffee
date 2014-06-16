---
---

$ ->
  FB = new Firebase('https://jollytime.firebaseIO.com')
  
  bind_user_list = (current_name) ->
    FB.child('users').on('child_added', (snapshot) ->
      if snapshot.val().name != current_name
        $('.user_list').append($( "<div></div>", {text: snapshot.val().name}))
    )

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
    $('.name').show()
    $('.name').text(user.displayName)
    $('.login').hide()
    $('.logout').show()
    $('.current_views').show()

    current_user = FB.child('users').child(user.uid)
    current_user.on('value', (snapshot)-> 
      if not snapshot.val()
        current_user.set({name: user.displayName})
      bind_user_list(user.displayName)
    )

  logged_out = ->
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

