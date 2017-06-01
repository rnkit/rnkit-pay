[![npm][npm-badge]][npm]
[![react-native][rn-badge]][rn]
[![MIT][license-badge]][license]
[![bitHound Score][bithound-badge]][bithound]
[![Downloads](https://img.shields.io/npm/dm/rnkit-pay.svg)](https://www.npmjs.com/package/rnkit-pay)

收银台 for [React Native][rn].

[**Support me with a Follow**](https://github.com/simman/followers)

[npm-badge]: https://img.shields.io/npm/v/rnkit-pay.svg
[npm]: https://www.npmjs.com/package/rnkit-pay
[rn-badge]: https://img.shields.io/badge/react--native-v0.40-05A5D1.svg
[rn]: https://facebook.github.io/react-native
[license-badge]: https://img.shields.io/dub/l/vibe-d.svg
[license]: https://raw.githubusercontent.com/rnkit/rnkit-pay/master/LICENSE
[bithound-badge]: https://www.bithound.io/github/rnkit/rnkit-pay/badges/score.svg
[bithound]: https://www.bithound.io/github/rnkit/rnkit-pay

## Getting Started

First, `cd` to your RN project directory, and install RNMK through [rnpm](https://github.com/rnpm/rnpm) . If you don't have rnpm, you can install RNMK from npm with the command `npm i -S rnkit-pay` and link it manually (see below).

### iOS

* #### React Native < 0.29 (Using rnpm)

  `rnpm install rnkit-pay`

* #### React Native >= 0.29
  `$npm install -S rnkit-pay`

  `$react-native link rnkit-pay`

#### Manually
1. Add `node_modules/rnkit-pay/ios/RNKitPay.xcodeproj` to your xcode project, usually under the `Libraries` group
1. Add `libRNKitPay.a` (from `Products` under `RNKitPay.xcodeproj`) to build target's `Linked Frameworks and Libraries` list

### Android

* #### React Native < 0.29 (Using rnpm)

  `rnpm install rnkit-pay`

* #### React Native >= 0.29
  `$npm install -S rnkit-pay`

  `$react-native link rnkit-pay`

#### Manually
1. JDK 7+ is required
1. Add the following snippet to your `android/settings.gradle`:

  ```gradle
include ':rnkit-pay'
project(':rnkit-pay').projectDir = new File(rootProject.projectDir, '../node_modules/rnkit-pay/android/app')
  ```
  
1. Declare the dependency in your `android/app/build.gradle`
  
  ```gradle
  dependencies {
      ...
      compile project(':rnkit-pay')
  }
  ```
  
1. Import `import io.rnkit.pay.RNKitPayPackage;` and register it in your `MainActivity` (or equivalent, RN >= 0.32 MainApplication.java):

  ```java
  @Override
  protected List<ReactPackage> getPackages() {
      return Arrays.asList(
              new MainReactPackage(),
              new RNKitPayPackage()
      );
  }
  ```
1. 打开主工程的 `AndroidManifest.xml` 添加如下内容

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.RECEIVE_SMS" />
<uses-permission android:name="android.permission.READ_SMS" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>

<!-- LLYT SDK START -->
<activity
    android:name="com.yintong.secure.activity.BaseActivity"
    android:configChanges="orientation|keyboardHidden"
    android:screenOrientation="portrait"
    android:theme="@android:style/Theme.Translucent.NoTitleBar"
    android:windowSoftInputMode="adjustResize"></activity>

<service android:name="com.yintong.secure.service.PayService"></service>
<!-- LLYT SDK END -->
```

Finally, you're good to go, feel free to require `rnkit-pay` in your JS files.

Have fun! :metal:

## Basic Usage

Import library

```
import RNKitPay from 'rnkit-pay';
```

### 一、调用认证支付

```jsx
try {
  let result = await RNKitPay.pay('Verify', payInfo);
  console.log(result);
} catch (error) {
  console.log(error.message);
}
```

参数 payInfo 为服务端签名后的json字符串

## Contribution

- [@simamn](mailto:liwei0990@gmail.com) The main author.

## Questions

Feel free to [contact me](mailto:liwei0990@gmail.com) or [create an issue](https://github.com/rnkit/rnkit-pay/issues/new)

> made with ♥