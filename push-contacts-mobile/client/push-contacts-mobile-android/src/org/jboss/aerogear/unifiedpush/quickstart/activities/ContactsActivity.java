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

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.view.ActionMode;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;
import org.jboss.aerogear.android.unifiedpush.MessageHandler;
import org.jboss.aerogear.android.unifiedpush.Registrations;
import org.jboss.aerogear.unifiedpush.quickstart.Constants;
import org.jboss.aerogear.unifiedpush.quickstart.R;
import org.jboss.aerogear.unifiedpush.quickstart.adapter.ContactAdapeter;
import org.jboss.aerogear.unifiedpush.quickstart.handler.NotificationBarMessageHandler;
import org.jboss.aerogear.unifiedpush.quickstart.model.Contact;
import org.jboss.aerogear.unifiedpush.quickstart.util.WebClient;

import java.util.List;

import static android.widget.Toast.LENGTH_SHORT;

public class ContactsActivity extends ActionBarActivity implements MessageHandler {

    private List<Contact> contacts;
    private int conctactSelected = -1;

    private ListView listView;
    private ActionMode mActionMode;
    private ActionMode.Callback mActionModeCallback = new ActionMode.Callback() {

        @Override
        public boolean onCreateActionMode(ActionMode mode, Menu menu) {
            MenuInflater inflater = mode.getMenuInflater();
            inflater.inflate(R.menu.context_menu, menu);
            return true;
        }

        @Override
        public boolean onPrepareActionMode(ActionMode mode, Menu menu) {
            mode.setTitle(getString(R.string.select_contacts_remove));
            return false;
        }

        @Override
        public boolean onActionItemClicked(ActionMode mode, MenuItem item) {
            switch (item.getItemId()) {
                case R.id.delete:
                    Contact contact = (Contact) listView.getItemAtPosition(conctactSelected);
                    deleteFromServer(contact);
                    mode.finish();
                    conctactSelected = -1;
                    return true;
                default:
                    return false;
            }
        }

        @Override
        public void onDestroyActionMode(ActionMode mode) {
            updateContactList();
            mActionMode = null;
        }

    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.contacts);

        listView = (ListView) findViewById(R.id.contact_list);
        listView.setChoiceMode(ListView.CHOICE_MODE_SINGLE);
        listView.setItemsCanFocus(false);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (mActionMode != null) {
                    conctactSelected = position;
                    view.setSelected(true);
                    mActionMode.invalidate();
                } else {
                    Contact contact = (Contact) parent.getItemAtPosition(position);
                    Intent intent = new Intent(getApplicationContext(), ContactActivity.class);
                    intent.putExtra(Constants.CONTACT, contact);
                    startActivity(intent);
                }
            }
        });
        listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> adapterView, View view, int position, long id) {
                if (mActionMode != null) {
                    return false;
                }
                mActionMode = ContactsActivity.this.startSupportActionMode(mActionModeCallback);
                conctactSelected = position;
                view.setSelected(true);
                mActionMode.invalidate();
                return true;
            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();
        retrieveContacts();
    }

    @Override
    protected void onResume() {
        super.onResume();
        Registrations.registerMainThreadHandler(this);
        Registrations.unregisterBackgroundThreadHandler(NotificationBarMessageHandler.instance);
    }

    @Override
    protected void onPause() {
        super.onPause();
        Registrations.unregisterMainThreadHandler(this);
        Registrations.registerBackgroundThreadHandler(NotificationBarMessageHandler.instance);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_contacts, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.new_contact) {
            Intent intent = new Intent(this, ContactActivity.class);
            startActivity(intent);
        } else if (item.getItemId() == R.id.logout) {
            new AsyncTask<Void, Void, Void>() {
                @Override
                protected Void doInBackground(Void... voids) {
                    new WebClient().logout();
                    return null;
                }

                @Override
                protected void onPostExecute(Void aVoid) {
                    Intent intent = new Intent(getApplicationContext(), LoginActivity.class);
                    startActivity(intent);
                    finish();
                }
            }.execute();
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onMessage(Context context, Bundle message) {
        Toast.makeText(getApplicationContext(), message.getString("alert"), Toast.LENGTH_SHORT).show();
        retrieveContacts();
    }

    @Override
    public void onDeleteMessage(Context context, Bundle message) {
    }

    @Override
    public void onError() {
    }

    private void retrieveContacts() {
        new AsyncTask<Void, Void, List<Contact>>() {
            ProgressDialog dialog;

            @Override
            protected void onPreExecute() {
                super.onPreExecute();
                dialog = ProgressDialog.show(ContactsActivity.this, getString(R.string.wait),
                    getString(R.string.loading_contacts), true, true);
            }

            @Override
            protected List<Contact> doInBackground(Void... voids) {
                return new WebClient().contacts();
            }

            @Override
            protected void onPostExecute(List<Contact> contactList) {
                ContactsActivity.this.contacts = contactList;
                updateContactList();
                dialog.dismiss();
            }
        }.execute();
    }

    private void updateContactList() {
        listView.setAdapter(new ContactAdapeter(getApplicationContext(), this.contacts));
    }

    private void deleteFromServer(final Contact contact) {
        new AsyncTask<Void, Void, Boolean>() {
            ProgressDialog dialog;

            @Override
            protected void onPreExecute() {
                super.onPreExecute();
                dialog = ProgressDialog.show(ContactsActivity.this, getString(R.string.wait),
                    getString(R.string.deleting_contacts), true, true);
            }

            @Override
            protected Boolean doInBackground(Void... voids) {
                return new WebClient().delete(contact);
            }

            @Override
            protected void onPostExecute(Boolean deleted) {
                dialog.dismiss();
                if (deleted) {
                    Toast.makeText(getApplicationContext(), getString(R.string.contact_deleted), LENGTH_SHORT).show();
                    contacts.remove(contact);
                    updateContactList();
                } else {
                    Toast.makeText(getApplicationContext(), getString(R.string.an_error_occurred), LENGTH_SHORT).show();
                }
            }
        }.execute();
    }

}
