
# 🎬 Movie App

**Movie App** is a Flutter-based mobile application built with **Clean Architecture** principles.
It allows users to browse, search, and view detailed information about movies while providing authentication, profile management, and a smooth responsive UI.

**Demo / Screen Recording:**
[Watch the Movie App Demo](https://drive.google.com/file/d/1yVCqPI3b4lf6MdrfZtAK2vGY3k4uouX7/view?usp=sharing)

---

## 📦 Project Structure

```
lib/
├── core/
│   ├── api/          # API configuration and base classes
│   ├── errors/       # Error handling classes
│   ├── utils/        # Utility functions and helpers
│   └── widgets/      # Shared/reusable widgets
├── config/
│   ├── routes/       # App routing configuration
│   └── theme/        # App theme configuration
└── features/
    ├── auth/         # Authentication feature
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── home/         # Home screen feature
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── movie_details/ # Movie details feature
    ├── search/        # Search feature
    └── profile/       # User profile feature
```

---

## ⚙️ Technologies & Dependencies

* **Flutter & Dart**: Mobile framework and language
* **State Management**: `flutter_bloc`, `bloc`, `equatable`
* **Networking**: `dio`, `pretty_dio_logger`
* **Dependency Injection**: `get_it`, `injectable`
* **Functional Programming**: `dartz`
* **Image Caching**: `cached_network_image`
* **Local Storage**: `shared_preferences`
* **Routing**: `go_router`
* **UI & Design**: `flutter_screenutil`, `gap`, `google_fonts`, `skeletonizer`, `carousel_slider`
* **Firebase**: `firebase_core`, `firebase_auth`, `cloud_firestore`, `google_sign_in`
* **Splash Screen**: `flutter_native_splash`

**Dev Dependencies**: `flutter_test`, `flutter_lints`, `injectable_generator`, `build_runner`

---

## 🚀 Features

* User authentication: Login, Register, Password Reset
* Browse popular and trending movies
* Search movies by title
* Detailed movie view (description, rating, cast, etc.)
* Profile management and update profile
* Responsive design for different screen sizes
* Image caching for better performance
* Firebase integration for auth and database
* Smooth navigation with routing and state management

---

## 🏛 Architecture

This app follows **Clean Architecture** principles:

* **Presentation Layer**: Screens, widgets, and state management
* **Domain Layer**: Business logic and entities
* **Data Layer**: Repositories, models, and API/data sources

---

## 📱 Screenshots

### 🏠 Home & Browse

<p align="center">
  <img src="assets/screenshots/home1.png" alt="Home 1" width="200"/>
  <img src="assets/screenshots/home2.png" alt="Home 2" width="200"/>
  <img src="assets/screenshots/home3.png" alt="Home 3" width="200"/>
  <img src="assets/screenshots/browsescreen.png" alt="Browse Screen" width="200"/>
</p>

### 🎥 Movie Details

<p align="center">
  <img src="assets/screenshots/home_detailes3.png" alt="Home Details 3" width="200"/>
  <img src="assets/screenshots/homedetailes2.png" alt="Home Details 2" width="200"/>
  <img src="assets/screenshots/movie_Detailes1.png" alt="Movie Details 1" width="200"/>
</p>

### 🔎 Search

<p align="center">
  <img src="assets/screenshots/searchscreen.png" alt="Search Screen" width="200"/>
</p>

### 👤 Profile & Authentication

<p align="center">
  <img src="assets/screenshots/profilescreen1.png" alt="Profile Screen 1" width="200"/>
  <img src="assets/screenshots/updateProfileScreen.png" alt="Update Profile" width="200"/>
  <img src="assets/screenshots/register.png" alt="Register Screen" width="200"/>
  <img src="assets/screenshots/login.png" alt="Login Screen" width="200"/>
  <img src="assets/screenshots/restPassword.png" alt="Reset Password" width="200"/>
</p>

---

