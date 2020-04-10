# Finesse Nation
[![Finesse Nation CI/CD](https://github.com/Periphery428/Finesse-Nation/workflows/Finesse%20Nation%20CI%2FCD/badge.svg)](https://github.com/Periphery428/Finesse-Nation/actions)

There are free meals and giveaways on campus all the time. Finesse Nation is an app that would allow users to share where the free items are located on campus.

Website: https://periphery428.github.io/Finesse-Nation

Developed in Android Studio using the Flutter framework

## Instructions to Edit and Run
Download Flutter here https://flutter.dev/docs/get-started/install

```git clone https://github.com/Periphery428/Finesse-Nation.git```

Open the project in Android Studio

Launch AVD manager and setup and run an emulator (We used pixel 2 most of the time)



### Setup Token

You must set the environment variable ```FINESSE_NATION_TOKEN``` with the secret token.

You must run the file tool/env.dart. This will then generate the file, .env.dart into the lib folder, needed to successfully use the token.

### Setup Google Services
You must have the Google Service file into the Finesse Nation/android/app for the app to run.


## Running Tests

Run Unit Tests
```
flutter test
```

Run Integration Tests
```
flutter drive --target=target_driver/app.dart
```