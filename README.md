unified-push-helloworld
=======================

This repository contains the client's implementations showing off the basic usage of AeroGear UnifiedPush feature.

|                 | Project Info  |
| --------------- | ------------- |
| License:        | Apache License, Version 2.0  |
| Build:          | Maven  |
| Documentation:  | http://www.jboss.org/unifiedpush/  |
| Issue tracker:  | https://issues.jboss.org/browse/MP  |

## Setting up an UnifiedPush Server instance

Before building and deploying the clients it's necessary to set up an _UnifiedPush Server_ instance. There are actually 3 options for doing this :

* Using the OpenShift [AeroGear Cartridge](https://aerogear.org/docs/unifiedpush/ups_userguide/index/#openshift) . This is the easiest option, if you don't have an OpenShift account yet, you can freely sign up [here](https://www.openshift.com/app/account/new).
* Download the released WARs, you can grab them [here](https://aerogear.org/getstarted/downloads/#push) and then follow [these instructions](https://aerogear.org/docs/unifiedpush/ups_userguide/index/#server-installation) to set up the database and to deploy it on an Application Server.
* Build from the source : clone this [repo](https://github.com/aerogear/aerogear-unifiedpush-server) and then follow [these instructions](https://aerogear.org/docs/unifiedpush/ups_userguide/index/#server-installation) to set up the database and to deploy it on an Application Server.


## Creating an Application and the Variants

Once the UnifiedPush Server has been deployed, you will need to create an Application. Please refer to the [UnifiedPush Administration Console User Guide](https://aerogear.org/docs/unifiedpush/ups_userguide/index/#admin-ui).

Before creating the variants, some external setup on Google's Cloud console and/or Apple's Developer Portal is needed.

* For Android you can follow [these instructions](https://aerogear.org/docs/unifiedpush/aerogear-push-android/guides/#google-setup)
* For iOS you can follow [these instructions](https://aerogear.org/docs/unifiedpush/aerogear-push-ios/guides/#app-id-ssl-certificate-apns)


Finally, you will have to create your variants, instructions can be found in the [UnifiedPush Administration Console User Guide](https://aerogear.org/docs/unifiedpush/ups_userguide/index/#_wizard_step_2)

## Documentation

For more details about the current release, please consult [our documentation](https://aerogear.org/docs/unifiedpush/).

## Development

If you would like to help develop AeroGear you can join our [developer's mailing list](https://lists.jboss.org/mailman/listinfo/aerogear-dev), join #aerogear on Freenode, or shout at us on Twitter @aerogears.

Also takes some time and skim the [contributor guide](http://aerogear.org/docs/guides/Contributing/)

## Found a bug?

If you found a bug please create a ticket for us on [Jira](https://issues.jboss.org/browse/MP) with some steps to reproduce it.
