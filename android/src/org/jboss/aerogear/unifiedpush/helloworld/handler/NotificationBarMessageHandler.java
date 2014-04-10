package org.jboss.aerogear.unifiedpush.helloworld.handler;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import org.jboss.aerogear.android.unifiedpush.MessageHandler;
import org.jboss.aerogear.unifiedpush.helloworld.R;
import org.jboss.aerogear.unifiedpush.helloworld.activities.MessagesActivity;
import org.jboss.aerogear.unifiedpush.helloworld.activities.RegisterActivity;

public class NotificationBarMessageHandler implements MessageHandler {

    public static final int NOTIFICATION_ID = 1;
    private Context context;

    public static final NotificationBarMessageHandler instance = new NotificationBarMessageHandler();

    private NotificationBarMessageHandler() {
    }

    @Override
    public void onMessage(Context context, Bundle message) {
        this.context = context;
        sendNotification(message.getString("alert"));
    }

    private void sendNotification(String msg) {
        NotificationManager mNotificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        Intent intent = new Intent(context, MessagesActivity.class)
                .addFlags(PendingIntent.FLAG_UPDATE_CURRENT)
                .putExtra("alert", msg);

        PendingIntent contentIntent = PendingIntent.getActivity(context, 0, intent, 0);

        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(context)
                        .setAutoCancel(true)
                        .setSmallIcon(R.drawable.ic_launcher)
                        .setContentTitle(context.getString(R.string.app_name))
                        .setStyle(new NotificationCompat.BigTextStyle().bigText(msg))
                        .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))
                        .setContentText(msg);

        mBuilder.setContentIntent(contentIntent);
        mNotificationManager.notify(NOTIFICATION_ID, mBuilder.build());
    }

    @Override
    public void onDeleteMessage(Context context, Bundle arg0) {
    }

    @Override
    public void onError() {
    }

}
