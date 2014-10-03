---
---

$ ->
  FB = new Firebase('https://jollytime.firebaseIO.com')
  loggedin_user = null

  conversation_template = $('#conversation_template').html()
  Mustache.parse(conversation_template)
  
  #var rendered = Mustache.render(template, {name: "Luke"});
  #$('#target').html(rendered);

  bind_user_list = (current_user_data) ->
    FB.child('users').on('child_added', (snapshot) ->
      new_user_data = snapshot.val()
      if new_user_data.uid != current_user_data.uid
        $('.user_list').append(
          $( "<div></div>", {text: new_user_data.name, class: new_user_data.uid})
            .click((e) -> 
              console.log $(this).attr('class')
              console.log loggedin_user.uid
              cid = [loggedin_user.uid, $(this).attr('class')].sort().join('|')
              console.log cid

            )
        )
    )

  open_conversation = (conversation_id) ->
    FB.child('conversations').child(conversation_id).on('child_added', (snapshot) ->
      msg = snapshot.val()
      console.log msg
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
    $('.user_list').show()

    loggedin_user = user

    current_user = FB.child('users').child(user.uid)
    current_user.on('value', (snapshot) -> 
      current_user_data = snapshot.val() or {}
      if _.isEmpty(current_user_data)
        # first time user
        current_user_data.name = user.displayName
        current_user_data.uid = user.uid # could be a hash of the name
        current_user.set(current_user_data)
      bind_user_list(current_user_data)
    )

  logged_out = ->
    $('.email').hide().text('')
    $('.login').show()
    $('.logout').hide()
    $('.current_views').hide()
    $('.name').empty().hide()
    $('.user_list').empty().hide()

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
