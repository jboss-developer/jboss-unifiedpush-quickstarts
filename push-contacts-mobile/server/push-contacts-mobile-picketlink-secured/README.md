push-contacts-mobile-picketlink-secured: Push Contacts Mobile Picketlink Secured
===========================
Author: Joshua Wilson, Pedro Igor, Erik Jan De Wit, Daniel Bevenius  
Level: Beginner  
Technologies: REST, Unified Push Java Client, PicketLink  
Summary: The `push-contacts-mobile-picketlink-secured` quickstart shows how to develop a PicketLink secured CRUD application with push notification functionality.  
Target Product: JBoss Unified Push  
Versions: 1.0  
Source: <https://github.com/jboss-developer/jboss-mobile-quickstarts/>  

## What is it?

The `push-contacts-mobile-picketlink-secured` quickstart demonstrates how to develop secured server-side applications with push functionality, centered around a CRUD contacts application. It creates a PicketLink secured Java EE 6 application using JAX-RS, CDI 1.0, EJB 3.1, JPA 2.0 and Bean Validation 1.0.

When the `push-contacts-mobile-picketlink-secured` application is deployed, the push functionality enables the application to register with the running JBoss Unified Push Server OpenShift instance and send it push notification requests. The server-side application rest endpoints are secured with PicketLink and can only be accessed by client applications with authenticated users.

When contacts are created with the client contacts-mobile application, the contact information is relayed to the `push-contacts-mobile-picketlink-secured` application. On receiving the contact infomation, this backend application sends a push notification request to the JBoss Unified Push Server OpenShift instance. The JBoss Unified Push Server OpenShift instance then routes a push notification containing details of the newly added contact to devices that are registered with the JBoss Unified Push Server OpenShift instance for the specific client application. 

**Note:** This quickstart uses the following Jackson libraries that are a part of the JBoss EAP private API.

* *org.codehaus.jackson.jackson-core-asl*
* *org.codehaus.jackson.jackson-mapper-asl*

A public API will become available in a future EAP release and the private classes will be deprecated, but these classes continue to be maintained and available for the duration of the EAP 6.x release cycle.

## How do I use it?

### 0. System Requirements

* [Java 6](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
* [Maven 3.0](http://maven.apache.org) or later
* Red Hat JBoss Enterprise Application Platform (EAP) 6.3.0.GA

### 1. Prepare Maven Libraries

This quickstart is designed to be built with Maven. It requires the JBoss Unified Push and JBoss EAP 6.3.0 Maven repositories.

You must have the JBoss Unified Push Maven repository available and Maven configured to use it. For more information, see the [JBoss Unified Push documentation](https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Unified_Push/) or the README distributed with the JBoss Unified Push Maven repository.

### 2. Register Application with Push Services

You must register the application with the JBoss Unified Push Server. This requires a running JBoss Unified Push Server OpenShift instance. For information on installing the JBoss Unified Push Server, see the [JBoss Unified Push documentation](https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Unified_Push/).

1. Log into the JBoss Unified Push Server OpenShift instance console.
2. In the `Applications` view, click `Create Application`.
3. In the `Name` and `Description` fields, type values for the application and click `Create`.
4. When created, click the application name and make note of the `Server URL`, `Application ID`, and `Master Secret`.

### 3. Customize JBoss Unified Push Java Sender and Build Application

The project source code must be customized with the unique metadata assigned to the application by the JBoss Unified Push Server OpenShift instance. 

1. Open [quickstarts-config.json](./src/main/resources/META-INF/quickstarts-config.json) configuration file for editing.
2. Enter the ` serverUrl `,  ` pushApplicationId ` and ` masterSecret ` parameters.
3. Save the file.
4. Build the application

        cd QUICKSTART_HOME/push-contacts-mobile/server/push-contacts-mobile-picketlink-secured
        mvn clean package

### 4. Test the Application

#### 0. Prerequisites

The JBoss Unified Push Server OpenShift instance must be running before the application is deployed to ensure that it successfully registers with the JBoss Unified Push Server on deployment.

#### 1. Deploy for Testing

1. Start JBoss EAP

        For Linux:   EAP_HOME/bin/standalone.sh
        For Windows: EAP_HOME\bin\standalone.bat

2. Build and deploy the packaged application

        cd QUICKSTART_HOME/push-contacts-mobile/server/push-contacts-mobile-picketlink-secured
        mvn clean package jboss-as:deploy

This deploys `QUICKSTART_HOME/push-contacts-mobile/server/push-contacts-mobile-picketlink-secured/target/jboss-push-contacts-mobile-picketlink-secured.war` to the running instance of the server.

**Note:** Adding "-b 0.0.0.0" to the above commands will allow external clients (phones, tablets, desktops, etc...) to connect through your local network.
For example

        For Linux:   EAP_HOME/bin/standalone.sh -b 0.0.0.0
        For Windows: EAP_HOME\bin\standalone.bat -b 0.0.0.0


#### 2. Send a Push Message

You can create a new contact using any of the client applications.  
Please follow the `Build and Deploy the Quickstart` instructions in [contacts-mobile-webapp](../../client/contacts-mobile-webapp) which describe how to build, deploy, and access the web application.  
For information on building and deploying any of the client application variants, see the READMEs distributed with these applications.  

#### 3. Undeploy the Quickstart

1. Make sure you have started the JBoss EAP server as described above.
2. When you are finished testing, type this command to undeploy the archive:

        cd QUICKSTART_HOME/push-contacts-mobile/server/push-contacts-mobile-picketlink-secured
        mvn jboss-as:undeploy


## FAQ

Why cannot I enter a date in the birthdate field?

* Chrome has a [bug](https://code.google.com/p/chromium/issues/detail?id=232296) in it.
    * Use the arrow keys to change the date: up arrow key, tab to day, up arrow key, tab to year, up arrow key.
    * Use the date picker: a large black down arrow between the up/down arrows and the big X on the right side.
* Firefox, IE, and Safari require strict formatting of YYYY-DD-MM, *Note:* It must be a dash and not a slash.

## Use the Project with an IDE

You can import this project into an IDE (JBoss Developer Studio, NetBeans or IntelliJ IDEA). If you are using JBoss Developer Studio you must import the project as a Maven project. If you are using NetBeans 6.8 or IntelliJ IDEA 9, then you can open the project as an existing project as both of these IDEs recognize Maven projects natively.

You can also start the server and deploy the quickstarts from JBoss Developer Studio. For more information , see the [Get Started with JBoss Developer Studio](http://www.jboss.org/products/devstudio/get-started/ "Get Started with JBoss Developer Studio").

If you want to debug the source code of any library in the project, run the following command to pull the source into your local repository. The IDE should then detect it.

    mvn dependency:sources

