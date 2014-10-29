### 3. Customize and Build Application for JQuery Mobile

Please first refer to the Cordova guide located in this [README](../README.md)

* In `www/push-config.json` change _pushServerURL_ with the url of your Unified Push Server OpenShift instance. You also need to change _senderID_, _variantID_ and _variantSecret_ with the values assigned by Unified Push Server OpenShift instance and GCM or APNS:


        {
           "pushServerURL": "<pushServerURL e.g https://{OPENSHIFT_UNIFIEDPUSHSERVER_URL}/ag-push >",
           "android": {
              "senderID": "<senderID e.g Google Project ID only for android>",
              "variantID": "<variantID e.g. 1234456-234320>",
              "variantSecret": "<variantSecret e.g. 1234456-234320>"
           },
           "ios": {
              "variantID": "<variantID e.g. 1234456-234320>",
              "variantSecret": "<variantSecret e.g. 1234456-234320>"
           }
        }


**Note:** You can also copy/paste these settings from your Unified Push Server OpenShift instance console

* In `www/js/app.js` change the value of _CONTACTS.app.baseUrl_ with the url of your running `Push Contacts Mobile Picketlink Secured` instance. Use `ip` or `hostname` and not `localhost` for the `host` value:


        //app.js
        CONTACTS.app.baseUrl = "< backend URL e.g http(s)//host:port >/jboss-push-contacts-mobile-picketlink-secured/";

