# Auto Doctor
Auto Doctor is a framework for interfacing with OBD2 devices using iOS Bluetooth Low Energy capabilities.
### How to build?
**Xcode**
 If you have installed Xcode on you system then you can skip this. You will required Xcode to build and run the code. You can download Xcode from [here](https://apps.apple.com/in/app/xcode/id497799835?mt=12).
 
**Cocoapods**
 If you have already installed cocoapods on your device you can skip this section. You will required to install pods so your machine should have installed cocoapods. If not installed, please check cocoapods installation guide [here](https://guides.cocoapods.org/using/getting-started.html).

**How to install pods in application?**
Open code filder in terminal and write below line and hit enter. It will automatically install required pods.
```sh
pod install
```
### Basic Project Details
- Mac OS 10.5 or 10.5+
- Xcode 11.0 or 11.0+
- Open `.xcworkspace` file to build code(This file will display after installing cocoapods).

### Project Usage
After successfully run project you will have screen as below.
![Image1](https://github.com/kpadhiyar201/OBD2-BLE/blob/Development/1.png?raw=true)

Check label at top for bluetooth status. If it is powered off please go to settings and power on bluetooth.
Now click on `Pair` button to make connection with OBD BLE device.
> OBD BLE will not connect in application if device is not connected in Settings > Bluetooth > Connected devices. If connected please disconnect from **Settings** Application.

If device is successfully connected then label text will be changed to `Status: pairing successful`.
Click on `LTSupportAutomotive` button to check sensor data. When device starts getting sensor data, it will display data like below image.

![Image2](https://github.com/kpadhiyar201/OBD2-BLE/blob/Development/2.png?raw=true)

## Acknowledgements
#### Dependency
 - LTSupportAutomotive
