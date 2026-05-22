# Development Guidelines

## Adding New Features
1. Add UI components in `lib/widgets/`
2. Create new provider in `lib/providers/` if state needed
3. Add screen in `lib/screens/` if full page
4. Extend `StorageInterface` for new data types
5. Add unit and integration tests
6. Run all tests to ensure nothing breaks

## State Management Best Practices
- Use providers for all shared state
- Keep providers focused on single responsibility
- Use `ref.watch()` for reactive updates
- Use `ref.read()` for one-time reads
- Leverage Riverpod's caching automatically

## Storage Extension
1. Define new data model in `lib/models/`
2. Add methods to `StorageInterface`
3. Implement in `PrefStorage`
4. Create provider to expose storage access, or use existing one if feature is related.

## Localization Best Practices
- **Never hardcode strings** in Dart files
- Always add user-facing text to `lib/l10n/app_en.arb` (English source)
- Generate translations for other supported languages in `lib/l10n/app_xx.arb` (where xx is language code)
- Access localized strings via `AppLocalizations.of(context)!.stringKey`
- Use meaningful, descriptive key names in ARB files that reflect the string's purpose
- **After adding entries to .arb files, run** `flutter gen-l10n` to regenerate the localization dart files
- Test localization by switching app language to verify all strings display correctly

## GitHub Flow Guidelines
1. **Create New Branch for Features**
   - Create a new branch from `main` for each feature or bug fix
   - Use descriptive branch names (e.g., `feature/add-spaced-repetition`, `fix/notification-crash`)
   
2. **Descriptive Commits**
   - Write commit messages starting with an imperative verb describing what the commit does
   - Examples: "Add emoji picker to vocabulary screen", "Fix word status synchronization", "Refactor storage layer"
   - Keep messages concise but informative
   
3. **Create Pull Requests**
   - Push your branch and create a pull request on GitHub
   - Ensure all CI checks pass successfully (linting, unit tests, integration tests, builds)
   - Request review from team members if applicable
   
4. **Merge When Complete**
   - Merge the PR to `main` only after:
     - All CI/CD checks pass
     - Code review approval (if required)
     - No merge conflicts
   - Delete the feature branch after merging

## Versioning and Release Guidelines
1. **Update Version in pubspec.yaml**
   - Follow [Semantic Versioning](https://semver.org/) (MAJOR.MINOR.PATCH)
   - Increment `MAJOR` for breaking changes
   - Increment `MINOR` for new features (backward-compatible)
   - Increment `PATCH` for bug fixes (backward-compatible)
   - Example: `1.0.0` → `1.1.0` (new feature) → `1.1.1` (bug fix) → `2.0.0` (breaking change)

2. **Run Release Job**
   - Update the version in `pubspec.yaml` on the `main` branch
   - Manually trigger the `release.yml` workflow from GitHub Actions

## Testing Guidelines

For comprehensive testing guidelines and best practices, see [TEST_GUIDELINES.md](TEST_GUIDELINES.md).

This includes guidelines on focusing on functionality, style testing, widget test best practices, provider tests, and integration test coverage.
