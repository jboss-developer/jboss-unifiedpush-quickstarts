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
package org.jboss.aerogear.unifiedpush.quickstart.activities;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import org.jboss.aerogear.android.Callback;
import org.jboss.aerogear.android.unifiedpush.PushConfig;
import org.jboss.aerogear.android.unifiedpush.PushRegistrar;
import org.jboss.aerogear.android.unifiedpush.Registrations;
import org.jboss.aerogear.unifiedpush.quickstart.R;
import org.jboss.aerogear.unifiedpush.quickstart.model.User;
import org.jboss.aerogear.unifiedpush.quickstart.util.WebClient;

import java.net.URI;
import java.net.URISyntaxException;

import static org.jboss.aerogear.unifiedpush.quickstart.Constants.*;

public class LoginActivity extends Activity {

    private ProgressDialog dialog;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.login);

        final TextView username = (TextView) findViewById(R.id.username);
        final TextView password = (TextView) findViewById(R.id.password);

        final Button login = (Button) findViewById(R.id.login);
        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                login(username.getText().toString(), password.getText().toString());
            }
        });
    }

    private void login(final String username, final String password) {
        new AsyncTask<Void, Void, User>() {
            @Override
            protected void onPreExecute() {
                super.onPreExecute();
                dialog = ProgressDialog.show(LoginActivity.this, getString(R.string.wait),
                    getString(R.string.login), true, true);
            }

            @Override
            protected User doInBackground(Void... voids) {
                return new WebClient().authenticate(username, password);
            }

            @Override
            protected void onPostExecute(User loggedUser) {
                if (loggedUser != null) {
                    registerLoggedUserInUnifiedPushServer(loggedUser);
                } else {
                    dialog.dismiss();
                    Toast.makeText(getApplicationContext(),
                        getString(R.string.an_error_occurred), Toast.LENGTH_SHORT).show();
                }
            }
        }.execute();
    }

    private void registerLoggedUserInUnifiedPushServer(User user) {
        try {

            PushConfig config = new PushConfig(new URI(UNIFIED_PUSH_URL), GCM_SENDER_ID);
            config.setVariantID(VARIANT_ID);
            config.setSecret(SECRET);
            config.setAlias(user.getUserName());

            Registrations registrations = new Registrations();
            PushRegistrar registrar = registrations.push("register", config);
            registrar.register(getApplicationContext(), new Callback<Void>() {
                @Override
                public void onSuccess(Void data) {
                    dialog.dismiss();
                    Intent intent = new Intent(getApplicationContext(), ContactsActivity.class);
                    startActivity(intent);
                    finish();
                }

                @Override
                public void onFailure(Exception e) {
                    dialog.dismiss();
                    Toast.makeText(getApplicationContext(), e.getMessage(), Toast.LENGTH_LONG).show();
                }
            });

        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }

}
