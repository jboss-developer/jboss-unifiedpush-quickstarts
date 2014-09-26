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
package org.jboss.aerogear.unifiedpush.quickstart.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import org.jboss.aerogear.unifiedpush.quickstart.R;
import org.jboss.aerogear.unifiedpush.quickstart.model.Contact;

import java.util.List;

public class ContactAdapeter extends BaseAdapter {

    private final Context context;
    private final List<Contact> contactList;

    public ContactAdapeter(Context context, List<Contact> contactList) {
        this.context = context;
        this.contactList = contactList;
    }

    @Override
    public int getCount() {
        return contactList.size();
    }

    @Override
    public Contact getItem(int position) {
        return contactList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return getItem(position).getId();
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        Contact contact = getItem(position);

        View view = LayoutInflater.from(context).inflate(R.layout.contact_item, null);

        TextView name = (TextView) view.findViewById(R.id.name);
        name.setText(contact.getFirstName() + " " + contact.getLastName());

        TextView email = (TextView) view.findViewById(R.id.email);
        email.setText(contact.getEmail());

        return view;
    }
}
