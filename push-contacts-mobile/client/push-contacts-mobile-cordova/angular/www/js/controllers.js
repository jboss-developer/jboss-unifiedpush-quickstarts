/*
 * JBoss, Home of Professional Open Source
 * Copyright Red Hat, Inc., and individual contributors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * 	http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
'use strict';

angular.module('quickstart.controllers', [])

.controller('ContactsCtrl', function ($scope, contacts) {
  $scope.details = false;
  $scope.showDelete = false;
  $scope.refresh = function () {
    contacts.query({}, function (data) {
      var first,
        length = data.length;
      $scope.groupedContacts = {};

      for (var i = 0; i < length; i++) {
        first = data[i].firstName.substring(0, 1).toUpperCase();
        if (!$scope.groupedContacts[first]) {
          $scope.groupedContacts[first] = [];
        }

        $scope.groupedContacts[first].push(data[i]);
      }
    });
  };
  $scope.refresh();
  $scope.$on('refresh', $scope.refresh);
  $scope.deleteContact = function (contact) {
    contacts.deleteContact({
      id: contact.id
    }, function () {
      removeContact(contact);
    }, function (error) {
      if (error.status === 400) {
        //contact already removed by somebody else
        removeContact(contact);
      }
    });
  };

  function removeContact(contact) {
    var letter = contact.firstName.substring(0, 1).toUpperCase();
    $scope.groupedContacts[letter].splice($scope.groupedContacts[letter].indexOf(contact), 1);
    if ($scope.groupedContacts[letter].length === 0) {
      delete $scope.groupedContacts[letter];
    }
    $scope.showDelete = false;
  }
})

.controller('ContactCtrl', function ($scope, $stateParams, contacts, $location) {
  if ($stateParams.id) {
    contacts.get({
      id: $stateParams.id
    }, function (contact) {
      $scope.model = contact;
    });
  }
  var form;
  $scope.setFormScope = function (scope) {
    form = scope;
  };

  $scope.clearErrors = function (field) {
    form.form[field].$setValidity('server', true);
  };

  $scope.save = function (contact) {
    if ($stateParams.id) {
      contacts.update(contact, onSuccess, onFailure);
    } else {
      contacts.save(contact, onSuccess, onFailure);
    }

    function onSuccess() {
      $location.url('/app/contacts');
    }

    function onFailure(response) {
      angular.forEach(response.data, function (error, key) {
        form.form[key].$dirty = true;
        form.form[key].$setValidity('server', false);
        form.form[key].error = error;
      });
    }
  };
})

.controller('LoginCtrl', function ($scope, $rootScope, $location, authz, users) {
  function registerWithUPS() {
    var pushConfig = {
      pushServerURL: "<pushServerURL e.g http(s)//host:port/context >",
      android: {
        senderID: "<senderID e.g Google Project ID only for android>",
        variantID: "<variantID e.g. 1234456-234320>",
        variantSecret: "<variantSecret e.g. 1234456-234320>"
      },
      ios: {
        variantID: "<variantID e.g. 1234456-234320>",
        variantSecret: "<variantSecret e.g. 1234456-234320>"
      }
    };

    //to be able to test this in your browser where there is no push plugin installed
    if (typeof push !== "undefined") {
      push.register(onNotification, successHandler, errorHandler, pushConfig);
    }

    function successHandler() {
      console.log('successful registered');
    }

    function errorHandler(error) {
      alert('error registering ' + error);
    }

    function onNotification(event) {
      if (event['content-available'] === 1) {
        if (!event.foreground) {
          $location.url('/app/contact/' + event.payload.id);
          $scope.$apply();
        } else {
          $rootScope.$broadcast('refresh');
          push.setContentAvailable(push.FetchResult.NewData);
        }
      } else {
        $rootScope.$broadcast('notification', event);
      }
    }
  }

  $scope.login = function (user) {
    authz.setCredentials(user.name, user.password);
    users.login({}, function () {
      registerWithUPS();
      $location.url('/app/contacts');
    });
  };
  $scope.signup = function (data) {
    users.register(data, function () {
      $location.url('/app/login');
    });
  };
  $scope.logout = function () {
    users.logout({}, function () {
      $location.url('/app/login');
    });
  };

  $scope.dismissAlert = function (id) {
    delete $scope.notification;
    if (id) {
      $location.url('/app/contact/' + id);
    }
  };
  $scope.$on('notification', function (scope, event) {
    $scope.notification = event;
    $scope.$apply();
    //event.payload. event.alert
  });
});
