# Flutter Picsum App

A Flutter application with enhanced login functionality and photo gallery using the Picsum API.

## Features

### 🔐 Enhanced Login Screen
- **Email Validation**: Must match valid email regex pattern
- **Advanced Password Validation**:
  - Minimum 8 characters
  - At least one uppercase letter (A-Z)
  - At least one lowercase letter (a-z)
  - At least one numeric digit (0-9)
  - At least one special character (!@#$%^&*(),.?":{}|<>)
- **Password Visibility Toggle**: Show/hide password functionality
- **Real-time Validation**: AutovalidateMode.onUserInteraction
- **Password Criteria Helper**: Visual indicators for password requirements
- **Error Handling**: SnackBar notifications for login failures

### 🏠 Photo Gallery
- **Data Source**: Fetches 10 images from `https://picsum.photos/v2/list?limit=10`
- **Layout**: ListView.separated with 12px horizontal and vertical padding
- **Image Display**:
  - Width = screen width minus padding
  - Height = dynamically calculated from API aspect ratio
  - 12px rounded corners
  - Loading indicator while loading
  - Broken image icon on load failure
- **Content**:
  - Title: Author name in Montserrat Semi-Bold, dark text
  - Description: "Photo #<id> — <url>" format in Montserrat Regular, dark grey
  - Max 2 lines with ellipsis overflow
- **Navigation**: Uses named routes with pushReplacementNamed
- **Pull-to-refresh functionality**
- **Error handling for API requests**

## Getting Started

### Prerequisites
- Flutter 3.x
- Dart >=3.0

### Installation

1. **Clone or download the project**

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## Testing the Login

To test the login functionality, use credentials that meet all validation requirements:

### Valid Test Credentials:
- **Email**: `test@example.com` (or any valid email format)
- **Password**: `Password123!` (meets all criteria)

### Password Requirements:
- ✅ At least 8 characters
- ✅ One uppercase letter (A-Z)
- ✅ One lowercase letter (a-z)  
- ✅ One numeric digit (0-9)
- ✅ One special character (!@#$%^&*)

The app will show real-time validation feedback and visual indicators for password requirements.

## Architecture

- **State Management**: flutter_bloc with equatable
- **HTTP Client**: http package for API requests
- **Fonts**: google_fonts (Montserrat)
- **Repository Pattern**: Clean separation of data layer
- **BLoC Pattern**: Reactive state management

## Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  google_fonts: ^6.1.0
  http: ^1.1.0
```
