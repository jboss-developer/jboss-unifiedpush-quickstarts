# push-helloworld-ios: Push Helloworld iOS - include basic push functionality in iOS applications

Author: Corinne Krych (ckrych)   
Level: Beginner   
Technologies: Objective-C, iOS   
Summary: A basic example of Push : Registration and receiving messages.   
Target Product: Mobile Add-On   
Versions: 1.0   
Source: <https://github.com/jboss-developer/jboss-mobile-quickstarts/>   

## What is it?
This quickstart demonstrates how to include basic push functionality in iOS applications using the JBoss Mobile Add-On iOS Push plug-in.

This simple project consists of a ready-to-build iOS application. Before building the application, you must register the iOS variant of the application with a running JBoss Mobile UnifiedPush Server instance and Apple Push Notification Service for iOS. The resulting unique IDs and other parameters must then be inserted into the application source code. After this is complete, the application can be built and deployed to iOS devices. 

When the application is deployed to an iOS device, the push functionality enables the device to register with the running JBoss Mobile UnifiedPush Server instance and receive push notifications.

## How do I run it?

###0. System requirements
* iOS 7.X
* Xcode version 5.1.X

###1. Configuration

#### Creation of Certificate Signing Request and SSL certificate for APNs

First you need to submit a request for a new digital certificate, which is based on a public/private key. The Certificate itself is acting as the public key, and when you request it, a private key is added to your `KeyChain` tool. The Cerficate will be used later on, to request an SSL certificate for the `Apple Push Network Service`, which will allow the JBoss Mobile UnifiedPush Server to send notification messages to it.

1. Request a new CSR (Certificate Signing Request) using `KeyChain Access` tool found in `Applications > Utilities` folder on your Mac.  Once opened, in the `KeyChain Access` menu, choose `Certificate Assistant > Request a Certificate from a Certificate Authority`. Make sure that you have choosen to store the CSR _on file_, so we can upload it later in the provisioning portal when requesting the actual SSL cert.
2. Go to the [Provisioning Portal](https://developer.apple.com/account/overview.action) and log in with your Apple developer account. Now, click on the `Identifiers` link in order to create a new `App ID` (use the `PLUS` Icon on the right). In the formular give the `App ID` a descriptive name. Double check that the `Push Notifications` checkbox is _selected_.
3. Later in the same page you are asked for an `Explicit App ID`, since the generic `Wildcard App ID` does not work with Push Notifications. In the `Bundle ID` field enter _YOUR_ `Bundle ID`. This is similar to Java packages. **NOTE:** The `Bundle ID` has to match the one from the actual iOS application that you are building later in this guide.
4. In the next screen confirm your new `App ID`, and double check that the `Push Notifications` option is _enabled_. Afterwards click the `Submit` button. In the next screen, click on on the newly created `App ID`, then click the `Edit` button and scroll down to the `Push Notifications` section. Here we are asked to generate a `Development` and a `Production` certificate that will be used by the UnifiedPush server when contacting the Apple Push Notification service to send messages. If you plan to distribute your app in the App Store, you are required to generate a Production certificate. 
  *  `Development Certificate`: Click the `Create Certificate` button on the `Development SSL Certificate` section. Upload the `Certificate Signing Request` that you created earlier and click the `Generate` button. The `Development SSL Certificate` file is being downloaded as `aps_development.cer`. 
  *  `Production Certificate`: Click the `Create Certificate` button on the `Production SSL Certificate` section. Upload the `Certificate Signing Request` that you created earlier and click the `Generate` button. The `Production SSL Certificate` file is being downloaded as `aps_production.cer`.
  
  You have to export this certificates/private keys pair to the .p12 (Personal Information Exchange). These files will be uploaded later on to the JBoss Mobile UnifiedPush Server enabling it to authorize themselves for your development application on Apple Push Network Service and send messages to them. When exporting the files, as your private keys, you need to assign a passphrase for them. Make note of them, because later when uploading them to the JBoss Mobile UnifiedPush Server you will need both the exported files (`aps_development.cer`, `aps_production.cer`) and the passphrases.

#### Creation of a Provisioning Profile

In order to test Push Notifications you neeed to create a _Provisioning Profile_.
  *  `Development Provisioning Profile`: In the _Provisioning Portal_ you need to create an _iOS App Development_ provisioning profile, so that you can test the Push Notifications on your own iOS devices. Select the `App ID` that you created earlier and your _Developer Certificate_. Select a _Test_ Device, give it a Profile Name and generate it. Now download the Profile and open the file. Go to `Xcode -> preferences...` menu, select the `Account` tab, on the right bottom corner click `View details...` and you should see your provisioning profile.
  *  `Distribution Provisioning Profile`: In order to test Push Notifications on a `production environment`, you need to create an _iOS App Distribution_ provisioning profile in the _Provisioning Portal_. Select the `App ID`, that you created earlier and your _Production Certificate_. You still need a _test device_ to try your _production_ app with your _distribution provisioning profile_. Select a _Test_ Device, give it a Profile Name and generate it. Now download the Profile and open the file. Go to `Xcode -> preferences...` menu, select the `Account` tab, on the right bottom corner click `View details...` and you should see your provisioning profile.
  
###2. Register Application with Push Services

You must register the application and an iOS variant of the application with the UnifiedPush Server. This requires a running UnifiedPush Server instance and uses the unique metadata assigned to the application by APNS. For information on installing the UnifiedPush Server, see the [JBoss Mobile Add-On documentation](https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Mobile_Add-On/).

1. Log into the UnifiedPush Server console.
2. In the `Applications` view, click `Create Application`.
3. In the `Name` and `Description` fields, type values for the application and click `Create`.
4. When created, under the application click `No variants`.
5. Click `Add Variant`.
6. In the `Name` and `Description` fields, type values for the iOS application variant.
7. Click `iOS` and type the values assigned to the project by APNS (you will have to upload your Developer or Production Certificate)
8. Click `Add`.
9. When created, expand the variant name and make note of the `Server URL`, `Variant ID`, and `Secret`.


###3. Customize and Build Application

Replace the bundleId with your bundleId (the one associated with your certificate).
Go to `HelloWorld target -> Info` and modify the `Bundle Identifier`:

![change helloworld bundle](doc/change-helloworld-bundle.png)

Now open **HelloWorld.xcodeproj**.

In `HelloWorld/AGAppDelegate.m` find the pushConfig and change the server url to your JBoss Mobile UnifiedPush Server instance and variant/secret:

```objective-c
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // initialize "Registration helper" object using the
    // base URL where the "JBoss Mobile UnifiedPush Server" is running.
    AGDeviceRegistration *registration =

    // WARNING: make sure, you start JBoss with the -b 0.0.0.0 option, to bind on all interfaces
    // from the iPhone, you can NOT use localhost
    [[AGDeviceRegistration alloc] initWithServerURL:[NSURL URLWithString:@"<# URL of the running JBoss Mobile UnifiedPush Server #>"]];

    [registration registerWithClientInfo:^(id<AGClientDeviceInformation> clientInfo) {
        // You need to fill the 'Variant Id' together with the 'Variant Secret'
        // both received when performing the variant registration with the server.
        [clientInfo setVariantID:@"<# Variant Id #>"];
        [clientInfo setVariantSecret:@"<# Variant Secret #>"];

        // if the deviceToken value is nil, no registration will be performed
        // and the failure callback is being invoked!
        [clientInfo setDeviceToken:deviceToken];

        // apply the token, to identify THIS device
        UIDevice *currentDevice = [UIDevice currentDevice];

        // --optional config--
        // set some 'useful' hardware information params
        [clientInfo setOperatingSystem:[currentDevice systemName]];
        [clientInfo setOsVersion:[currentDevice systemVersion]];
        [clientInfo setDeviceType: [currentDevice model]];


    } success:^() {

        // Send NSNotification for success_registered, will be handle by registered AGViewController
        NSNotification *notification = [NSNotification notificationWithName:@"success_registered" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"Unified Push registration successful");

    } failure:^(NSError *error) {

        // Send NSNotification for error_register, will be handle by registered AGViewController
        NSNotification *notification = [NSNotification notificationWithName:@"error_register" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"Unified Push registration Error: %@", error);

    }];
}

```

###4. Test Application

#### Send a Push Message
You can send a push notification to your device using the UnifiedPush Server console by completing the following steps:

1. Log into the UnifiedPush Server console.
2. Click `Send Push`.
3. From the `Applications` list, select the application.
4. In the `Messages` field, type the text to be sent as the push notification.
5. Click `Send Push Notification`.  
  
After a while you will see the message end up on the device.  
When the application is running in foreground, you can catch messages in AGAppDelegate's  `application:didReceiveRemoteNotification:`. The event is forwarded using `NSNotificationCenter` for decoupling AGappDelegate and AGViewController. It will be the responsability of AGViewController's `messageReceived:` method to render the message on UITableView.

When the app is running in background, user can bring the app in the foreground by selecting the Push notification. Therefore AGAppDelegate's  `application:didReceiveRemoteNotification:` will be triggered and the message displayed on the list. If a background processing was needed we could have used `application:didReceiveRemoteNotification:fetchCompletionHandler:`. Refer to [Apple documentation for more details](https://developer.apple.com/library/ios/documentation/uikit/reference/UIApplicationDelegate_Protocol/Reference/Reference.html#//apple_ref/occ/intfm/UIApplicationDelegate/application:didReceiveRemoteNotification:fetchCompletionHandler:)

For application not running, we're using AGAppDelegate's `application:didFinishLaunchingWithOptions:`, we locally save the latest message and forward the event to AGViewController's `messageReceived:`.

**NOTE**: The local save is required here because of the asynchronous nature of `viewDidLoad` vs `application:didFinishLaunchingWithOptions:`


## How does it work?

### Registration

When the application is launched, AGAppDelegate's `application:didFinishLaunchingWithOptions:` registers the app to receive remote notifications. 

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: 
        (UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeSound | 
         UIRemoteNotificationTypeAlert)];    
    ...
}
```

Therefore, AGAppDelegate's `application:didRegisterForRemoteNotificationsWithDeviceToken:` will be called.

When AGAppDelegate's `application:didRegisterForRemoteNotificationsWithDeviceToken:` is called, the device is registered to UnifiedPush Server instance. This is where configuration changes are required (see code snippet below).


FAQ
--------------------

* Which iOS version is supported by JBoss Mobile Add-On for iOS libraries?

JBoss Mobile Add-On supports iOS 7.0 and later.


Debug the Application
=====================

Set a break point in Xcode.


