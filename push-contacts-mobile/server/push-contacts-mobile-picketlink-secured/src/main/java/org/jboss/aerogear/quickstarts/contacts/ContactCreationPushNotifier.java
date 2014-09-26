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
package org.jboss.aerogear.quickstarts.contacts;

import org.jboss.aerogear.unifiedpush.JavaSender;
import org.jboss.aerogear.unifiedpush.SenderClient;
import org.jboss.aerogear.unifiedpush.message.MessageResponseCallback;
import org.jboss.aerogear.unifiedpush.message.UnifiedMessage;
import org.jboss.aerogear.quickstarts.contacts.customer.Contact;
import org.jboss.aerogear.quickstarts.contacts.util.QuickStartConfiguration;

import javax.persistence.PostPersist;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Sends a push notification to all mobile devices to inform them that a new Contact has been created using
 * UnifiedPush server.
 */
public class ContactCreationPushNotifier {
    private static final Logger logger = Logger.getLogger(ContactCreationPushNotifier.class.getName());

    private final QuickStartConfiguration configuration;

    private JavaSender javaSender;

    public ContactCreationPushNotifier() {
        this.configuration = new QuickStartConfiguration().read();
        javaSender = new SenderClient.Builder(this.configuration.getServerUrl()).build();
        System.setProperty("jsse.enableSNIExtension", "false");

    }

    @PostPersist
    public void postPersist(Object object) {
        if (object instanceof Contact) {
            final Contact contact = (Contact) object;
            sendMessage(contact.getId(), String.format("New contact '%s' created", toString(contact)));
        }
    }

    private void sendMessage(Long id, String message) {
        UnifiedMessage unifiedMessage = new UnifiedMessage.Builder()
            .pushApplicationId(this.configuration.getPushApplicationId())
            .masterSecret(this.configuration.getMasterSecret())
            .attribute("id", String.valueOf(id))
            .alert(message)
            .sound("default")
            .contentAvailable()
            .build();

        javaSender.send(unifiedMessage, new MessageResponseCallback() {
            @Override
            public void onComplete(int statusCode) {
                logger.info("Message submitted");
            }

            @Override
            public void onError(Throwable throwable) {
                logger.log(Level.SEVERE, "An error occurred", throwable);
            }
        });

    }

    private String toString(Contact contact) {
        return contact.getFirstName() + " " + contact.getLastName();
    }
}
