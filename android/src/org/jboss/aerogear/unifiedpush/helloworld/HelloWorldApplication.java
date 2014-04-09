package org.jboss.aerogear.unifiedpush.helloworld;

import android.app.Application;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class HelloWorldApplication extends Application {

    private List<String> messages;

    @Override
    public void onCreate() {
        super.onCreate();
        messages = new ArrayList<String>();
    }

    public List<String> getMessages() {
        return Collections.unmodifiableList(messages);
    }

    public void addMessage(String newMessage) {
        messages.add(newMessage);
    }

}
