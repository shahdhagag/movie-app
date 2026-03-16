# Movie App

A Flutter movie application built with Clean Architecture principles.

## Project Structure

This project follows Clean Architecture with the following structure:

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

## Dependencies

- **State Management**: flutter_bloc, equatable
- **Networking**: dio
- **Dependency Injection**: get_it, injectable
- **Functional Programming**: dartz
- **Image Caching**: cached_network_image
- **Local Storage**: shared_preferences
- **Responsive UI**: flutter_screenutil

## Getting Started

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

## Architecture

This app follows Clean Architecture principles with three main layers:

- **Presentation Layer**: UI components, screens, and state management
- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: Data sources, repositories, and models

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


screenshots 


## 📱 Screenshots

### 🏠 Home & Browse

<p align="center">
  <img src="https://github.com/user-attachments/assets/c7b8a567-e85b-4acc-bf8a-078ffc953e14" width="220"/>
  <img src="https://github.com/user-attachments/assets/93996a65-44a9-4989-a27f-dd04e10ca7a7" width="220"/>
  <img src="https://github.com/user-attachments/assets/9c0cab32-867e-4538-a352-c3e8ee2c591a" width="220"/>
  <img src="https://github.com/user-attachments/assets/5839cc51-e282-4714-a566-75d9e9b2bb97" width="220"/>
</p>

---

### 🛍️ Product & Details

<p align="center">
  <img src="https://github.com/user-attachments/assets/c28c2026-c1f4-41bf-8d6d-0f8be4599cd6" width="220"/>
  <img src="https://github.com/user-attachments/assets/cdec0e3f-3398-4964-9bfd-5f20268399cf" width="220"/>
  <img src="https://github.com/user-attachments/assets/9df40a18-e596-448a-96ec-60f9303cd2eb" width="220"/>
  <img src="https://github.com/user-attachments/assets/9b38437c-3552-4090-a0a4-b35c473254a6" width="220"/>
</p>

---

### 🧾 Cart & Checkout

<p align="center">
  <img src="https://github.com/user-attachments/assets/83b5ca76-69d8-4f86-852a-083e6983fc9d" width="220"/>
  <img src="https://github.com/user-attachments/assets/e55acb51-b375-4dfd-8df1-df602d86a89c" width="220"/>
</p>


