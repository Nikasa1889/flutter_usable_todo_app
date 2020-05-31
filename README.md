# (Re)usable Todo App

A simple flutter app with simple reusable building blocks.
I also try to make the todo app itself as production-ready as possible, so that it works as a
proof of concepts for their building blocks.

## Features

- [x] Customizable [Material Components](https://flutter.dev/docs/development/ui/widgets/material) with ThemeData.
- [x] Login Page.
- [x] Input Validators
- [x] Authentication with Firebase Auth.
- [x] Auto-sync data service with Firebase Realtime Database.
- [x] Notification center with Flushbar.
- [ ] Injectable Configuration with Firebase Remote Config.
- [x] Reorderable and Dismissable TodoList.
- [ ] Unit-tests and Integration-tests.

## Getting Started
Because the app uses Firebase exclusively for backend services, you need to configure the app to
connect to your Firebase service. That includes:

  - Change the **app-id** to your own unique app-id.
    + You can do search and replace all "me.danghien.usabletodoapp" with your app-id
  - Register the new app with **Firebase**.
    + Follow the official instruction here for [android](https://firebase.google.com/docs/flutter/setup?platform=android) or [ios](https://firebase.google.com/docs/flutter/setup?platform=ios).
  - Enable **Firebase Sign-in** method.
    + Go to Firebase Console > Authentication.
    + Enable Email/Password and Anonymous
  - Prepare **Firebase Realtime Database**
    + Go to Firebase Console > Database > Start
    + Select "Realtime Database" > Add the following rules:
    ```
     {
       "rules": {
         "users": {
           "$uid": {
                 ".read": "$uid === auth.uid",
                 ".write": "$uid === auth.uid"
           }
         }
       }
     }
    ```