# Movix

A modern Flutter app for discovering movies & TV shows — trending titles, search, genre-based discovery, rich detail pages, and a personal library of favorites, watchlist, watched history, and ratings.

Built with **Clean Architecture** and **Bloc/Cubit**, backed by the **TMDB API** for content and **Supabase** for authentication and user data.

---

## Features

- **Discover** — trending, popular, top rated, upcoming, and now-playing carousels on Home; genre grid + advanced filters (genre, year, rating, sort) on Discover
- **Search** — debounced multi-search across movies & TV, with an All/Movies/TV filter and locally stored recent searches
- **Details** — movie & TV detail pages with cast, trailers (YouTube), similar/recommended titles, season & episode browsing, cast → person detail pages, and "Where to Watch" streaming providers by region
- **My Library** — favorites, watchlist, watched history, and star ratings, synced to Supabase
- **Auth** — Google Sign-In only, via native ID-token flow (no browser redirect)
- **Settings** — light/dark theme, region preference, editable display name

## 🛠 Tech Stack

| Category | Package |
|---|---|
| State management | `flutter_bloc` |
| Networking | `dio` |
| Backend | `supabase_flutter` |
| Functional error handling | `dartz` |
| Dependency injection | `get_it` |
| Routing | `go_router` |
| Auth | `google_sign_in` (native ID-token flow) |
| Images | `cached_network_image`, `shimmer` |
| Video | `youtube_player_flutter` |
| Env config | `flutter_dotenv` |
| Icons | `font_awesome_flutter` |

## Getting Started

### 1. Clone & install

```bash
git clone https://github.com/bavlysafwatt/movix
cd movix
flutter pub get
```

### 2. Environment variables

Create a `.env` file in the project root:

```
TMDB_READ_ACCESS_TOKEN=your_tmdb_v4_read_access_token
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key
GOOGLE_WEB_CLIENT_ID=your_web_client_id.apps.googleusercontent.com
GOOGLE_IOS_CLIENT_ID=your_ios_client_id.apps.googleusercontent.com
```

> `.env` is gitignored — never commit real keys.

### 3. Run

```bash
flutter run
```

## Project Structure

```
lib/
├── core/                  # shared API client, theming, widgets, utils
├── dependency_injection.dart
├── main.dart
└── features/
    ├── splash/
    ├── onboarding/
    ├── auth/
    ├── home/
    ├── search/
    ├── discover/
    ├── details/           # movie, tv, person, season detail pages
    ├── library/            # favorites, watchlist, watched, ratings
    └── settings/
```
