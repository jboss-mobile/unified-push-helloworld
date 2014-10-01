helloworld-push-windows: Basic Mobile Application showing the AeroGear Push feature 
===================================================================================
Author: Erik Jan de Wit (edewit)   
Level: Beginner  
Technologies: Windows Phone   
Summary: A basic example of Push : Registration and receiving messages.  
Target Product: Mobile  
Product Versions: MP 1.0   
Source: https://github.com/aerogear/aerogear-push-helloworld/tree/master/windows

What is it?
-----------

This project is a very simple helloworld, to show how to get started with Windows Phone and the UnifiedPush Server

System requirements
-------------------

Visual Studio 2013

Build and Install
-----------------

Open the HelloWorld Visual Studio project and add the NuGet aerogear-push-sdk

```bash
PM> Install-Package aerogear-windows-push
```

Build and Deploy the HelloWorld
-------------------------------

## Change Push Configuration

In HelloWorld\MainPage.xaml.cs find the PushConfig and change the server url to your openshift instance alias and variant/secret:

```csharp
PushConfig pushConfig = new PushConfig() { UnifiedPushUri = new Uri(""), VariantId = "", VariantSecret = "" };
```

You can also copy/paste these settings from your UnifiedPush console

## Receiving push notifications

Be sure to update the `Package name` and `Publisher` in the `Package.appxmanifest` to the correct settings created in the Windows Dashboard

Application Flow
----------------

## Sending message
Now you can send a message to your device by clicking `Compose Message...` from the application page. Write a message in the text field and hit 'Send Push Message'. 

After a while you will see the message end up on the device. In the register function we've specified a notification event handler.
