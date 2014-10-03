Red Hat JBoss Unified Push Quickstarts
===========================================================
Summary: The JBoss Unified Push quickstarts are ready-to-assemble applications, provided in a variety of mobile API formats. The mobile formats typically have prerequisite library and application configuration that must be completed before the applications can be built and deployed.    

## Introduction

These quickstarts run on Red Hat JBoss Enterprise Application Platform 6.3. We recommend using the JBoss EAP ZIP file. This version uses the correct dependencies and ensures you test and compile against your runtime environment. 

Be sure to read this entire document before you attempt to work with the quickstarts. It contains the following information:

* [Available Quickstarts](#available-quickstarts): List of the available quickstarts and details about each one.

* [Suggested Approach to the Quickstarts](#suggested-approach-to-the-quickstarts): A suggested approach on how to work with the quickstarts.

* [System Requirements](#system-requirements): List of software required to run the quickstarts.

* [Configure Maven](https://github.com/jboss-developer/jboss-developer-shared-resources/blob/master/guides/CONFIGURE_MAVEN.md#configure-maven-to-build-and-deploy-the-quickstarts): How to configure the Maven repository for use by the quickstarts.

* [Run the Quickstarts](#run-the-quickstarts): General instructions for building, deploying, and running the quickstarts.

* [Optional Components](#optional-components): How to install and configure optional components required by some of the quickstarts.


## Use of EAP_HOME and JBOSS_HOME Variables

The quickstart README files use the *replaceable* value `EAP_HOME` to denote the path to the JBoss EAP 6 installation. When you encounter this value in a README file, be sure to replace it with the actual path to your JBoss EAP 6 installation. 

* If you installed JBoss EAP using the ZIP, the install directory is the path you specified when you ran the command.

* If you installed JBoss EAP using the RPM, the install directory is `/var/lib/jbossas/`.

* If you used the installer to install JBoss EAP, the default path for `EAP_HOME` is `${user.home}/EAP-6.3.0`.  

        For Linux: /home/USER_NAME/EAP-6.3.0/
        For Windows: "C:\Users\USER_NAME\EAP-6.3.0\"

* If you used the JBoss Developer Studio installer to install and configure the JBoss EAP Server, the default path for `EAP_HOME` is `${user.home}/jbdevstudio/runtimes/jboss-eap`.  

        For Linux: /home/USER_NAME/jbdevstudio/runtimes/jboss-eap/
        For Windows: "C:\Users\USER_NAME\jbdevstudio\runtimes\jboss-eap" or "C:\Documents and Settings\USER_NAME\jbdevstudio\runtimes\jboss-eap\" 

The `JBOSS_HOME` *environment* variable, which is used in scripts, continues to work as it has in the past.


## Available Quickstarts

* [push-helloworld-android](push-helloworld-android/README.md), [push-helloworld-cordova](push-helloworld-cordova/README.md), and [push-helloworld-ios](push-helloworld-ios/README.md) demonstrate how to include basic push functionality in mobile applications, provided in Android, Cordova and iOS variants. Once the application is deployed to a mobile device, the push functionality enables the device to register with a running JBoss Unified Push Server instance and receive push notifications.

* [push-contacts-mobile](push-contacts-mobile/README.md) shows how to develop a more advanced push example, centered around a CRUD contacts application. The complete `push-contacts-mobile` example functionality is provided by a server application and a client application. The server application sends push notification requests to a running JBoss Unified Push Server instance when new contacts are added. The client application enables devices to register with the Unified Push Server and receive push notifications with details of newly added contacts. The client application is provided in Android, Cordova, iOS and web application variants.

All available quickstarts can be found here: <http://site-jdf.rhcloud.com/quickstarts/get-started/>. You can filter by the quickstart name, the product, and the technologies demonstrated by the quickstart. You can also limit the results based on skill level and date published. The resulting page provides a brief description of each matching quickstart, the skill level, and the technologies used. Click on the quickstart to see more detailed information about how to run it. Some quickstarts require deployment of other quickstarts. This information is noted in the `Prerequisites` section of the quickstart README file.

_Note_: Some of these quickstart use the H2 database included with JBoss EAP 6. It is a lightweight, relational example datasource that is used for examples only. It is not robust or scalable and should NOT be used in a production environment!


## Suggested Approach to the Quickstarts

We suggest you approach the quickstarts as follows:

* If you are a beginner or new to JBoss, start with the quickstarts labeled **Beginner**, then try those marked as **Intermediate**. When you are comfortable with those, move on to the **Advanced** quickstarts.
* Some quickstarts are based upon other quickstarts but have expanded capabilities and functionality. If a prerequisite quickstart is listed, be sure to deploy and test it before looking at the expanded version.


## System Requirements

The applications these projects produce are designed to be run on Red Hat JBoss Enterprise Application Platform 6.3. 

To run these quickstarts with the provided build scripts, you need the following:

1. Java 1.6, to run JBoss EAP and Maven. You can choose from the following:
    * OpenJDK
    * Oracle Java SE
    * Oracle JRockit

2. Maven 3.0.0 or newer, to build and deploy the examples
    * If you have not yet installed Maven, see the [Maven Getting Started Guide](http://maven.apache.org/guides/getting-started/index.html) for details.
    * If you have installed Maven, you can check the version by typing the following in a command prompt:

        mvn --version 

3. The JBoss EAP distribution ZIP.
    * For information on how to install and run JBoss, see the [JBoss Enterprise Application Platform Documentation](https://access.redhat.com/documentation/en-US/JBoss_Enterprise_Application_Platform/) _Getting Started Guide_ located on the Customer Portal.

4. You can also use [JBoss Developer Studio or Eclipse](#use-jboss-developer-studio-or-eclipse-to-run-the-quickstarts) to run the quickstarts. 


## Run the Quickstarts

The root folder of each individual quickstart contains a README file with specific details on how to build and run the example. 


## Use JBoss Developer Studio or Eclipse to Run the Quickstarts

You can also deploy the quickstarts from Eclipse using JBoss tools. For more information on how to set up Maven and the JBoss tools, see the [JBoss Enterprise Application Platform Documentation](https://access.redhat.com/documentation/en-US/JBoss_Enterprise_Application_Platform/) _Getting Started Guide_ and _Development Guide_ or [Get Started with JBoss Developer Studio](http://www.jboss.org/products/devstudio/get-started/ "Get Started with JBoss Developer Studio").


## Optional Components

The following components are needed for only a small subset of the quickstarts. Do not install or configure them unless the quickstart requires it.

* [Java 7](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
* [Maven 3.1.1](http://maven.apache.org)
* [Android SDK](https://developer.android.com/sdk/index.html) and [Platform version 19](http://developer.android.com/tools/revisions/platforms.html)
* [Android Support Library](http://developer.android.com/tools/support-library/index.html) and [Google Play Services](http://developer.android.com/google/play-services/index.html)
* [Maven Android SDK Deployer](https://github.com/mosabua/maven-android-sdk-deployer)
* [Node.js](http://nodejs.org/download/)
* [Apache Cordova](http://cordova.apache.org/)
* [Ant](http://ant.apache.org/manual/install.html)
* [XCode 5.1+](https://developer.apple.com/xcode/)



For information about JBoss Unified Push, see the [JBoss Unified Push documentation](https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Unified_Push/).


