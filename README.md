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
