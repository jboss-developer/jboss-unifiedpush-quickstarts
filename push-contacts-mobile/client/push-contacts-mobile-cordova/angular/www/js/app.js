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

angular.module('quickstart', [
  'ionic',
  'quickstart.controllers',
  'quickstart.services',
  'ngResource'
])

.constant('BACKEND_URL', '< backend URL e.g http(s)//host:port >/jboss-push-contacts-mobile-picketlink-secured')

.config(function ($stateProvider, $urlRouterProvider, $httpProvider) {
  $stateProvider

  .state('app', {
    url: "/app",
    abstract: true,
    templateUrl: "templates/menu.html",
    controller: 'LoginCtrl'
  })

  .state('app.login', {
    url: "/login",
    views: {
      'menuContent': {
        templateUrl: 'templates/login.html',
        controller: 'LoginCtrl'
      }
    }
  })

  .state('app.contact', {
    url: "/contact/:id",
    views: {
      'menuContent': {
        templateUrl: "templates/contact.html",
        controller: 'ContactCtrl'
      }
    }
  })

  .state('app.contacts', {
    url: "/contacts",
    views: {
      'menuContent': {
        templateUrl: "templates/contacts.html",
        controller: 'ContactsCtrl'
      }
    }
  })

  .state('app.about', {
    url: "/about",
    views: {
      'menuContent': {
        templateUrl: "templates/about.html"
      }
    }
  });

  // if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise('/app/contacts');

  var interceptor = function ($q, $location) {
    function success(response) {
      return response;
    }

    function error(response) {
      var status = response.status;
      if (status === 404 || status === 0) {
        alert('Backend server not responding, please check your backend URL settings');
      } else if (status === 401) {
        $location.url("/app/login");
        return;
      }
      // otherwise
      return $q.reject(response);
    }
    return function (promise) {
      return promise.then(success, error);
    };
  };
  $httpProvider.defaults.withCredentials = true;
  $httpProvider.responseInterceptors.push(interceptor);
});
