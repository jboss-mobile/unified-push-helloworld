# helloworld-push-android: Basic Mobile Application showing the AeroGear Push feature on Android

Author: Daniel Passos (dpassos)   
Level: Beginner   
Technologies: Java, Android   
Summary: A basic example of Push : Registration and receiving messages.   
Target Product: Mobile   
Product Versions: MP 1.0
Source: https://github.com/aerogear/aerogear-push-helloworld/android   

## What is it?

This project is a very simple helloworld, to show how to get started with the UnifiedPush Server on Android.

## System requirements

* [Java 7](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
* [Maven 3.1.1](http://maven.apache.org)
* Latest [Android SDK](https://developer.android.com/sdk/index.html) and [Platform version](http://developer.android.com/tools/revisions/platforms.html)
* Latest [Android Support Library](http://developer.android.com/tools/support-library/index.html) and [Google Play Services](http://developer.android.com/google/play-services/index.html)
* Latest [Maven Android SDK Deployer](https://github.com/mosabua/maven-android-sdk-deployer)

## Pre-requisites

* Create a variant on UnifiedPush admin console
* A physical device (push notifications are not available for emulators)

## Building and deploying

### Push Configuration

At android/src/org/jboss/aerogear/unifiedpush/helloworld/Constants.java find and replace UPS URL, variant, secret and GCM sender id:

```
String UNIFIED_PUSH_URL = "";
String VARIANT_ID = "";
String SECRET = "";
String GCM_SENDER_ID = "";
```

## Application Flow

### Registration

`RegisterActivity` is invoked right after a successful application login. The Activity life cycle `onCreate` is called first invoking the `register` method — attempting to register the application to receive push notifications.

```java
PushConfig config = new PushConfig(new URI(UNIFIED_PUSH_URL), GCM_SENDER_ID);
config.setVariantID(VARIANT_ID);
config.setSecret(SECRET);

Registrations registrations = new Registrations();
PushRegistrar registrar = registrations.push("register", config);
registrar.register(getApplicationContext(), new Callback<Void>() {
    @Override
    public void onSuccess(Void data) {
        Toast.makeText(getApplicationContext(),
                getApplicationContext().getString(R.string.registration_successful),
                Toast.LENGTH_LONG).show();
    }

    @Override
    public void onFailure(Exception e) {
        Toast.makeText(getApplicationContext(), e.getMessage(), Toast.LENGTH_LONG).show();
        finish();
    }
});

```

### Receiving Notifications

Before the usage of GCM notifications on Android, we need to include some permissions for GCM and a broadcast receiver to handle push messages from the service.

To enable the permissions we add these as child of the manifest element.

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.GET_ACCOUNTS" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />

<permission
    android:name="com.mypackage.C2D_MESSAGE"
    android:protectionLevel="signature" />

<uses-permission android:name="org.jboss.aerogear.unifiedpush.helloworld" />
```

And add this element as a child of the application element, to register the default AeroGear Android broadcast receiver. It will receive all messages and dispatch the message to registered handlers.

```xml
<receiver
    android:name="org.jboss.aerogear.android.unifiedpush.AeroGearGCMMessageReceiver"
    android:permission="com.google.android.c2dm.permission.SEND" >
    <intent-filter>
        <action android:name="com.google.android.c2dm.intent.RECEIVE" />
        <category android:name="org.jboss.aerogear.unifiedpush.helloworld" />
    </intent-filter>
</receiver>
```

All push messages are received by an instance of `AeroGearGCMMessageReceiver`. They are processed and passed to Registrations via the `notifyHandlers` method.

The `NotificationBarMessageHandler` is able to receive that message and show it in the Notification Bar.

In the `MessagesActivity` we need to remove the handler when the Activity goes into the background and re-enable it when it comes into the foreground.

```java
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
```

### Sending Push Notifications

Now you can send a message to your device using the UnifiedPush admin console. Click on the "Send Push" icon in the navigation menu and select the application that you created and wish to send a notification to. Write a message in the text field and hit 'Send Push Notification'.

![import](../cordova/doc/compose-message.png)

## FAQ

### Build dependencies locally

Google doesn't ship all the needed libraries to maven central. You need to deploy them locally with [maven-android-sdk-deployer](https://github.com/mosabua/maven-android-sdk-deployer).

#### Checkout maven-android-sdk-deployer
```
git clone git://github.com/mosabua/maven-android-sdk-deployer.git
```

#### Install android platform
```
cd $PWD/maven-android-sdk-deployer/platforms/android-19
mvn install -N --quiet
```

#### Install google-play-services
```
cd $PWD/maven-android-sdk-deployer/extras/google-play-services
mvn  install -N --quiet
```

#### Install compatibility-v4
```
cd $PWD/maven-android-sdk-deployer/extras/compatibility-v4
mvn install -N --quiet
```

#### Install compatibility-v7-appcompat
```
cd $PWD/maven-android-sdk-deployer/extras/compatibility-v7-appcompat
mvn install -N --quiet
```


## Debug the Application

```
mvn clean package android:deploy android:run
```
