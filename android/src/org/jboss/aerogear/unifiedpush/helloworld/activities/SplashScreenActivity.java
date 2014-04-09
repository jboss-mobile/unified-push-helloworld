package org.jboss.aerogear.unifiedpush.helloworld.activities;

import android.app.Activity;
import android.os.Bundle;
import org.jboss.aerogear.unifiedpush.helloworld.R;

public class SplashScreenActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash_screen);
    }
}
