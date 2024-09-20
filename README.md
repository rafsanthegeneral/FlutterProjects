
![Flutter All Project ](https://cdn.prod.website-files.com/5f841209f4e71b2d70034471/60bb4a2e143f632da3e56aea_Flutter%20app%20development%20(2).png)

# My Flutter Projects

This is my all Flutter project. You can install Flutter on your Windows or Linux systems as follows:

<h1>Windows</h1>

## Installation Instructions

If you are using Windows, download the following for Java environment setup:

- [Java Version 20](https://download.oracle.com/java/20/archive/jdk-20.0.2_windows-x64_bin.exe)
- [Java 8u211](https://www.oracle.com/java/technologies/javase/javase8u211-later-archive-downloads.html#license-lightbox) (You must create an account to download this version)

After Setup Java environment,Time to setup your flutter 
Download Futter SDK 

-[Flutter SDK](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.3-stable.zip)

 (Or search letest Flutter Version from (There)[https://docs.flutter.dev/get-started/install/windows/mobile])

Then downloads Command line tools frome 

- [Linux Command Line Tools](https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip)
- [ALl Version Command Line tools ](https://developer.android.com/studio)

Thats all . Now setup all in your windows Environment (Flutter SDK  & sdkmanager tools From commandlinetools ) Variable and use Throw Command line . if you need help go search some youtube tutorial about how can setup those things.

Then you have to Download some tools using sdkmanager.
<h3>Download  Platfrom tools using sdkmanager </h3>

```
sdkmanager --install "platform-tools" "build-tools;30.0.3" 
```
<h3>Accept Licence </h3>

```
sdkmanager --licenses
```

Then Link adb.exe from platfrom-tools folder inside sdkmanager folder to Environment Variable. (That will Nesessary if you using your Phone as a Emulator via adb )

<h1>Linux</h1>

## Installation Instructions

If you are using Linux, download the following for Java environment setup:
```
sudo apt install  openjdk-21-jdk openjdk-8-jre  
```
Then downloads Command line tools frome 

- [Windows Command Line Tools](https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip)

Then Setup Environment Variable for SDK manager 
```
mouepad ~/.bashrc 
```
Then where  You Download sdkmanager there bin folder include that open file 

```
export PATH=$PATH:/pathToCmdlineTools/tools/bin/
```

<h3>Download  Platfrom tools using sdkmanager </h3>

```
sdkmanager --install "platform-tools" "build-tools;30.0.3" 
```
<h3>Accept Licence </h3>

```
sdkmanager --licenses
```

