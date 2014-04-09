package org.jboss.aerogear.unifiedpush.helloworld.activities;

import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.widget.Toast;
import org.jboss.aerogear.unifiedpush.helloworld.R;

public class SplashScreenActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash_screen);

        final Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(getApplicationContext(), "Time to start UPS registration", Toast.LENGTH_SHORT).show();
            }
        }, 3000);
    }
}
