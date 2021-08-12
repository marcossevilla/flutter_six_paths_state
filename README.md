# Flutter's Six Paths of State

[![platform: flutter][flutter_badge_link]][flutter_link]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

A simple account managing app using...

1. Bloc
2. GetX
3. Redux
4. setState
5. Provider + MobX
6. Provider + ChangeNotifier

Watch the full [talk][six_paths_state_talk] on YouTube (in Spanish).

## State Managers

| Approaches                    | Supported | TBD   | Not recommended | Seal of approval |
| ----------------------------- | --------- | ----- | --------------- | ---------------- |
| Bloc                          |    ✅      |      |                 |        ⭐️         |
| GetX                          |    ✅      |      |       ⚠️         |                  |
| Redux                         |    ✅      |      |       ⚠️         |                  |
| setState                      |    ✅      |      |       ⚠️         |                  |
| Provider + MobX               |    ✅      |      |                  |                  |
| Provider + ChangeNotifier     |    ✅      |      |       ⚠️         |                  |
| Provider + StateNotifier      |            |  🔨  |                  |        ⭐️        |
| Riverpod + StateNotifier      |            |  🔨  |                  |        ⭐️        |
| Riverbloc (Riverpod + Bloc)   |            |  🔨  |                  |        ⭐️        |

## Flutter

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app][first_flutter_app_codelab]
- [Cookbook: Useful Flutter samples][flutter_samples_cookbook]

For help getting started with Flutter, view the
[online documentation][flutter_docs_link], which offers tutorials,
samples, guidance on mobile development, and a full API reference.


[first_flutter_app_codelab]: https://flutter.dev/docs/get-started/codelab
[flutter_badge_link]: https://img.shields.io/badge/platform-flutter-blue.svg
[flutter_docs_link]: https://flutter.dev/docs
[flutter_link]: https://flutter.dev/
[flutter_samples_cookbook]: https://flutter.dev/docs/cookbook
[six_paths_state_talk]: https://www.youtube.com/watch?v=2vuN03XXfcw
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis