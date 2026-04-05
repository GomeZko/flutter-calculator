HEAD
This is my Home Assignment for Mobile Applications subject.
1. Added logic to the buttons.
2. Added kilometer to mile converter
3. Added calculation history (SQLite)


# Flutter Calculator App

A simple calculator application built with **Flutter**.
The app supports basic arithmetic operations, saves a **calculation history** to a local database, and includes an additional **kilometer to mile converter screen**.

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
* **Calculation history** — every result is saved to a local SQLite database
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

Every time you press `=`, the expression and its result are saved automatically.

To view history, tap the **history icon** (🕐) in the top-right corner of the calculator screen.

The history screen shows all past calculations in reverse chronological order (newest first). Each entry displays:
- The full expression with result (e.g. `2+2 = 4`)
- The date and time of the calculation

To delete all entries, tap the **trash icon** in the history screen and confirm.

---

## Kilometer to Mile Converter

The app also includes a separate screen that converts **kilometers to miles**.

Conversion formula used:

1 kilometer = **0.621371 miles**

Users can navigate to the converter from the calculator screen and return back easily.

---

## Technologies Used

* Flutter
* Dart
* `math_expressions` — expression parsing and evaluation
* `sqflite` — local SQLite database for history storage
* `path` — file path utilities

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

---

## Author

Aleksandr

