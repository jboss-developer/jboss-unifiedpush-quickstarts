### 3. Customize and Build Application for Angular

Please first refer to the Cordova guide located in this [README](../README.md)

* In `www/js/controllers.js` find the _pushConfig_ (at the top) and change _pushServerURL_ with the url of your Unified Push Server instance. You also need to change _senderID_, _variantID_ and _variantSecret_ with the values assigned by Unified Push Server and GCM or APNS:


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


**Note:** You can also copy/paste these settings from your Unified Push Server console

* In `www/js/app.js` change the value of _BACKEND_URL_ with the url of your Unified Push Server instance. Use `ip` or `hostname` and not `localhost` for the `host` value:


        //app.js    
        .constant('BACKEND_URL','< backend URL e.g http(s)//host:port >/jboss-push-contacts-mobile-picketlink-secured/')


**Important:** Make sure that the Unified Push Server instance can be reached from your device (start the JBoss EAP server with the parameters `-b 0.0.0.0`).
