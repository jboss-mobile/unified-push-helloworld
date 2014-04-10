package org.jboss.aerogear.unifiedpush.helloworld.activities;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;
import org.jboss.aerogear.android.Callback;
import org.jboss.aerogear.android.unifiedpush.PushConfig;
import org.jboss.aerogear.android.unifiedpush.PushRegistrar;
import org.jboss.aerogear.android.unifiedpush.Registrations;
import org.jboss.aerogear.unifiedpush.helloworld.R;

import java.net.URI;
import java.net.URISyntaxException;

import static org.jboss.aerogear.unifiedpush.helloworld.Constants.*;

public class RegisterActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.register);

        register();
    }

    private void register() {

        try {

            PushConfig config = new PushConfig(new URI(UNIFIED_PUSH_URL), GCM_SENDER_ID);
            config.setVariantID(VARIANT_ID);
            config.setSecret(SECRET);
            config.setAlias(ALIAS);

            Registrations registrations = new Registrations();
            PushRegistrar registrar = registrations.push("register", config);
            registrar.register(getApplicationContext(), new Callback<Void>() {
                @Override
                public void onSuccess(Void data) {
                    Toast.makeText(getApplicationContext(),
                            getApplicationContext().getString(R.string.registration_successful),
                            Toast.LENGTH_LONG).show();

                    Intent intent = new Intent(getApplicationContext(), MessagesActivity.class);
                    startActivity(intent);
                    finish();
                }

                @Override
                public void onFailure(Exception e) {
                    Toast.makeText(getApplicationContext(), e.getMessage(), Toast.LENGTH_LONG).show();
                }
            });

        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }

    }

}
