---
---

###
== proposed data model ==

  /jollytime
    /users
      <uid>
        email
        displayName
        /friends 
          [ uid
            name
            last_contact 
          ]
    /emails_to_uids
      <email> -> uid
    /conversations
      <conversation_id>
        <author_id> [
          message
          message_timestamp
        ]   

###

FB_BASE = "https://jollytime.firebaseIO.com"
app = angular.module("jollyApp", ["firebase"])

app.factory "Auth", [ "$firebaseAuth", 
  ($firebaseAuth) ->
    ref = new Firebase(FB_BASE)
    return $firebaseAuth(ref)
]

app.controller "AuthCtrl", [ "$scope", "Auth",
  ($scope, Auth) ->
    $scope.logout = ->
      Auth.$unauth()
      $scope.user = null
      
    $scope.login = ->
      Auth.$authWithOAuthPopup('google', {scope: 'email'})
        .then((authData) -> $scope.user = authData)
        .catch((error) -> console.log('Authentication failed:', error))
]

app.controller "FriendListCtrl", [ "$scope", "Auth",
  ($scope, Auth) ->
    $scope.user = ->
      Auth.$getAuth()

    $scope.friend_list = ->
      uid = $scope.user().uid
      ref = new Firebase(FB_BASE)
        .child('users')
        .child(uid)
        .child('friends')
        .orderBy("last_contact")

      $firebase(ref).$asArray()
]


