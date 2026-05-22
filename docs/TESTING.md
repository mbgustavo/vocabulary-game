
# Testing Strategy

## Unit & Widget Tests (`test/`)
Directory structure mirrors `lib/`:
```
test/
├── helpers/              # Test utilities and mocks
├── providers/            # Provider logic tests
├── screens/              # Screen/page tests
├── serializers/          # Data serialization tests
└── widgets/              # Widget rendering tests
```

**Testing Tools:**
- `flutter_test` - Framework for widget/unit tests
- `mocktail` - Mocking library for Dart

## Integration Tests (`integration_test/`)
End-to-end testing of complete user workflows, currently set for linux device, aiming to evolve it to test on Android emulator. 

**Files:**
- `app_test.dart` - Main app flow and feature testing
- `initialize_test.dart` - App initialization testing
- `mocks.dart` - Mock implementations for testing
- `test_prefs_helper.dart` - Helpers for setting data in Shared Preferences for test

**Coverage:**
- User onboarding flows
- Game play mechanics
- Word management (add, edit, delete)
- Language managing (add, edit, delete, switch)
- Notification triggers

## Test Driver (`test_driver/`)
- `integration_test.dart` - Driver configuration for integration tests
- Enables automated testing on physical devices/emulators

---

# Testing Guidelines

For detailed testing guidelines, see [TEST_GUIDELINES.md](TEST_GUIDELINES.md).

---

# Troubleshooting Tests

## Tests Failing?
- Check mocks in `test_prefs_helper.dart` and `mocks.dart`
- Verify test setup/teardown properly cleans state
- Use `pumpAndSettle()` to wait for animations in widget tests
