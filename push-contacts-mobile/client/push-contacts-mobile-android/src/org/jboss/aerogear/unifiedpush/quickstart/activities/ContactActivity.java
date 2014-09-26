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

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.ActionBarActivity;
import android.view.MenuItem;
import android.view.View;
import android.widget.*;
import org.jboss.aerogear.unifiedpush.quickstart.Constants;
import org.jboss.aerogear.unifiedpush.quickstart.R;
import org.jboss.aerogear.unifiedpush.quickstart.model.Contact;
import org.jboss.aerogear.unifiedpush.quickstart.util.WebClient;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

import static android.widget.Toast.LENGTH_SHORT;

public class ContactActivity extends ActionBarActivity {

    private EditText firstName;
    private EditText lastName;
    private EditText phone;
    private EditText email;
    private EditText birthDate;

    private final Calendar dateSelected = Calendar.getInstance();
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    private Contact contact;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.contact);

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        firstName = (EditText) findViewById(R.id.first_name);
        lastName = (EditText) findViewById(R.id.last_name);
        phone = (EditText) findViewById(R.id.phone);
        email = (EditText) findViewById(R.id.email);
        birthDate = (EditText) findViewById(R.id.birth_date);

        ImageView calendar = (ImageView) findViewById(R.id.calendar);
        calendar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DialogFragment newFragment = new DatePickerFragment();
                newFragment.show(getSupportFragmentManager(), "datePicker");
            }
        });

        Button save = (Button) findViewById(R.id.save);
        save.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (isValidForm()) {
                    Contact contact = retriveContactFromForm();
                    save(contact);
                }
            }
        });

        contact = (Contact) getIntent().getSerializableExtra(Constants.CONTACT);
        if (contact != null) {
            fillForm(contact);
        } else {
            contact = new Contact();
        }

    }

    public boolean onOptionsItemSelected(MenuItem item) {
        finish();
        return super.onOptionsItemSelected(item);
    }

    private void fillForm(Contact contact) {
        firstName.setText(contact.getFirstName());
        lastName.setText(contact.getLastName());
        phone.setText(contact.getPhoneNumber());
        email.setText(contact.getEmail());
        birthDate.setText(contact.getBirthDate());

        try {
            dateSelected.setTime(dateFormat.parse(contact.getBirthDate()));
        } catch (ParseException e) {
            Toast.makeText(getApplicationContext(), getString(R.string.an_error_occurred), Toast.LENGTH_SHORT).show();
        }
    }

    private Contact retriveContactFromForm() {
        contact.setFirstName(firstName.getText().toString());
        contact.setLastName(lastName.getText().toString());
        contact.setPhoneNumber(phone.getText().toString());
        contact.setEmail(email.getText().toString());
        contact.setBirthDate(dateFormat.format(dateSelected.getTime()));
        return contact;
    }

    private void save(final Contact contact) {
        new AsyncTask<Void, Void, Boolean>() {
            ProgressDialog dialog;

            @Override
            protected void onPreExecute() {
                super.onPreExecute();
                dialog = ProgressDialog.show(ContactActivity.this, getString(R.string.wait),
                    getString(R.string.saving_contact), true, true);
            }

            @Override
            protected Boolean doInBackground(Void... voids) {
                return new WebClient().saveContact(contact);
            }

            @Override
            protected void onPostExecute(Boolean registered) {
                dialog.dismiss();
                if (registered) {
                    if (contact.getId() == null) {
                        Toast.makeText(getApplicationContext(), getString(R.string.contact_added), LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(getApplicationContext(), getString(R.string.contact_updated), LENGTH_SHORT).show();
                    }
                    finish();
                } else {
                    Toast.makeText(getApplicationContext(), getString(R.string.an_error_occurred), LENGTH_SHORT).show();
                }
            }
        }.execute();
    }

    private boolean isValidForm() {
        boolean valid = true;
        List<EditText> componentsToValidate = Arrays.asList(firstName, lastName, phone, email, birthDate);
        for (TextView textView : componentsToValidate) {
            if (textView.getText().toString().length() < 1) {
                textView.setError(getString(R.string.cannot_blank));
                valid = false;
            } else {
                if ((textView.getId() == R.id.phone) && !(isValidPhone(textView.getText().toString()))) {
                    String errorMessage = getString(R.string.use_phone_us_format);
                    textView.setError(errorMessage);
                    valid = false;
                }
                if (textView.getId() == R.id.email && !(isValidEmail(textView.getText().toString()))) {
                    String errorMessage = getString(R.string.error_email);
                    textView.setError(errorMessage);
                    valid = false;
                }
            }
        }

        return valid;
    }

    private boolean isValidPhone(String phoneNumber) {
        String strippedNumber = phoneNumber.replaceAll("[^a-zA-Z0-9]", "").trim();
        return strippedNumber.length() == 10;
    }

    private boolean isValidEmail(String emailAddress) {
        boolean valid = true;

        if (!emailAddress.contains("@")) {
            valid = false;
        } else {
            String[] emailParts = emailAddress.split("@");
            if (emailParts.length != 2) {
                valid = false;
            } else {
                String address = emailParts[0];
                String host = emailParts[1];

                if (address.isEmpty() || host.isEmpty()) {
                    valid = false;
                }
            }
        }
        return valid;
    }

    public class DatePickerFragment extends DialogFragment implements DatePickerDialog.OnDateSetListener {

        @Override
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            int year = dateSelected.get(Calendar.YEAR);
            int month = dateSelected.get(Calendar.MONTH);
            int day = dateSelected.get(Calendar.DAY_OF_MONTH);

            return new DatePickerDialog(getActivity(), this, year, month, day);
        }

        public void onDateSet(DatePicker view, int year, int month, int day) {
            dateSelected.set(Calendar.DAY_OF_MONTH, day);
            dateSelected.set(Calendar.MONTH, month);
            dateSelected.set(Calendar.YEAR, year);
            birthDate.setText(dateFormat.format(dateSelected.getTime()));
        }
    }

}
