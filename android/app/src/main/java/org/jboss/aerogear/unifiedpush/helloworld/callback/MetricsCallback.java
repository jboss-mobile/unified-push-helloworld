package org.jboss.aerogear.unifiedpush.helloworld.callback;

import android.util.Log;

import org.jboss.aerogear.android.core.Callback;
import org.jboss.aerogear.android.unifiedpush.metrics.UnifiedPushMetricsMessage;

public class MetricsCallback implements Callback<UnifiedPushMetricsMessage> {

    private static final String TAG = MetricsCallback.class.getName();

    @Override
    public void onSuccess(UnifiedPushMetricsMessage metricsMessage) {
        Log.i(TAG, "The message " + metricsMessage.getMessageId() + " was marked as opened");
    }

    @Override
    public void onFailure(Exception e) {
        Log.e(TAG, e.getMessage(), e);
    }
}
