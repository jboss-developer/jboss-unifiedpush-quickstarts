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
package org.jboss.aerogear.quickstarts.contacts.util;

import com.google.gson.Gson;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class QuickStartConfiguration {

    private String serverUrl;
    private String pushApplicationId;
    private String masterSecret;

    public QuickStartConfiguration() {
    }

    public String getMasterSecret() {
        return masterSecret;
    }

    public void setMasterSecret(String masterSecret) {
        this.masterSecret = masterSecret;
    }

    public String getPushApplicationId() {
        return pushApplicationId;
    }

    public void setPushApplicationId(String pushApplicationId) {
        this.pushApplicationId = pushApplicationId;
    }

    public String getServerUrl() {
        return serverUrl;
    }

    public void setServerUrl(String serverUrl) {
        this.serverUrl = serverUrl;
    }

    public static QuickStartConfiguration read() {
        BufferedReader bufferedReader = new BufferedReader(
            new InputStreamReader(QuickStartConfiguration.class.getClassLoader().getResourceAsStream("META-INF/quickstarts-config.json")));
        Gson gson = new Gson();
        return gson.fromJson(bufferedReader, QuickStartConfiguration.class);
    }
}
