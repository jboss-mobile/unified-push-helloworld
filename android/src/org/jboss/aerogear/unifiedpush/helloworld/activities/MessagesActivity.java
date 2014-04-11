/**
 * JBoss, Home of Professional Open Source
 * Copyright Red Hat, Inc., and individual contributors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * 	http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.jboss.aerogear.unifiedpush.helloworld.activities;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import org.jboss.aerogear.android.unifiedpush.MessageHandler;
import org.jboss.aerogear.android.unifiedpush.Registrations;
import org.jboss.aerogear.unifiedpush.helloworld.HelloWorldApplication;
import org.jboss.aerogear.unifiedpush.helloworld.R;
import org.jboss.aerogear.unifiedpush.helloworld.handler.NotificationBarMessageHandler;

import java.util.ArrayList;
import java.util.List;

public class MessagesActivity extends Activity implements MessageHandler {

    private HelloWorldApplication application;
    private ListView listView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.messages);

        application = (HelloWorldApplication) getApplication();

        listView = (ListView) findViewById(R.id.messages);

        if (getIntent().getExtras() != null) {
            addNewMessage(getIntent().getExtras());
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        Registrations.registerMainThreadHandler(this);
        Registrations.unregisterBackgroundThreadHandler(NotificationBarMessageHandler.instance);

        displayMessages();
    }

    @Override
    protected void onPause() {
        super.onPause();
        Registrations.unregisterMainThreadHandler(this);
        Registrations.registerBackgroundThreadHandler(NotificationBarMessageHandler.instance);
    }

    @Override
    public void onMessage(Context context, Bundle message) {
        addNewMessage(message);
    }

    @Override
    public void onDeleteMessage(Context context, Bundle message) {
    }

    @Override
    public void onError() {
    }

    private void addNewMessage(Bundle message) {
        application.addMessage(message.getString("alert"));
        displayMessages();
    }

    private void displayMessages() {
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getApplicationContext(),
                R.layout.message_item, application.getMessages());
        listView.setAdapter(adapter);
    }
}
