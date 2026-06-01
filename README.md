# FlickPay

FlickPay is a Flutter reward reveal screen with a dark money-themed interface, animated wallet badge, confetti, and progressive action buttons.

## State Management

The app currently uses Flutter's built-in local state:

- `StatefulWidget`
- `setState`
- `Timer`
- `AnimationController`

No external state management package is needed yet because the current state is only used inside one screen for UI animations and reveal timing. A package like Riverpod, Bloc, Provider, or GetX would make more sense later when the app has shared state such as login, wallet balance, transactions, API loading states, or multi-screen payment flows.

## App Icon And Splash

Custom FlickPay app icon and splash assets can be generated from:

```sh
python3 tools/generate_brand_assets.py
```

The generated assets replace the default Flutter logo across Android, iOS, web, macOS, and Windows.

## Run

```sh
flutter pub get
flutter run
```

## Check

```sh
flutter analyze
flutter test
```
