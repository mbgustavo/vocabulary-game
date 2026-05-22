# Test Guidelines

## 1. Focus on Functionality and User-Visible Behavior
- Write tests that verify what the user sees and interacts with
- Test the business logic and data flow, not implementation details
- Avoid testing specific widget types or styles unless they affect user experience
- Example: Test that a button is enabled/disabled based on state, not that it's an `ElevatedButton`

## 2. Style Testing
- Only test visual styles when they change based on widget state or user interaction
- Example: Test that a word card background color changes from gray to green when marked as completed
- Skip tests for static, unchanging styles that don't affect functionality

## 3. Widget Test Best Practices
- Use meaningful test descriptions that describe user actions and expected outcomes
- Test user interactions (taps, text input) and resulting UI changes
- Verify displayed text and data accuracy
- Use `find.byIcon()`, `find.text()`, `find.byType()` to locate elements
- Use `pumpAndSettle()` after interactions to wait for animations and rebuilds

## 4. Provider Tests
- Test state changes and side effects when providers are updated
- Verify that data flows correctly through providers to the UI
- Mock storage and external dependencies using `mocktail`

## 5. Integration Test Coverage
- Test complete user workflows (e.g., add word → view in vocabulary → play game with word)
- Verify navigation between screens
- Test feature interactions across multiple screens
