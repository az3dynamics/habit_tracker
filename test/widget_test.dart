import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/main.dart';

void main() {
  testWidgets('Add and track a new habit', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Learn Flutter'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Learn Flutter');
    await tester.enterText(find.byType(TextFormField).at(1), 'Coding');
    await tester.tap(find.text('Add Habit'));
    await tester.pumpAndSettle();

    expect(find.text('Learn Flutter'), findsOneWidget);
    expect(find.text('Coding'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    expect(find.text('1'), findsNothing);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Edit an existing habit', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Initial Name');
    await tester.enterText(find.byType(TextFormField).at(1), 'Initial Theme');
    await tester.tap(find.text('Add Habit'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Initial Name'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Habit'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Updated Name');
    await tester.enterText(find.byType(TextFormField).at(1), 'Updated Theme');

    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    expect(find.text('Initial Name'), findsNothing);
    expect(find.text('Updated Name'), findsOneWidget);
    expect(find.text('Updated Theme'), findsOneWidget);
  });

  testWidgets('Delete a habit by swiping', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Habit to Delete');
    await tester.enterText(find.byType(TextFormField).at(1), 'Some Theme');
    await tester.tap(find.text('Add Habit'));
    await tester.pumpAndSettle();

    expect(find.text('Habit to Delete'), findsOneWidget);

    await tester.drag(find.byType(Dismissible), const Offset(-500.0, 0.0));
    await tester.pumpAndSettle();

    expect(find.text('Habit to Delete'), findsNothing);
  });
}
