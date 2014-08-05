aerogear-push-helloworld
========================

This repository contains the client's implementations showing off the basic usage of AeroGear UnifiedPush feature.


## Setting up an UnifiedPush Server instance

Before building and deploying the clients it's necessary to set up an _UnifiedPush Server_ instance. There are actually 3 options for doing this : 

* Using the OpenShift [AeroGear Cartridge](http://aerogear.org/docs/unifiedpush/ups_userguide/openshift/) . This is the easiest option, if you don't have an OpenShift account yet, you can freely sign up [here](https://www.openshift.com/app/account/new). 
* Download a released WAR, you can grab it [here](http://aerogear.org/push/) and then follow [these instructions](http://aerogear.org/docs/unifiedpush/ups_userguide/server-installation/) to set up the database and to deploy it on an Application Server.
* Build from the source : clone this [repo](https://github.com/aerogear/aerogear-unifiedpush-server) and then follow [these instructions](http://aerogear.org/docs/unifiedpush/ups_userguide/server-installation/) to set up the database and to deploy it on an Application Server.


## Creating an Application and the Variants

Once the UnifiedPush Server has been deployed, you will need to create an Application. Please refer to the [UnifiedPush Administration Console User Guide](http://aerogear.org/docs/unifiedpush/ups_userguide/admin-ui/).

Before creating the variants, some external setup on Google's Cloud console and/or Apple's Developer Portal is needed.

* For Android you can follow [these instructions](http://aerogear.org/docs/unifiedpush/aerogear-push-android/google-setup/)
* For iOS you can follow [these instructions](http://aerogear.org/docs/unifiedpush/aerogear-push-ios/app-id-ssl-certificate-apns/)


Finally, you will have to create your variants, instructions can be found in the [UnifiedPush Administration Console User Guide](http://aerogear.org/docs/unifiedpush/ups_userguide/admin-ui/) under the section "Create and Manage Variants"


