HEAD
This is my Home Assignment for Mobile Applications subject.
1. Added logic to the buttons.
2. Added kilometer to mile converter
3. Added calculation history (Firestore)


# Flutter Calculator App

A simple calculator application built with **Flutter**.
The app supports basic arithmetic operations, saves a **calculation history to Firebase Firestore** (cloud database), and includes an additional **kilometer to mile converter screen**.

---

## Features

* Basic calculator operations:

    * Addition
    * Subtraction
    * Multiplication
    * Division
    * Percent
* Delete and clear functions
* Expression evaluation
* **ANS** button — reuse the last result in the next expression
* **Cloud history** — every result is saved to Firebase Firestore in real time
* **Per-user isolation** — each user sees only their own history (Firebase Anonymous Auth + Firestore Security Rules)
* **Kilometer → Mile converter**
* Navigation between calculator, history, and converter screens
* Clean Flutter UI

---

## Screenshots

<p align="center">
  <img src="images/app_screenshot.png" width="250">
  <img src="images/miles.png" width="250">
  <img src="images/apphistory.png" width="250">

</p>

---

## History

Every time you press `=`, the expression and its result are saved automatically to **Firebase Firestore**.

To view history, tap the **history icon** in the top-right corner of the calculator screen.

The history screen shows all past calculations in reverse chronological order (newest first). Each entry displays:
- The full expression with result (e.g. `2+2 = 4`)
- The date and time of the calculation

To delete all entries, tap the **trash icon** in the history screen and confirm.

### Cloud storage structure

```
Firestore
└── users/
    └── {userId}/
        └── history/
            └── {docId}  →  { calculation, timestamp, createdAt }
```

---

## Security

The app uses **Firebase Anonymous Authentication** — each user receives a unique UID automatically on first launch without any login required.

Firestore Security Rules ensure that every user can only read and write their own data:

```
match /users/{userId}/history/{document=**} {
  allow read, write: if request.auth != null
                     && request.auth.uid == userId;
}
```

---

## Kilometer to Mile Converter

The app also includes a separate screen that converts **kilometers to miles**.

Conversion formula used:

1 kilometer = **0.621371 miles**

Users can navigate to the converter from the calculator screen and return back easily.

---

## Technologies Used

* Flutter / Dart
* `math_expressions` — expression parsing and evaluation
* `firebase_core` — Firebase initialization
* `cloud_firestore` — cloud database for history storage
* `firebase_auth` — anonymous authentication for user isolation

---

## Installation

Clone the repository:

```bash
git clone https://github.com/GomeZko/flutter-calculator.git
```

Go to the project folder:

```bash
cd flutter-calculator
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

> **Note:** Firebase configuration (`lib/firebase_options.dart`) is required. Set up your own Firebase project at [console.firebase.google.com](https://console.firebase.google.com) and run `flutterfire configure`.

---

## Author

Aleksandr Gomzin

