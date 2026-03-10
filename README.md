# LockIn - Immersive Session + Reflection

LockIn is a minimal and premium immersive experience app built with Flutter. It helps users focus, relax, or sleep through curated soundscapes and post-session reflections.

## Features

- **Ambience Library**: Explore 6 unique soundscapes with search and tag filtering.
- **Immersive Player**: Calm visuals with high-quality audio loops and a session timer.
- **Post-Session Reflection**: Save your thoughts and track your mood after every session.
- **Journal History**: Revisit your past reflections locally on your device.
- **Theming**: Full support for Light/Dark modes and multiple accent colors.
- **Lifecycle Support**: Automatically pauses sessions when the app goes to the background.
- **Local Persistence**: Saves settings and journal entries using Hive.

## Tech Stack

- **Flutter & Material 3**: For a modern, responsive UI.
- **Riverpod**: Robust state management.
- **just_audio**: Stable and seamless audio playback.
- **Hive**: Fast, local NoSQL database for persistence.

## Installation & Setup

1. **Clone the repository**:
   ```bash
     git clone https://github.com/ItsAkshatSh/LockIn.git
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the app**:
   ```bash
   flutter run
   ```

## Architecture

The project follows a **Feature-First Clean Architecture**:
- `lib/features/`: Contains feature-specific logic (ambience, player, journal, settings).
- `lib/shared/`: Global themes and reusable widgets.
- Separation of concerns: Models, Repositories, Providers, and UI are clearly distributed.

