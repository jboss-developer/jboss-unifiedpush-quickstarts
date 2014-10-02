push-helloworld-cordova: Push Helloworld Cordova
===========================
Author: Erik Jan de Wit (edewit)   
Level: Beginner   
Technologies: JavaScript Cordova   
Summary: A basic example of Push : Registration and receiving messages.   
Target Product: JBoss Unified Push   
Versions: 1.0   
Source: <https://github.com/jboss-developer/jboss-mobile-quickstarts/>  

## What is it?
This quickstart demonstrates how to include basic push functionality in Cordova applications using the JBoss Unified Push Cordova Push plug-in.

This simple project consists of a ready-to-build Cordova application. Before building the application, you must register the Android or iOS variant of the application with a running JBoss Unified Push Server instance and Google Cloud Messaging for Android or Apple Push Notification Service for iOS. The resulting unique IDs and other parameters must then be inserted into the application source code. After this is complete, the application can be built and deployed to Android or iOS devices.

When the application is deployed to an Android or iOS device, the push functionality enables the device to register with the running JBoss Unified Push Server instance and receive push notifications.

## How do I run it?

###0. System requirements

The Cordova command line tooling is based on node.js so first you'll need to [install node](http://nodejs.org/download/), then you can install Cordova by executing:
```shell
npm install -g cordova
```

To deploy on iOS you need to install the ios-deploy package as well
```shell
npm install -g ios-deploy
```

#### iOS
For iOS you'll need a valid provisioning profile as you will need to test on an actual device (push notification is not available when using a simulator).
Replace the bundleId with your bundleId (the one associated with your certificate), by editing the config.xml at the root of this project, change the id attribute of the `widget` node. After that run a `cordova platform rm ios` followed by `cordova platform add ios` to change the Xcode project template.

If you want to change your bundleId later on, you will still have to run a `cordova platform rm ios` followed by `cordova platform add ios` to change the Xcode project template.

#### Android
To deploy and run Cordova applications on Android the Apache Ant tool needs to be [installed](http://ant.apache.org/manual/install.html).


###1. Register Application with Push Services

For the configuration and registration of Android or iOS Applications with PushServices, please refer to the specific guides inside *push-helloworld-android* and *push-helloworld-ios* quickstarts.

###2. Customize and Build Application
In `www/js/index.js` find the `pushConfig` and change `pushServerURL` with the url of your Unified Push Server instance. You also need to change `senderID`, `variantID` and `variantSecret` with the values assigned by Unified Push Server and GCM or APNS:

```javascript
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

```

**Note:** You can also copy/paste these settings from your Unified Push Server console

###3. Install platforms

After changing the push configuration you can install the platforms you want on the Cordova app. JBoss Unified Push for Cordova currently supports Android and iOS.
```shell
cordova platform add <android or ios>
```

###4. Add JBoss Unified Push Cordova Push plug-in
You now need to add the plugin to the Cordova app.
```shell
cordova plugin add `QUICKSTART_HOME/cordova_pushplugin/org.jboss.aerogear.cordova.push`
```

###5. Test Application

The application can be tested on physical Android or iOS devices only; push notifications are not available for Android emulators nor iOS simulators. To deploy, run and debug the application on an Android or iOS device attached to your system, on the command line enter the following:
```shell
cordova run <android or ios>
```

#### Send a Push Message
You can send a push notification to your device using the Unified Push Server console by completing the following steps:

1. Log into the Unified Push Server console.
2. Click `Send Push`.
3. From the `Applications` list, select the application.
4. In the `Messages` field, type the text to be sent as the push notification.
5. Click `Send Push Notification`.

## How does it work?

### Registration
When you start the application Cordova will fire a `deviceready` event when Cordova initialization is done and the device is ready (see `www/js/index.js`). On this event the `register` function will be executed registering the device with the Unified Push Server. The first argument is a function that gets executed when the device receives a push event, followed by a success and errorCallback that are invoked when the register was successful or not and the last parameter is the push configuration that indicates where the push server is located and which variant/secret to use. When registration is successful it will display this on the UI. You can also verify that the registration was successful by going to the console there a new instance will have appeared with your deviceId, platform and status.


## Run push-helloworld-cordova in JBoss Developer Studio or Eclipse

Import the generated project into JBDS:  

![import](doc/import.png)

Select the project location and project and click `Finish`:  

![import-helloworld](doc/import-helloworld.png)

In the newly imported project, open the `config.xml` file and click `Add...` in the `Features` section:  

![config-add-feature](doc/config-add-feature.png)

Choose `Directory` and point to the directory containing your plugin, then click `Finish`:  

![plugin-add](doc/plugin-add.png)

Run the project on a device:  

![run](doc/run.png)

Debug the Application
=====================

Start a browser Chrome for Android or Safari for iOS

iOS
* Develop -> &lt;device name> -> index.html

Android
* Menu -> Tools -> Inspect Devices -> inspect


