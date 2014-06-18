---
---

$ ->
  FB = new Firebase('https://jollytime.firebaseIO.com')
  conversation_template = $('#conversation_template').html()
  Mustache.parse(conversation_template)
  
  #var rendered = Mustache.render(template, {name: "Luke"});
  #$('#target').html(rendered);

  bind_user_list = (current_name) ->
    FB.child('users').on('child_added', (snapshot) ->
      user_data = snapshot.val()
      if user_data.name != current_name
        $('.user_list').append(
          $( "<a></a>", {text: user_data.name, class: "user", href: "##{user_data.uid}"})
        )
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
    $('.name').text(user.displayName).show()
    $('.login').hide()
    $('.logout').show()
    $('.current_views').show()

    current_user = FB.child('users').child(user.uid)
    current_user.on('value', (snapshot) -> 
      if not snapshot.val()
        user_data = 
          name: user.displayName
          uid: user.uid # should be a hash of the name
        current_user.set(user_data)
      bind_user_list(user.displayName)
    )

  logged_out = ->
    $('.email').hide().text('')
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

  #$('.user').click((e) -> console.log 'hi')
  #  #console.log 'i'
  #  console.log $(@).attr('class')
  #  e.preventDefault()
  #  false
  #)
