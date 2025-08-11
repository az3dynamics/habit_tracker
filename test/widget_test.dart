import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/main.dart';

void main() {
  testWidgets('Add and track a new habit', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // 1. Verify the initial state (no habits).
    expect(find.text('Learn Flutter'), findsNothing);
    expect(find.text('Coding'), findsNothing);

    // 2. Tap the '+' icon to navigate to the AddHabitScreen.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(); // Wait for the navigation to complete.

    // 3. On AddHabitScreen, enter habit details.
    await tester.enterText(find.byType(TextFormField).at(0), 'Learn Flutter');
    await tester.enterText(find.byType(TextFormField).at(1), 'Coding');

    // 4. Tap the 'Add Habit' button to submit.
    await tester.tap(find.text('Add Habit'));
    await tester.pumpAndSettle(); // Wait for the navigation to complete.

    // 5. Verify the new habit is displayed on the HomeScreen.
    expect(find.text('Learn Flutter'), findsOneWidget);
    expect(find.text('Coding'), findsOneWidget);

    // 6. Verify the initial streak is '0'.
    expect(find.text('0'), findsOneWidget);

    // 7. Tap the checkbox to complete the habit.
    await tester.tap(find.byType(Checkbox));
    await tester.pump(); // Re-render the widget.

    // 8. Verify the streak is updated to '1'.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    // 9. Tap the checkbox again to un-complete the habit.
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    // 10. Verify the streak is updated back to '0'.
    expect(find.text('1'), findsNothing);
    expect(find.text('0'), findsOneWidget);
  });
}
