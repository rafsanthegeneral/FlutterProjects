
![Flutter All Project ](https://cdn.prod.website-files.com/5f841209f4e71b2d70034471/60bb4a2e143f632da3e56aea_Flutter%20app%20development%20(2).png)

# My Flutter Projects

This is my all Flutter project. You can install Flutter on your Windows or Linux systems as follows:

## Installation Instructions

<style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            padding: 20px;
        }
        h1 {
            color: #0078D7;
        }
        .container {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
        }
        .link {
            display: inline-block;
            margin: 10px 0;
            padding: 10px 15px;
            background-color: #0078D7;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .link:hover {
            background-color: #0056A0;
        }
        #instructions {
            display: none;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<h1>Windows</h1>

<div class="container">
    <p>If you are using Windows, download the following for Java environment setup:</p>
    <a class="link" href="https://download.oracle.com/java/20/archive/jdk-20.0.2_windows-x64_bin.exe" target="_blank">Download Java Version 20</a>
    <a class="link" href="https://www.oracle.com/java/technologies/javase/javase8u211-later-archive-downloads.html#license-lightbox" target="_blank">Download Java 8u211 (Account Required)</a>
    <button onclick="toggleInstructions()">Show Installation Instructions</button>
    <div id="instructions">
        <h2>Installation Instructions</h2>
        <ol>
            <li>Download the Java installer from the links above.</li>
            <li>Run the installer and follow the on-screen instructions.</li>
            <li>Set up your environment variables if necessary.</li>
        </ol>
    </div>
</div>

<script>
    function toggleInstructions() {
        const instructions = document.getElementById('instructions');
        instructions.style.display = instructions.style.display === 'none' ? 'block' : 'none';
    }
</script>


If you are using Windows, download the following for Java environment setup:

- [Java Version 20](https://download.oracle.com/java/20/archive/jdk-20.0.2_windows-x64_bin.exe)
- [Java 8u211](https://www.oracle.com/java/technologies/javase/javase8u211-later-archive-downloads.html#license-lightbox) (You must create an account to download this version)

After Setup Java environment,Time to setup your flutter 
Download Futter SDK 

-[Flutter SDK](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.3-stable.zip)

 (Or search letest Flutter Version from (There)[https://docs.flutter.dev/get-started/install/windows/mobile])

Then downloads Command line tools frome 

- [Windows Command Line Tools](https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip)
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
<h3>Update Sdkmanager if need </h3>

```
sdkmanager --update
```

### Linux

