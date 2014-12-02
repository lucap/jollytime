---
---

app = angular.module("jollyApp", ["firebase"])

app.factory "Auth", [ "$firebaseAuth", 
  ($firebaseAuth) ->
    ref = new Firebase("https://jollytime.firebaseIO.com")
    return $firebaseAuth(ref)
]

app.controller "AuthCtrl", [ "$scope", "Auth"
  ($scope, Auth) ->
    $scope.logout = ->
      Auth.$unauth()
      $scope.user = null
      
    $scope.login = ->
      Auth.$authWithOAuthPopup('google')
        .then((authData) -> $scope.user = authData)
        .catch((error) -> console.log('Authentication failed:', error))

]


