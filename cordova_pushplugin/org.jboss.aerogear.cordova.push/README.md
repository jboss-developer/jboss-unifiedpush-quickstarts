# JBoss Unified Push PushPlugin for Cordova
---------

`JBoss Unified Push PushPlugin for Cordova` is an extension of the standard Cordova Push Plugin and provides support for integrating with push and registering Cordova applications with the JBoss Unified Push Server, while making your javascript less verbose and easier to maintain. It currently supports Google’s Cloud Messaging (GCM) and Apple's Push Notification Service (APNS) with the JBoss Unified Push Server.

## How do I use it?

### 0. System Requirements

* [Apache Cordova CLI](https://github.com/apache/cordova-cli/)
* [Node.js](http://nodejs.org/download/)
* Install Cordova by executing:
  
        npm install -g cordova
  
  To deploy on iOS you need to install also the ios-deploy package:
  
        npm install -g ios-deploy
  

### 1. Prerequisites

Before building the application, you must register the Android or iOS variant of the application with a running JBoss Unified Push Server instance and Google Cloud Messaging for Android or Apple Push Notification Service for iOS. The resulting unique IDs and other parameters must then be inserted into the application source code. After this is complete, the application can be built and deployed to Android or iOS devices.

For the configuration and registration of Android or iOS Applications with GCM or APNS, please refer to the specific guides inside `JBoss Unified Push for Android` and `JBoss Unified Push for iOS` libraries.

### 2. Use JBoss Unified Push PushPlugin for Cordova

Extract the `JBoss Unified Push PushPlugin for Cordova` and install it specifying the local path to the plugin directory that contains the `plugin.xml` file, executing the following command from within your project folder:

        cordova plugin add <path-to-org.jboss.aerogear.cordova.push-dir>


Done! Your project now contains the JBoss Unified Push PushPlugin. For an integration with the `JBoss Unified Push Server` open the `www` folder in your text editor and apply the code from the example below. You can then execute the project with the command:

        cordova run <android or ios>

## Example Usage
### 1. Register the application
The following JavaScript code shows how to register a device with the JBoss Unified Push Server. You need to change `pushServerURL` with the url of your JBoss Unified Push Server OpenShift instance. You also need to change `senderID`, `variantID` and `variantSecret` with the values assigned by JBoss Unified Push Server and GCM or APNS:

        var pushConfig = {
            pushServerURL: "<pushServerURL e.g https://{OPENSHIFT_UNIFIEDPUSHSERVER_URL}/ag-push >",
            alias: "<alias e.g. a username or an email address optional>",
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

        push.register(onNotification, successHandler, errorHandler, pushConfig);


If you are only targeting one platform, you can simplify the code above by:


        var pushConfig = {
            pushServerURL: "<pushServerURL e.g https://{OPENSHIFT_UNIFIEDPUSHSERVER_URL}/ag-push >",
            alias: "<alias e.g. a username or an email address optional>",
            variantID: "<ios variantID e.g. 1234456-234320>",
            variantSecret: "<ios variantSecret e.g. 1234456-234320>"
        };

        push.register(onNotification, successHandler, errorHandler, pushConfig);


### 2. Receive Remote Notifications
The `onNotification` callback will get executed by the plugin when a new message arrives. 

        function onNotification(event) {
            alert(event.alert);
        }


The passed in `event` object contains:

* `alert`: the alert message send
* `coldstart`: information whether the app was running when the message was received
* `badge`: the number to display on the icon (iOS specific)
* any custom set of properties that are available under e.payload ( e.g `alert(e.payload.foo);` )


#### iOS Background Notification
Sending notifications that contain `content-available` on iOS will call the JavaScript before launching the application. This will enable you to update the UI or do a silent push (e.g. without an alert) to update the content of your application without the user noticing.  After fetching the content, you'll have to _inform_ the os about the result by calling `setContentAvailable` with either `NewData`, `NoData` or `Failed`:


        function onNotification(event) {

          if (event['content-available'] === 1) {
            if (!event.foreground) {
              // fetch content
              push.setContentAvailable(push.FetchResult.NewData);
            }
          }
        }


#### Android VIBRATE Permission
For applications using the Cordova Push API and running on Android 4.1 or earlier (but for some vendors also Android 4.2 and 4.3 versions are affected), the application may fail with error `java.lang.SecurityException: Requires VIBRATE permission` when a push notification is received and vibration for notifications is enabled on the device. To work around this issue, add `<uses-permission android:name="android.permission.VIBRATE" />` to the application AndroidManifest.xml file. This will ensure that the application does not fail when a push notification is received and the device has vibration for notifications enabled. 

### 3. Unregister the Application (only available on Android):


        push.unregister(successHandler, errorHandler);

        function successHandler() {
            console.log('success')
        }

        function errorHandler(message) {
            console.log('error ' + message);
        }


## Demo
For more information about configuring and using the JBoss Unified Push PushPlugin for Cordova, refer to `JBoss Unified Push Helloworld Cordova` and `JBoss Unified Push Contacts Mobile Cordova`, as examples of projects using the push feature with JBoss Unified Push for Cordova.

###JBoss Unified Push Server
For more information about deploying, configuring and using the JBoss Unified Push Server, see the [JBoss Unified Push documentation](https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Unified_Push/).
