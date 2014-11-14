push-contacts-mobile: Contacts CRUD Mobile Assortment with Push Notification
===========================================================
Author: Daniel Passos, Erik Jan de Wit, Christos Vasilakis, Daniel Bevenius, Joshua Wilson, Pedro Igor  
Level: Intermediate  
Technologies: Java, JavaScript, jQuery Mobile, Android, Cordova, HTML5, REST, Unified Push Java Client, PicketLink    
Summary: The `push-contacts-mobile` quickstart is a secured contacts CRUD mobile application with push notification integration with Android, Cordova and iOS.  
Target Product: JBoss Unified Push   
Versions: 1.0  
Source: <https://github.com/jboss-developer/jboss-mobile-quickstarts/>  

## What is it?

This project contains the JBoss Unified Push `push-contacts-mobile` quickstart. It demonstrates how to develop more advanced push examples, centered around a CRUD contacts application.

The quickstart consists of several server and client applications, some of which must be deployed simultaneously to achieve a fully working example. Users can view, create and manage contacts through either applications on their mobile devices or a web application. On the creation of new contacts from any one of these applications, the Unified Push Server OpenShift instance sends push notifications containing details of newly added contacts to devices that are registered with the Unified Push Server OpenShift instance for the mobile contacts application.

The following sections describe the individual applications that comprise this example.  

_NOTE:_ See the individual quickstart README files for instructions to run them.

### Server-side Applications

The source for the server applications is located in the `QUICKSTART_HOME/push-contacts-mobile/server` directory. These applications are deployed to the server and accessed by the client applications.

* [push-contacts-mobile-picketlink-secured](server/push-contacts-mobile-picketlink-secured/README.md) is the core server-side application and fundamental to the example. It manages the contacts data, receiving the details of new contacts as they are created in the client applications and storing the details in a server-side database. It also sends push notification requests to the Unified Push Server OpenShift instance when new contacts are created to initiate the sending of push notifications to registered devices. The server-side application rest endpoints are secured with PicketLink and can only be accessed by client applications with authenticated users. This application has no user interface.

* [contacts-mobile-proxy](server/contacts-mobile-proxy/README.md) layers the `push-contacts-mobile-picketlink-secured` quickstart and it can only be used in conjunction with the latter. It is intended for use when the `push-contacts-mobile-picketlink-secured` application is deployed on a server that is protected behind a firewall, preventing access by clients outside the firewall. The `contacts-mobile-proxy` is deployed on a server outside the firewall to act as a proxy or router application. This application has an accessible user interface, in which contacts can be viewed and managed as in the client applications. Note that this application has no push functionality. 


### Client-side Applications

The source for the client applications is located in the `QUICKSTART_HOME/push-contacts-mobile/client` directory. This project provides a variety of client applications to demonstrate different mobile APIs and traditional web access.

* [push-contacts-mobile-android](client/push-contacts-mobile-android/README.md), [push-contacts-mobile-ios](client/push-contacts-mobile-ios/README.md), and [push-contacts-mobile-cordova](client/push-contacts-mobile-cordova/README.md) are implementations of the same client application for different mobile APIs. When the client application is deployed to a mobile device, the push functionality enables the device to register with the JBoss Unified Push Server OpenShift instance and receive push notifications when new contacts are created. The client applications are secured and authentication managed by the server-side `push-contacts-mobile-picketlink-secured` application. Additionally, all contact data for the client applications is sourced from the server-side application. 

* [contacts-mobile-webapp](client/contacts-mobile-webapp/README.md) is an implementation of the client application for deployment to a server rather than a mobile device. Like the mobile client applications, this application requires authentication to view and manage contacts. But this application has no push functionality; it does not register with the Unified Push Server OpenShift instance on deployment and it does not receive push notifications when contacts are created by other client applications. 

For more information about deploying, configuring and using the JBoss Unified Push Server, see the [JBoss Unified Push documentation](http://docs.jboss.org/unifiedpush/unifiedpush.pdf) and [JBoss xPaaS Services for OpenShift](https://developers.openshift.com/en/xpaas.html#_mobile_services).

