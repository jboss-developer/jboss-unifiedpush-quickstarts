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

var backend = angular.module('quickstart.services', []);

backend.factory('authz', function ($http, $resource) {
  return {
    setCredentials: function (username, password) {
      var encoded = btoa(username + ':' + password);
      $http.defaults.headers.common.Authorization = 'Basic ' + encoded;
    },
    clearCredentials: function () {
      document.execCommand("ClearAuthenticationCache");
      $http.defaults.headers.common.Authorization = 'Basic ';
    }
  };
});

backend.factory('users', function ($resource, BACKEND_URL) {
  return $resource(BACKEND_URL.replace(/\/+$/, '') + '/rest/security/:method/:verb', {}, {
    login: {
      method: 'GET',
      params: {
        method: 'user',
        verb: 'info'
      }
    },
    register: {
      method: 'POST',
      params: {
        method: 'registration'
      }
    },
    query: {
      method: 'GET',
      isArray: true,
      params: {
        method: 'user'
      }
    },
    logout: {
      method: 'POST',
      params: {
        method: 'logout'
      }
    }
  });
});

backend.factory('contacts', function ($resource, BACKEND_URL) {
  return $resource(BACKEND_URL.replace(/\/+$/, '') + '/rest/contacts/:id', {
    id: '@id'
  }, {
    get: {
      method: 'GET'
    },
    query: {
      method: 'GET',
      isArray: true,
      timeout: 4000
    },
    deleteContact: {
      method: 'DELETE'
    },
    update: {
      method: 'PUT'
    }
  });
});
