/*
 * JBoss, Home of Professional Open Source
 * Copyright 2014, Red Hat, Inc. and/or its affiliates, and individual
 * contributors by the @authors tag. See the copyright.txt in the
 * distribution for a full listing of individual contributors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

CONTACTS.namespace("CONTACTS.security.currentUser");
CONTACTS.namespace("CONTACTS.security.submitSignIn");
CONTACTS.namespace("CONTACTS.security.restSecurityEndpoint");

// Set this to undefined so that when the user is not logged in system doesn't think they are. This is referenced in 
// app.js (#contacts-list-page -> pagebeforeshow)
CONTACTS.security.currentUser = undefined;

CONTACTS.security.restSecurityEndpoint = CONTACTS.app.serverUrl + "/rest/security/";

/**
 * It is recommended to bind to this event instead of DOM ready() because this will work regardless of whether 
 * the page is loaded directly or if the content is pulled into another page as part of the Ajax navigation system.
 * 
 * The first thing you learn in jQuery is to call code inside the $(document).ready() function so everything 
 * will execute as soon as the DOM is loaded. However, in jQuery Mobile, Ajax is used to load the contents of 
 * each page into the DOM as you navigate, and the DOM ready handler only executes for the first page. 
 * To execute code whenever a new page is loaded and created, you can bind to the pagecreate event. 
 * 
 * 
 * These functions perform the Log out and Role Assignments.
 * 
 * @author Pedro Igor, Joshua Wilson
 */
$( document ).on( "pagecreate", function(mainEvent) {
    //Initialize the vars in the beginning so that you will always have access to them.
    var getCurrentTime = CONTACTS.util.getCurrentTime,
        restSecurityEndpoint = CONTACTS.security.restSecurityEndpoint;
});

/**
 * The regural jQuery AJAX functions go here.  We do all the jQuery Mobile security work in the section above this.
 * 
 * @author Pedro Igor, Joshua Wilson
 */
$(document).ready(function() {
    //Initialize the vars in the beginning so that you will always have access to them.
    var getCurrentTime = CONTACTS.util.getCurrentTime,
        restSecurityEndpoint = CONTACTS.security.restSecurityEndpoint;

    /**
     * Register a handler to be called when Ajax requests complete with an error. Whenever an Ajax request completes 
     * with an error, jQuery triggers the ajaxError event. Any and all handlers that have been registered with the 
     * .ajaxError() method are executed at this time. Note: This handler is not called for cross-domain script and 
     * cross-domain JSONP requests. - from the jQuery docs
     * 
     * This will be overridden by any ajax call that handles these errors it's self.
     */
	$(document).ajaxError(function( event, jqXHR, settings, errorThrown ) {
		// Whenever there is an AJAX event the authentication and authorization is verified. If the user is denied, then
		// the system will return an error instead of data. This is a "universal" error catcher for those denials.
        if (jqXHR.status == 403) {
        	// Authorization denied. (Does not have permissions)
//            $("body").pagecontainer("change", "#access-denied-dialog", { transition: "pop" });
            console.log(getCurrentTime() + " [js/security.js] (document.ajaxError) - error in ajax" +
                    " - jqXHR = " + jqXHR.status +
                    ", errorThrown = " + errorThrown);
        } else if (jqXHR.status == 401) {
        	// Authentication denied. (Not logged in)
            $("body").pagecontainer("change", "#signin-page");
            console.log(getCurrentTime() + " [js/security.js] (document.ajaxError) - error in ajax" +
            		" - jqXHR = " + jqXHR.status +
            		", errorThrown = " + errorThrown);
        }
    });

	// Log out when the 'Log out' button is clicked.
    $(".security-logout-btn").click(function(e) {
    	console.log(getCurrentTime() + " [js/security.js] (#security-logout-btn -> click) - start");
        
    	var jqxhr = $.ajax({
            url: restSecurityEndpoint + "logout",
            xhrFields: {withCredentials: true},
            // required to meet CORS filter requirements
            contentType: "application/json",
            type: "POST"
        }).done(function(data, textStatus, jqXHR) {
        	console.log(getCurrentTime() + " [js/security.js] (#security-logout-btn -> click) - Successfully logged out");
        	
        	// Once you have successfully logged out, redirect them to the log in page.
            $("body").pagecontainer("change", "#signin-page");
        }).fail(function(jqXHR, textStatus, errorThrown) {
            console.log(getCurrentTime() + " [js/security.js] (#security-logout-btn -> click) - error in ajax" +
            		" - jqXHR = " + jqXHR.status +
            		", errorThrown = " + errorThrown +
            		", responseText = " + jqXHR.responseText);
            $("body").pagecontainer("change", "#signin-page");
        });
        
        console.log(getCurrentTime() + " [js/security.js] (#security-logout-btn -> click) - end");
    });
    
    //Initialize all the AJAX form events.
    var initSecurity = function () {
    	console.log(getCurrentTime() + " [js/security.js] (initSecurity) - start");
        //Fetches the initial member data
        CONTACTS.security.submitSignIn();
        console.log(getCurrentTime() + " [js/security.js] (initSecurity) - end");
    };

    /**
     * Attempts to sign in using a JAX-RS POST.
     */
    CONTACTS.security.submitSignIn = function() {
    	console.log(getCurrentTime() + " [js/security.js] (submitSignIn) - start");
    	
        $("#signin-form").submit(function(event) {
        	console.log(getCurrentTime() + " [js/security.js] (submitSignIn) - submit event) - checking if the form is valid");
        	
        	// Ensure that the form has been validated.
            CONTACTS.validation.signInFormValidator.form();
            // If there are any validation error then don't process the submit.
            if (CONTACTS.validation.signInFormValidator.valid()){
            	console.log(getCurrentTime() + " [js/security.js] (submitSignIn) - submit event) - start");
                event.preventDefault();

                var serializedForm = $("#signin-form").serializeObject();
                var userData = JSON.stringify(serializedForm);

                // Send the login and password to the server for Auth-n and Auth-z
                var jqxhr = $.ajax({
                    url: restSecurityEndpoint + "user/info",
                    xhrFields: {withCredentials: true},
                    contentType: "application/json",
                    dataType: "json",
                    headers: {
                        "Authorization": "Basic " + btoa(serializedForm.loginName + ":" + serializedForm.password)
                    },
                    type: "GET"
                }).done(function(data, textStatus, jqXHR) {
                	console.log(getCurrentTime() + " [js/security.js] (submitSignIn) - ajax done");
                	
                    // Remove errors display as a part of the validation system.
                    $(".invalid").remove();

                    // Clear the form or else the next time you go to sign in the last one will still be there.
                    $("#signin-form")[0].reset();

                    // Store the global user data.
                    CONTACTS.security.currentUser = data;

                    // Because we turned off the automatic page transition to catch server side error we need to do it ourselves.
                    $( "body" ).pagecontainer( "change", "#contacts-list-page");

                }).fail(function(jqXHR, textStatus, errorThrown) {
                	// Remove errors display as a part of the validation system.
                	$(".invalid").remove();

                	if (jqXHR.status === 401) {
                		
                        // The name value must match a form name value exactly or else the message will be displayed at 
                		// the top of the form. If it does match an form input name then it will be displayed with the input.
                        var errorMsg = {invalid: "Invalid username and/or password. Please try again."};
                        
                        // If the log in fails then post an error on the form telling them the log in attempt was invalid.
                        CONTACTS.validation.displayServerSideErrors("#signin-form", errorMsg);
                        
                        console.log(getCurrentTime() + " [js/security.js] (submitSignIn) - error in ajax " +
                                " - jqXHR = " + jqXHR.status +
                                ", textStatus = " + textStatus +
                                ", errorThrown = " + errorThrown +
                                ", responseText = " + jqXHR.responseText);
                    } else {
                    	// Catch anything else that is not a log-in failure.
                        console.log(getCurrentTime() + " [js/submissions.js] (submitCreate) - error in ajax" +
                                " - jqXHR = " + jqXHR.status +
                                ", textStatus = " + textStatus +
                                ", errorThrown = " + errorThrown +
                                ", responseText = " + jqXHR.responseText);
                    
	                    // Extract the error messages from the server.
	                    var errorMsg = $.parseJSON(jqXHR.responseText);
	                    
	                    // Apply the error to the form.
	                    CONTACTS.validation.displayServerSideErrors("#signin-form", errorMsg);
	                }
                });
                console.log(getCurrentTime() + " [js/security.js] (submitSignIn) - submit event) - end");
            }
        });
    };

    initSecurity();
});
