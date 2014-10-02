# contacts-mobile-webapp: Contacts Mobile Webapp - develop HTML5 based mobile web applications with Java EE 6 on JBoss EAP

Author: Joshua Wilson  
Level: Beginner  
Technologies: jQuery Mobile, jQuery, JavaScript, HTML5, REST  
Summary: A basic example of CRUD operations in a mobile only website.  
Target Product: Unified Push  
Versions: 1.0  
Source: <https://github.com/jboss-developer/jboss-mobile-quickstarts/>  

## What is it?
It's a deployable Maven 3 project to help you get started in developing HTML5 based mobile web applications on JBoss EAP. This project is set up to allow you to create a basic Java EE 6 application using HTML5 and jQuery Mobile.

This application is built using HTML5. This uses a pure HTML client that interacts with the application server via restful end-points (JAX-RS). This application also uses some of the latest HTML5 features. And since testing is just as important with client side as it is with server side, this application uses QUnit to show you how to unit test your JavaScript.

This application focuses on `CRUD` in a strictly mobile app using only `jQuery Mobile` (no other frameworks). The user will have the ability to:

* `Create` a new contact.
* `Read` a list of contacts.
* `Update` an existing contact.
* `Delete` a contact.

`Validation` is an important part of an application.  Typically in an HTML5 app you can let the built-in HTML5 form validation do the work for you.  
However in a mobile app it doesn't work, the mobile browsers just don't support it at this time.  

In order to validate the forms, we added a plugin `jquery.validate`. We provide both client-side and server-side validation through this plugin. Over AJAX, if there is an error, the error is returned and displayed in the form. You can see an example of this in the `Edit` form if you enter an email that is already in use. There will be three errors on the screen; one in the `email` field and two at the top of the screen. The application will attempt to insert the error message into a field if that field exists. If the field does not exist then it displays it at the top.  
In addition, there are [qunit tests](#run-the-qunit-tests) for every form of validation.

## How do I use it?

###0. System Requirements
* [Java 6](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
* [Maven 3.0](http://maven.apache.org) or later
* Red Hat JBoss Enterprise Application Platform (EAP) 6.3.0.GA
* An HTML5 compatible browser such as Chrome, Safari 5+, Firefox 5+, or IE 9+ are required. 

**Note:** some behaviors will vary slightly (e.g. validations) based on browser support, especially IE 9.

Mobile web support is limited to Android and iOS devices.

###1. Prepare Maven Libraries
This quickstart is designed to be built with Maven. It requires the JBoss Unified Push and JBoss EAP 6.3.0 Maven repositories.

You must have the JBoss Unified Push Maven repository available and Maven configured to use it. For more information, see the [JBoss Unified Push documentation](https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Unified_Push/) or the README distributed with the JBoss Unified Push Maven repository.


###2. Start the JBoss EAP Server
1. Open a command line and navigate to the root of the JBoss EAP directory.
2. The following shows the command line to start the server with the default profile:
```shell
For Linux:   EAP_HOME/bin/standalone.sh
For Windows: EAP_HOME\bin\standalone.bat
```

**Note:** Adding "-b 0.0.0.0" to the above commands will allow external clients (phones, tablets, desktops, etc...) to connect through your local network.

For example
```shell
For Linux:   EAP_HOME/bin/standalone.sh -b 0.0.0.0
For Windows: EAP_HOME\bin\standalone.bat -b 0.0.0.0
```

If you are running multiple servers on the same machine you can use `jboss.socket.binding.port-offset` to avoid port conflicts:
```shell
For Linux:   EAP_HOME/bin/standalone.sh -b 0.0.0.0 -Djboss.socket.binding.port-offset=1000
For Windows: EAP_HOME\bin\standalone.bat -b 0.0.0.0 -Djboss.socket.binding.port-offset=1000
```
###3. Configure the REST API server
This web application can be configured to use the `push-contacts-mobile-picketlink-secured` or the `contacts-mobile-proxy` as the backend REST API.
To switch between backends update `CONTACTS.app.serverUrl` in `src/main/webapp/js/app.js`:
```java
CONTACTS.app.serverUrl = "http://localhost:9080/jboss-push-contacts-mobile-picketlink-secured";
```
or
```java
CONTACTS.app.serverUrl = "http://localhost:8080/jboss-contacts-mobile-proxy";
```

**Note:** the port numbers above might be different for your current setup.

Please refer to the documentation for [push-contacts-mobile-picketlink-secured](../../server/push-contacts-mobile-picketlink-secured) and [contacts-mobile-proxy](../../server/contacts-mobile-proxy) for details about deploying these quickstarts.

###4. Build and Deploy the Quickstart
1. Make sure you have started the JBoss EAP server as described above.
2. Open a command line and navigate to the root directory of this quickstart.
3. Type this command to build and deploy the archive:
```shell
mvn clean package jboss-as:deploy
```
4. This deploys `target/jboss-contacts-mobile-webapp.war` to the running instance of the server.

###5. Test Application
Access the running client application in a browser at the following URL: <http://localhost:8080/jboss-contacts-mobile-webapp/>. You can use one of the default user credentials ('_maria:maria_','_dan:dan_', or '_john:john_').
The app is made up of the following pages:

**Main page**

* Displays a list of contacts
* Search bar for the list
* Details button changes to the Detailed list
* Clicking on a contact brings up an Edit form
* Menu button (in upper left) opens menu

**Menu pullout**

* Add a new Contact
* List/Detail view switcher, depending on what is currently displayed
* About information
* Theming - apply various themes (only on the List view)

**Details page**

* Same as Main page except all information is displayed with each contact

**Add form**

* First name, Last name, Phone, Email, and BirthDate fields
* Save = submit the form
* Clear = reset the form but stay on the form
* Cancel = reset the form and go the Main page

**Edit form**

* Same as Add form
* Delete button will delete the contact currently viewed and return you to the Main page

###6. Undeploy the Quickstart

1. Make sure you have started the JBoss EAP server as described above.
2. Open a command line and navigate to the root directory of this quickstart.
3. When you are finished testing, type this command to undeploy the archive:
```shell
mvn jboss-as:undeploy
```

## FAQ

Why can't I enter a date in the birthdate field?

  * Chrome has a [bug](https://code.google.com/p/chromium/issues/detail?id=232296) in it
    * Use the arrow keys to change the date: up arrow key, tab to day, up arrow key, tab to year, up arrow key
    * Use the date picker: a large black down arrow between the up/down arrows and the big X on the right side.
  * Firefox, IE, and Safari require strict formatting of YYYY-DD-MM, *Note:* It must be a dash and not a slash
  

## Minification
By default, the project uses the [wro4j](http://code.google.com/p/wro4j/) plugin, which provides the ability to concatenate, validate and minify JavaScript and CSS files. These minified files, as well as their unmodified versions are deployed with the project.  

With just a few quick changes to the project, you can link to the minified versions of your JavaScript and CSS files.  

First, in the `<project-root>/src/main/webapp/index.html` file, search for references to minification and comment or uncomment the appropriate lines.

Finally, wro4j runs in the compile phase so any standard build command like package, install, etc. will trigger it.  
The plugin is in a profile with an id of `minify` so you will want to specify that profile in your maven build. For example:
```shell
mvn clean package jboss-as:deploy -Pminify,default
```

## Run the QUnit tests
QUnit is a JavaScript unit testing framework used and built by jQuery. Because JavaScript code is the core of this HTML5 application, this quickstart provides a set of QUnit tests that automate testing of this code in various browsers. Executing QUnit test cases are quite easy.  

Simply load the following HTML in the browser you wish to test.
```
/path/to/push-contacts-mobile/client/contacts-mobile-webapp/src/test/qunit/index.html
```
**Note:** If you use `Chrome`, some date tests fail. These are false failures and are known issues with Chrome. FireFox, Safari, and IE run the tests correctly.

You can also display the tests using the Eclipse built-in browser.

For more information on QUnit tests see http://docs.jquery.com/QUnit

## Use the Project with an IDE
You can import this project into an IDE (JBoss Developer Studio, NetBeans or IntelliJ IDEA). If you are using JBoss Developer Studio you must import the project as a Maven project. If you are using NetBeans 6.8 or IntelliJ IDEA 9, then you can open the project as an existing project as both of these IDEs recognize Maven projects natively.

You can also start the server and deploy the quickstarts from JBoss Developer Studio. For more information , see the [Get Started with JBoss Developer Studio](http://www.jboss.org/products/devstudio/get-started/ "Get Started with JBoss Developer Studio").

If you want to be able to debug into the source code or look at the Javadocs of any library in the project, you can run either of the following two commands to pull them into your local repository. The IDE should then detect them.

```shell
$ mvn dependency:sources
$ mvn dependency:resolve -Dclassifier=javadoc
```

