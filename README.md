## Overview

The following describe how to run the sample code of the In-app Chat UIKit.

## Prepare the environment

Before you begin, make sure your environment meets the following:

- Xcode 7.0 or later.
- A real iOS device that is running on iOS 9.0 or later and supports audio and video.
- The device is connected to the internet.

## Prerequisites

- Go to [ZEGOCLOUD Admin Console\|_blank](https://console.zegocloud.com/) and do the following:
    1.  Create a project, and get the `AppID` and `AppSign` of your project. 
    2.  Subscribe the **In-app Chat** service.

## Run the sample code

### Sample code directory structure

```bash
├── Podfile ----------------------------------------------Related third-party library configurations that the project depends on
├── Pods -------------------------------------------------Related third-party libraries on which the project depends
├── ZIMKitDemo.xcworkspace -------------------------------Project can be opened with XCode
└── ZIMKitDemo
    ├── AppDelegate.m
    ├── AppDelegate.h
    ├── KeyCenter
    │   ├── KeyCenter.h
    │   └── KeyCenter.m----------------------------------- Fill in the AppID you get
    ├── Login ---------------------------------------------Login related
    ├── Conversation --------------------------------------Session list related
    ├── TokenGenerator ------------------------------------Token related
    ├── zh-Hans.lproj -------------------------------------Multilanguage files
    ├── podfile -------------------------------------------Demo related dependencies
    ├── Assets.xcassets -----------------------------------dDemo resource images
    └── Util ----------------------------------------------Utilities that the demo uses
```

### Run the sample code

1. Downlaod the sample code, open the `KeyCenter.m` file under the `ZIMKit-IOS/ZIMKitDemo/ZIMKitDemo/KeyCenter` folder, and fill in the AppID and AppSign you get from the ZEGOCLOUD Admin Console.

   ```objc
   + (unsigned int)appID {
        return 0; //AppID
    }

   + (NSString *)AppSign{
        return @""; //AppSign
    }
   ```

2. Go to the `ZIMKit-IOS/ZIMKitDemo/` and run the command `pod install` to install dependencies. 

   ```bash
    pod install
   ```
3. After finishing the above steps, you can complile and run the In-app Chat UIKit.
