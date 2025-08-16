import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/screens/home_screen.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:habit_tracker/services/auth_service.dart';
import 'package:habit_tracker/services/database_service.dart';
import 'package:provider/provider.dart';

void main() {
  Future<void> pumpWidgetWithProviders(WidgetTester tester, Widget widget) async {
    final mockAuth = MockFirebaseAuth(signedIn: true);
    final fakeFirestore = FakeFirebaseFirestore();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(firebaseAuth: mockAuth),
          ),
          Provider<DatabaseService>(
            create: (_) =>
                DatabaseService(firestore: fakeFirestore, firebaseAuth: mockAuth),
          ),
        ],
        child: MaterialApp(
          home: widget,
        ),
      ),
    );
  }

  testWidgets('Add and track a new habit', (WidgetTester tester) async {
    await pumpWidgetWithProviders(tester, const HomeScreen());
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
    await pumpWidgetWithProviders(tester, const HomeScreen());

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
    await pumpWidgetWithProviders(tester, const HomeScreen());

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
