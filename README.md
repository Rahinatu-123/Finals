# CTech - Your Tech Career Companion

CTech is a comprehensive Flutter application designed to help users explore and navigate their tech career journey. The app provides career guidance, tech vocabulary learning, and a platform for sharing success stories in the tech industry.

## Features

### 1. Authentication
- Secure user authentication using Firebase Auth
- Email and password sign-in/sign-up
- Password reset functionality with OTP verification
- Persistent login state management
- Beautiful splash screen with smooth transitions

### 2. User Profile Management
- Customizable user profiles
- Update display name and profile picture
- View and edit personal information
- Track activity and contributions

### 3. Career Exploration
- Browse various tech career paths
- Detailed career profiles with requirements and skills
- Career recommendations based on interests
- Interactive career exploration interface

### 4. Tech Words
- Learn essential tech vocabulary
- Contribute new tech terms
- Track learning progress
- Community-driven content

### 5. Success Stories
- Read inspiring tech success stories
- Share personal experiences
- Connect with community members
- Like and interact with stories

### 6. Career Quiz
- Assess career interests
- Get personalized recommendations
- Track quiz history
- Regular updates with new questions

## Technical Stack

### Frontend
- Flutter for cross-platform development
- Provider for state management
- Custom UI components and animations
- Responsive design for various screen sizes

### Backend
- Firebase Authentication for user management
- Cloud Firestore for data storage
- Firebase Storage for media files
- Real-time data synchronization

### Key Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^latest_version
  firebase_auth: ^latest_version
  cloud_firestore: ^latest_version
  provider: ^latest_version
  shared_preferences: ^latest_version
```

## Project Structure

```
lib/
├── main.dart
├── models/
│   ├── user.dart
│   ├── career.dart
│   └── career_profile.dart
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   ├── careers_screen.dart
│   └── ...
├── services/
│   ├── auth.dart
│   └── api_service.dart
└── widgets/
    └── custom_button.dart
```

## Getting Started

1. Clone the repository
```bash
git clone https://github.com/yourusername/ctech.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
- Create a new Firebase project
- Add your Firebase configuration files
- Enable Authentication and Firestore

4. Run the app
```bash
flutter run
```

## Contributing

We welcome contributions to CTech! Please read our contributing guidelines before submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For any queries or support, please contact us at support@ctech.com

