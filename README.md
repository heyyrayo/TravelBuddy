# TravelBuddy India 🚀

Your AI-powered smart travel companion for exploring India with confidence.

## Overview

TravelBuddy India is a comprehensive Flutter mobile application designed to help travelers plan, budget, and explore India. The app combines AI-powered recommendations with real-time features to provide a seamless travel planning experience.

## Key Features

### 🏠 Core Travel Features
- **Home Dashboard** - Personalized travel overview and quick actions
- **Trip Planning** - Create and manage multiple trips with detailed itineraries
- **Destination Explorer** - Browse popular destinations across India with detailed information
- **Search** - Find destinations, places, and travel tips effortlessly
- **Explore India** - Discover new places and hidden gems
- **Nearby Essentials** - Find nearby hotels, restaurants, attractions, and services

### 💡 Smart Features
- **AI Recommendations** - Get personalized travel suggestions based on your preferences
- **Travel Readiness Check** - Assess your preparation level for upcoming trips
- **Budget Management** - Track expenses and manage trip budgets
- **Real-time Connectivity** - Offline support with automatic sync when online

### 👤 User Management
- **Authentication** - Secure login/signup with Supabase
- **User Profile** - Manage personal information and travel preferences
- **Onboarding** - Smooth introduction to app features for new users
- **Settings** - Customize app behavior and preferences

### 📱 Additional Features
- **Notifications** - Stay updated with trip reminders and travel tips
- **Multi-language Support** - Support for multiple languages (via Intl)
- **Geolocation Services** - GPS-based location tracking and nearby searches
- **Image Caching** - Fast image loading with cached network images
- **Error Handling** - Graceful error management and user feedback

## Tech Stack

### Frontend
- **Framework**: Flutter (Dart)
- **Navigation**: GoRouter
- **State Management**: Provider
- **UI Design**: Material Design with Custom Themes

### Backend & Services
- **Backend**: Supabase (PostgreSQL Database + Auth)
- **Authentication**: Supabase Auth
- **Real-time Sync**: Supabase Realtime

### Libraries & Dependencies
- `google_fonts` - Premium typography
- `flutter_svg` - Vector graphics support
- `cached_network_image` - Efficient image caching
- `connectivity_plus` - Network connectivity monitoring
- `geolocator` - Geolocation services
- `shared_preferences` - Local data persistence
- `intl` - Internationalization and localization
- `material_symbols_icons` - Material Design icons

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── features/                 # Feature-specific modules
│   ├── auth/                # Authentication
│   ├── budget/              # Budget management
│   ├── destination/         # Destination information
│   ├── explore/             # Explore functionality
│   ├── home/                # Home dashboard
│   ├── nearby/              # Nearby essentials
│   ├── notifications/       # Notifications system
│   ├── onboarding/          # Onboarding flow
│   ├── profile/             # User profile
│   ├── readiness/           # Travel readiness
│   ├── recommendations/     # AI recommendations
│   ├── search/              # Search functionality
│   ├── settings/            # App settings
│   ├── trip/                # Trip planning
│   ├── splash/              # Splash screen
│   └── errors/              # Error handling
├── core/                     # Core functionality
│   ├── config/              # App configuration
│   ├── constants/           # App constants
│   ├── data/                # Repositories and data layer
│   ├── router/              # Navigation routing
│   ├── services/            # Business logic services
│   ├── state/               # Global app states
│   └── theme/               # Theme and styling
└── shared/                   # Shared components
    └── widgets/             # Reusable UI widgets
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.2.0)
- Dart SDK (>=3.2.0)
- Supabase account

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd travelbuddy_india
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   - Create a `.env` file or update `lib/core/config/supabase_config.dart` with your Supabase credentials
   - Set `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY`

4. **Run the app**
   ```bash
   flutter run
   ```

### Development

```bash
# Get dependencies
flutter pub get

# Generate launcher icons
flutter pub run flutter_launcher_icons

# Run tests
flutter test

# Build APK (Android)
flutter build apk

# Build iOS
flutter build ios
```

## Architecture

This project follows **Clean Architecture** principles with **Feature-based structure**:

- **Features**: Self-contained feature modules with presentation, domain, and data layers
- **Core**: Shared functionality including configuration, state management, and services
- **Shared**: Reusable widgets and components

## State Management

- **Global State**: Handled with Provider pattern
- **Connectivity State**: Monitors online/offline status
- **Auth State**: Manages user authentication
- **Onboarding State**: Tracks user onboarding progress

## Database

The app uses **Supabase PostgreSQL** for:
- User authentication and profiles
- Trip data and itineraries
- Destination information
- Budget records
- Notifications
Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues, bugs, or feature requests, please open an issue on the repository.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Supabase Documentation](https://supabase.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Documentation](https://pub.dev/packages/go_router)

---

Built with ❤️ for travelers exploring India
