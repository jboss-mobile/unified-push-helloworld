# helloworld-push-ios: Basic Mobile Application showing the AeroGear Push feature on iOS
---------
Author: Corinne Krych (ckrych)  
Level: Beginner  
Technologies: Objective-C, iOS  
Summary: A basic example of Push : Registration and receiving messages.  
Target Product: Mobile  
Product Versions: MP 1.0  
Source: https://github.com/aerogear/aerogear-push-helloworld/ios  

## What is it?
The ```helloworld``` project demonstrates how to include basic push functionality in iOS applications using the JBoss Mobile Add-On iOS Push plug-in.

This simple project consists of a ready-to-build iOS application. Before building the application, you must register the iOS variant of the application with a running AeroGear UnifiedPush Server instance and Apple Push Notification Service for iOS. The resulting unique IDs and other parameters must then be inserted into the application source code. After this is complete, the application can be built and deployed to iOS devices. 

When the application is deployed to an iOS device, the push functionality enables the device to register with the running AeroGear UnifiedPush Server instance and receive push notifications.

## How do I run it?

###0. System requirements
* iOS 7.X
* Xcode version 5.1.X

###1. Configuration

Before being able to use Push Notifications on your iOS Application, a few steps are required. You need to:

* Create a certificate Signing Request
* Create a new Apple App ID and a SSL certificate for APNs
* Create a Provisioning Profile

For information on these steps, see the AeroGear documentation: [Apple App ID and SSL Certificate for APNs](http://aerogear.org/docs/unifiedpush/aerogear-push-ios/app-id-ssl-certificate-apns) and [Apple Provisioning Profile](http://aerogear.org/docs/unifiedpush/aerogear-push-ios/provisioning-profiles).
  
###2. Register Application with Push Services

You must register the application and an iOS variant of the application with the AeroGear UnifiedPush Server. This requires a running AeroGear UnifiedPush Server instance and uses the unique metadata assigned to the application by APNS. For information on installing the AeroGear UnifiedPush Server, see the README distributed with the AeroGear UnifiedPush Server or the [AeroGear documentation](http://aerogear.org/docs/unifiedpush/ups_userguide/).

1. Log into the AeroGear UnifiedPush Server console.
2. In the ```Applications``` view, click ```Create Application```.
3. In the ```Name``` and ```Description``` fields, type values for the application and click ```Create```.
4. When created, under the application click ```No variants```.
5. Click ```Add Variant```.
6. In the ```Name``` and ```Description``` fields, type values for the iOS application variant.
7. Click ```iOS``` and type the values assigned to the project by APNS (you will have to upload your Developer or Production Certificate)
8. Click ```Add```.
9. When created, expand the variant name and make note of the ```Server URL```, ```Variant ID```, and ```Secret```.


###3. Customize and Build Application

Replace the bundleId with your bundleId (the one associated with your certificate).
Go to ```HelloWorld target -> Info``` and modify the ```Bundle Identifier```:

![change helloworld bundle](doc/change-helloworld-bundle.png)

Now open **HelloWorld.xcodeproj**.

In ```HelloWorld/AGAppDelegate.m``` find the pushConfig and change the server url to your AeroGear UnifiedPush Server instance, alias and variant/secret:

```objective-c
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // initialize "Registration helper" object using the
    // base URL where the "AeroGear Unified Push Server" is running.
    AGDeviceRegistration *registration =

    // WARNING: make sure, you start JBoss with the -b 0.0.0.0 option, to bind on all interfaces
    // from the iPhone, you can NOT use localhost
    [[AGDeviceRegistration alloc] initWithServerURL:[NSURL URLWithString:@"<# URL of the running AeroGear UnifiedPush Server #>"]];

    [registration registerWithClientInfo:^(id<AGClientDeviceInformation> clientInfo) {
        // You need to fill the 'Variant Id' together with the 'Variant Secret'
        // both received when performing the variant registration with the server.
        [clientInfo setVariantID:@"<# Variant Id #>"];
        [clientInfo setVariantSecret:@"<# Variant Secret #>"];

        // if the deviceToken value is nil, no registration will be performed
        // and the failure callback is being invoked!
        [clientInfo setDeviceToken:deviceToken];

        // apply the token, to identify THIS device
        UIDevice *currentDevice = [UIDevice currentDevice];

        // --optional config--
        // set some 'useful' hardware information params
        [clientInfo setOperatingSystem:[currentDevice systemName]];
        [clientInfo setOsVersion:[currentDevice systemVersion]];
        [clientInfo setDeviceType: [currentDevice model]];


    } success:^() {

        // Send NSNotification for success_registered, will be handle by registered AGViewController
        NSNotification *notification = [NSNotification notificationWithName:@"success_registered" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"Unified Push registration successful");

    } failure:^(NSError *error) {

        // Send NSNotification for error_register, will be handle by registered AGViewController
        NSNotification *notification = [NSNotification notificationWithName:@"error_register" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"Unified Push registration Error: %@", error);

    }];
}

```

###4. Test Application

#### Send a Push Message
You can send a push notification to your device using the UnifiedPush Server console by completing the following steps:

1. Log into the UnifiedPush Server console.
2. Click ```Send Push```.
3. From the ```Applications``` list, select the application.
4. In the ```Messages``` field, type the text to be sent as the push notification.
5. Click ```Send Push Notification```.  

![import](../cordova/doc/compose-message.png)
  
After a while you will see the message end up on the device.  
When the application is running in foreground, you can catch messages in AGAppDelegate's  ```application:didReceiveRemoteNotification:```. The event is forwarded using ```NSNotificationCenter``` for decoupling AGappDelegate and AGViewController. It will be the responsability of AGViewController's ```messageReceived:``` method to render the message on UITableView.

When the app is running in background, user can bring the app in the foreground by selecting the Push notification. Therefore AGAppDelegate's  ```application:didReceiveRemoteNotification:``` will be triggered and the message displayed on the list. If a background processing was needed we could have used ```application:didReceiveRemoteNotification:fetchCompletionHandler:```. Refer to [Apple documentation for more details](https://developer.apple.com/library/ios/documentation/uikit/reference/UIApplicationDelegate_Protocol/Reference/Reference.html#//apple_ref/occ/intfm/UIApplicationDelegate/application:didReceiveRemoteNotification:fetchCompletionHandler:)

For application not running, we're using AGAppDelegate's ```application:didFinishLaunchingWithOptions:```, we locally save the latest message and forward the event to AGViewController's ```messageReceived:```.

**NOTE**: The local save is required here because of the asynchronous nature of ```viewDidLoad``` vs ```application:didFinishLaunchingWithOptions:```


## How does it work?

### Registration

When the application is launched, AGAppDelegate's ```application:didFinishLaunchingWithOptions:``` registers the app to receive remote notifications. 

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: 
        (UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeSound | 
         UIRemoteNotificationTypeAlert)];    
    ...
}
```

Therefore, AGAppDelegate's ```application:didRegisterForRemoteNotificationsWithDeviceToken:``` will be called.

When AGAppDelegate's ```application:didRegisterForRemoteNotificationsWithDeviceToken:``` is called, the device is registered to UnifiedPush Server instance. This is where configuration changes are required (see code snippet below).


FAQ
--------------------

* Which iOS version is supported by AeroGear iOS libraries?

AeroGear supports iOS 7.0 and later.


Debug the Application
=====================

Set a break point in Xcode.


