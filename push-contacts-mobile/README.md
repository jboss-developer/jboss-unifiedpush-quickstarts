# push-contacts-mobile: Push Contacts Mobile - Secured CRUD mobile application on JBoss EAP with push notification integration with Android, Cordova and iOS

Author: Daniel Passos, Erik Jan de Wit, Christos Vasilakis, Daniel Bevenius, Joshua Wilson, Pedro Igor  
Level: Intermediate  
Technologies: Java, JavaScript, jQuery Mobile, Android, Cordova, HTML5, REST, Unified Push Java Client, PicketLink    
Summary: A secured contacts CRUD mobile application with push notification integration with Android, Cordova and iOS.  
Target Product: Unified Push   
Versions: 1.0  
Source: <https://github.com/jboss-developer/jboss-mobile-quickstarts/>  

## What is it?

This archive contains the JBoss Unified Push `push-contacts-mobile` quickstart. It demonstrates how to develop a more advanced push example, centered around a CRUD contacts application.

The quickstart consists of individual applications, a number of which must be deployed simultaneously to achieve a fully working example. Users can view, create and manage contacts through either applications on their mobile devices or a web application. On the creation of new contacts from any one of these applications, the Unified Push Server sends push notifications containing details of newly added contacts to devices that are registered with the Unified Push Server for the mobile contacts application.

The individual applications contribute to the example as follows:

* `server/push-contacts-mobile-picketlink-secured` is the core server-side application and fundamental to the example. It manages the contacts data, receiving the details of new contacts as they are created in the client applications and storing the details in a server-side database. It also sends push notification requests to the Unified Push Server when new contacts are created to initiate the sending of push notifications to registered devices. The server-side application rest endpoints are secured with PicketLink and can only be accessed by client applications with authenticated users. This application has no user interface.

* `server/contacts-mobile-proxy` layers `push-contacts-mobile-picketlink-secured` and it can only be used in conjunction with the latter. It is intended to be used when `push-contacts-mobile-picketlink-secured` must be deployed on a server that is protected behind a firewall. If the client applications trying to interface with the core server-side application are outside the firewall then it would prevent their access. So `contacts-mobile-proxy` is deployed on a server outside the firewall to act as a proxy or router application. This application has an accessible user interface, in which contacts can be viewed and managed as in the client applications. Note that this application has no push functionality. 

* `client/push-contacts-mobile-android`, `client/push-contacts-mobile-ios`, and `client/push-contacts-mobile-cordova` are implementations of the same client application for different mobile APIs. When the client application is deployed to a mobile device, the push functionality enables the device to register with the JBoss Mobile Unified Push Server and receive push notifications when new contacts are created. The client applications are secured and authentication managed by `push-contacts-mobile-picketlink-secured`. Additionally, all contact data for the client applications is sourced from the server-side application.

* `client/contacts-mobile-webapp` is an implementation of the client application for deployment to a server rather than a mobile device. Like the mobile client applications, this application requires authentication to view and manage contacts. But this application has no push functionality; it does not register with the Unified Push Server on deployment and it does not receive push notifications when contacts are created by other client applications.

For information about JBoss Unified Push, see the [JBoss Unified Push documentation](https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Unified_Push/).
