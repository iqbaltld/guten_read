# 📚 Gutenberg Character Analyzer

A Flutter application that downloads books from Project Gutenberg and uses AI to analyze character relationships and interactions.

## 🌟 Features

- **Book Download**: Fetch any public domain book from Project Gutenberg using its ID
- **AI-Powered Analysis**: Utilizes AI to analyze character relationships and interactions
- **Interactive Visualization**: View character networks and interaction graphs
- **Responsive Design**: Works on both mobile and web platforms
- **Error Handling**: Comprehensive error handling with user-friendly messages

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (compatible with your Flutter version)
- Groq API key (for AI analysis)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/guten_read.git
   cd guten_read
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Configure your Groq API key:

   - Open `lib/core/constants/app_constants.dart`
   - Set your Groq API key: `static const String groqApiKey = 'YOUR_GROQ_API_KEY';`

4. Run the app:
   ```bash
   flutter run -d chrome  # For web
   # or
   flutter run           # For connected device/emulator
   ```

## 🏗 Project Structure

```
lib/
├── core/
│   ├── constants/     # App-wide constants
│   ├── error/         # Error handling and exceptions
│   ├── network/       # Network layer (API clients, interceptors)
│   ├── routes/        # App routing
│   └── utils/         # Utility functions and helpers
│
├── features/
│   └── book_analyzer/ # Book analysis feature
│       ├── data/      # Data layer
│       │   ├── datasources/  # Data sources (API, local)
│       │   ├── models/       # Data models
│       │   └── repositories/ # Repository implementations
│       ├── domain/    # Domain layer
│       │   ├── entities/    # Business objects
│       │   ├── repositories/# Repository interfaces
│       │   └── usecases/    # Business logic
│       └── presentation/    # UI layer
│           ├── cubit/       # State management
│           └── screens/     # UI screens
│
└── injection_container.dart # Dependency injection setup
```

## 🛠 Dependencies

- **State Management**: `flutter_bloc`
- **Dependency Injection**: `get_it`, `injectable`
- **Networking**: `dio`
- **Functional Programming**: `dartz`
- **UI**: `flutter_screenutil`
- **AI Integration**: Groq API

## 🤖 How It Works

1. **Book Download**: The app fetches the full text of a book from Project Gutenberg using the provided book ID.
2. **Text Processing**: The book content is processed to prepare for analysis.
3. **AI Analysis**: The text is sent to the Groq AI service which analyzes character relationships.
4. **Visualization**: The results are displayed as an interactive character network graph and detailed character list.

## 📝 Usage

1. Enter a Project Gutenberg book ID (e.g., `1342` for _Pride and Prejudice_)
2. Tap "Analyze" to download and process the book
3. View the character network and interaction details
4. Explore character relationships and interaction frequencies

## 📱 Screenshots

_Screenshots will be added here_

## 🙏 Acknowledgments

- Project Gutenberg for providing free public domain books
- Groq for AI inference capabilities
- Flutter for the amazing cross-platform framework
