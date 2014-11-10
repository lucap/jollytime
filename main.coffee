---
---

$ ->
  FB = new Firebase('https://jollytime.firebaseIO.com')

  conversation_template = $('#conversation_template').html()
  Mustache.parse(conversation_template)

  bind_user_list = (current_user_data) ->
    FB.child('users').on('child_added', (snapshot) ->
      new_user_data = snapshot.val()
      if new_user_data.uid != current_user_data.uid
        $('.user_list').append(
          $( "<div></div>", {text: new_user_data.name, class: new_user_data.uid})
            .click((e) -> 
              cid = [current_user_data.uid, $(this).attr('class')].sort().join('-')
              bind_conversation(cid, current_user_data)
              $(this)
                .addClass('highlight')
                .siblings().removeClass('highlight')
            )
        )
    )

  bind_conversation = (cid, current_user_data) ->
    if not $(".current_views .#{cid}").length
      $(".current_views").append("<div class='#{cid}'></div>")
      rendered = Mustache.render(conversation_template)
      $(".current_views .#{cid}").html(rendered)
    
    $(".current_views .#{cid}")
      .show()
      .siblings().hide()

    $(".current_views .#{cid} .send").click ->
      text = $('.input').val()
      if text? and text != ''
        FB.child('conversations')
          .child(cid)
          .push({content: text, uid: current_user_data.uid})
        $('.input').val('')

    FB.child('conversations').child(cid).on('child_added', (snapshot) ->
      msg = snapshot.val()
      console.log cid, msg
      side = if msg.uid == current_user_data.uid then 'right' else 'left'
      $(".#{side} .messages").append($( "<div></div>", {text: msg.content}))
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

    current_user = FB.child('users').child(user.uid)
    current_user.on('value', (snapshot) -> 
      current_user_data = snapshot.val() or {}
      if _.isEmpty(current_user_data)
        # first time user
        current_user_data.name = user.displayName
        current_user_data.uid = CryptoJS.SHA1(user.uid).toString()
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

