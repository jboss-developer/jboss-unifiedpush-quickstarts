push-helloworld-android: Push Helloworld Android
===========================
Author: Daniel Passos (dpassos)  
Level: Beginner  
Technologies: Java, Android  
Summary: The `push-helloworld-android` quickstart shows how to use the JBoss Unified Push Android Push plug-in to register and receive push notifications.  
Target Product: JBoss Unified Push  
Versions: 1.0  
Source: <https://github.com/jboss-developer/jboss-mobile-quickstarts/>  

## What is it?

The `push-helloworld-android` quickstart demonstrates how to include basic push functionality in Android applications using the JBoss Unified Push Android Push plug-in.

This simple project consists of a ready-to-build Android application. Before building the application, you must register the Android variant of the application with a running JBoss Unified Push Server OpenShift instance and Google Cloud Messaging for Android. The resulting unique IDs and other parameters must then be inserted into the application source code. After this is complete, the application can be built and deployed to Android devices. 

When the application is deployed to an Android device, the push functionality enables the device to register with the running JBoss Unified Push Server OpenShift instance and receive push notifications.

## How do I run it?

### 0. System Requirements

* [Java 7](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
* [Maven 3.1.1](http://maven.apache.org)
* Latest [Android SDK](https://developer.android.com/sdk/index.html)
* Latest Platform Version and [Platform version 19](http://developer.android.com/tools/revisions/platforms.html)
* Latest [Android Support Library](http://developer.android.com/tools/support-library/index.html) and [Google Play Services](http://developer.android.com/google/play-services/index.html)

### 1. Prepare Maven Libraries

This quickstart is designed to be built with Maven. It requires the JBoss Unified Push Maven repository and Google libraries.

You must have the JBoss Unified Push Maven repository available and Maven configured to use it. For more information, see the [JBoss Unified Push documentation](https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Unified_Push/) or the README distributed with the JBoss Unified Push Maven repository.

Google does not ship all the required libraries to Maven Central so you must deploy them locally with the helper utility [maven-android-sdk-deployer](https://github.com/mosabua/maven-android-sdk-deployer) as detailed here.

1. Checkout maven-android-sdk-deployer

        git clone git://github.com/mosabua/maven-android-sdk-deployer.git

2. Set up the environment variable `ANDROID_HOME` to contain the Android SDK path
3. Install Maven version of Android platform 19

        cd /path/to/maven-android-sdk-deployer/platforms/android-19
        mvn install -N

4. Install Maven version of google-play-services

        cd /path/to/maven-android-sdk-deployer/extras/google-play-services
        mvn install -N

5. Install Maven version of compatibility-v4

        cd /path/to/maven-android-sdk-deployer/extras/compatibility-v4
        mvn install -N

6. Install Maven version of compatibility-v7-appcompat

        cd /path/to/maven-android-sdk-deployer/extras/compatibility-v7-appcompat
        mvn install -N


### 2. Register the Application with Push Services

First, you must register the application with Google Cloud Messaging for Android and enable access to the Google Cloud Messaging for Android APIs and Google APIs. This ensures access to the APIs by the Unified Push Server when it routes push notification requests from the application to the GCM. Registering an application with GCM requires that you have a Google account.

1. Log into the [Google Cloud Console](https://console.developers.google.com)
2. In the `Projects` view, click `Create Project`.
3. In the `PROJECT NAME` field type a project name, select the check box to agree to the Terms of Service and click `Create`.
4. Reload the page and in the `Projects` view click the project you just created. Make note of the `Project Number`.
5. Click `APIs and auth`>`APIs` and change the status of `Google Cloud Messaging for Android` to `ON`.
6. Click `APIs and auth`>`Credentials` and under `Public API access` click `Create new Key`.
7. Click `Server Key` and click `Create`. Make note of the `API KEY`.

Second, you must register the application and an Android variant of the application with the Unified Push Server. This requires a running Unified Push Server OpenShift instance and uses the unique metadata assigned to the application by GCM. For information on installing the Unified Push Server, see the [JBoss Unified Push documentation](https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Unified_Push/).

1. Log into the Unified Push Server OpenShift instance console.
2. In the `Applications` view, click `Create Application`.
3. In the `Name` and `Description` fields, type values for the application and click `Create`.
4. When created, under the application click `No variants`.
5. Click `Add Variant`.
6. In the `Name` and `Description` fields, type values for the Android application variant.
7. Click `Android` and in the `Google Cloud Messaging Key` and `Project Number` fields type the values assigned to the project by GCM.
8. Click `Add`.
9. When created, expand the variant name and make note of the `Server URL`, `Variant ID`, and `Secret`.

### 3. Customize and Build Application

The project source code must be customized with the unique metadata assigned to the application variant by the Unified Push Server OpenShift instance and GCM. 

1. Open `QUICKSTART_HOME/push-helloworld-android/src/org/jboss/aerogear/unifiedpush/helloworld/Constants.java` for editing.
2. Enter the application variant values allocated by the Unified Push Server OpenShift instance and GCM for the following constants:

        String UNIFIED_PUSH_URL = "<pushServerURL e.g https://{OPENSHIFT_UNIFIEDPUSHSERVER_URL}/ag-push >";
        String VARIANT_ID = "<variantID e.g. 1234456-234320>";
        String SECRET = "<variantSecret e.g. 1234456-234320>";
        String GCM_SENDER_ID = "<senderID e.g Google Project ID only for android>";

3. Save the file.
4. Build the application

        cd QUICKSTART_HOME/push-helloworld-android
        mvn compile


### 4. Test the Application

#### 0. Prerequisites

The Unified Push Server OpenShift instance must be running before the application is deployed to ensure that the device successfully registers with the Unified Push Server on application deployment.

#### 1. Deploy the Application for testing

The application can be tested on physical Android devices only; push notifications are not available for Android emulators. To deploy, run and debug the application on an Android device attached to your system, on the command line enter the following:

        cd QUICKSTART_HOME/push-helloworld-android
        mvn clean package android:deploy android:run


Application output is displayed in the command line window.

#### 2. Send a Push Message

You can send a push notification to your device using the Unified Push Server console by completing the following steps:

1. Log into the Unified Push Server OpenShift instance console.
2. Click `Send Push`.
3. From the `Applications` list, select the application.
4. In the `Messages` field, type the text to be sent as the push notification.
5. Click `Send Push Notification`.

## How does it work?

### Registration

`RegisterActivity` is invoked right after a successful application login. The Activity life cycle `onCreate` is called first invoking the `register` method — attempting to register the application to receive push notifications.


        PushConfig config = new PushConfig(new URI(UNIFIED_PUSH_URL), GCM_SENDER_ID);
        config.setVariantID(VARIANT_ID);
        config.setSecret(SECRET);
        
        Registrations registrations = new Registrations();
        PushRegistrar registrar = registrations.push("register", config);
        registrar.register(getApplicationContext(), new Callback<Void>() {
            @Override
            public void onSuccess(Void data) {
                Toast.makeText(getApplicationContext(),
                        getApplicationContext().getString(R.string.registration_successful),
                        Toast.LENGTH_LONG).show();
            }
        
            @Override
            public void onFailure(Exception e) {
                Toast.makeText(getApplicationContext(), e.getMessage(), Toast.LENGTH_LONG).show();
                finish();
            }
        });


### Receiving Notifications

Before the usage of GCM notifications on Android, we need to include some permissions for GCM and a broadcast receiver to handle push messages from the service.

To enable the permissions we add these as child of the manifest element.


        <uses-permission android:name="android.permission.INTERNET" />
        <uses-permission android:name="android.permission.GET_ACCOUNTS" />
        <uses-permission android:name="android.permission.WAKE_LOCK" />
        <uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />
        
        <permission
            android:name="com.mypackage.C2D_MESSAGE"
            android:protectionLevel="signature" />
        
        <uses-permission android:name="org.jboss.aerogear.unifiedpush.helloworld" />


And add this element as a child of the application element, to register the default JBoss Unified Push for Android broadcast receiver. It will receive all messages and dispatch the message to registered handlers.


        <receiver
            android:name="org.jboss.aerogear.android.unifiedpush.AeroGearGCMMessageReceiver"
            android:permission="com.google.android.c2dm.permission.SEND" >
            <intent-filter>
                <action android:name="com.google.android.c2dm.intent.RECEIVE" />
                <category android:name="org.jboss.aerogear.unifiedpush.helloworld" />
            </intent-filter>
        </receiver>


All push messages are received by an instance of `AeroGearGCMMessageReceiver`. They are processed and passed to Registrations via the `notifyHandlers` method.

The `NotificationBarMessageHandler` is able to receive that message and show it in the Notification Bar.

In the `MessagesActivity` we need to remove the handler when the Activity goes into the background and re-enable it when it comes into the foreground.


        @Override
        protected void onResume() {
            super.onResume();
            Registrations.registerMainThreadHandler(this);
            Registrations.unregisterBackgroundThreadHandler(NotificationBarMessageHandler.instance);
        }
        
        @Override
        protected void onPause() {
            super.onPause();
            Registrations.unregisterMainThreadHandler(this);
            Registrations.registerBackgroundThreadHandler(NotificationBarMessageHandler.instance);
        }


