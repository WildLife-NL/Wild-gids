// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wildgids/services/auth.dart';
import 'package:wildgids/views/login/verfication.dart';
import 'package:wildgids/app.dart';
import 'package:wildlife_api_connection/models/user.dart';

import 'login_test.mocks.dart';

@GenerateMocks([AuthService])
void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  Future<void> _buildVerificationView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: VerificationView(
            email: 'test@example.com', authService: mockAuthService),
      ),
    );
  }

  testWidgets('Displays verification page UI elements',
      (WidgetTester tester) async {
    await _buildVerificationView(tester);

    expect(find.text('Enter code'), findsOneWidget);
    expect(find.textContaining('An email has been sent to:'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(6));
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    expect(find.text('Did not receive a code? Send new email'), findsOneWidget);
  });

  testWidgets('Navigates focus to next input field on code input',
      (WidgetTester tester) async {
    await _buildVerificationView(tester);

    // Enter a digit in the first input box
    await tester.enterText(find.byType(TextField).first, '1');
    await tester.pumpAndSettle();

    // Check that the focus moves to the second input box
    final secondField = tester.widget<TextField>(find.byType(TextField).at(1));
    expect(secondField.focusNode!.hasFocus, isTrue);
  });

  testWidgets('Navigates to Initializer page on successful login',
      (WidgetTester tester) async {
    // Mock the authorization response
    when(mockAuthService.authorize(any, any)).thenAnswer((_) async {
      return Future.value(User(id: "1", email: "test@email.com"));
    });

    await _buildVerificationView(tester);

    for (int i = 0; i < 6; i++) {
      await tester.enterText(find.byType(TextField).at(i), '1');
    }

    // Tap on the Login button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    // Check that the Initializer page is displayed
    //expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    expect(find.byType(Initializer), findsOneWidget);
  });

  testWidgets('Shows validation error if fields are empty',
      (WidgetTester tester) async {
    await _buildVerificationView(tester);

    // Tap on the Login button without entering any input
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // No navigation should happen, remaining on the same page
    expect(find.byType(VerificationView), findsOneWidget);
  });

  testWidgets('Calls AuthService.authenticate when resend email is tapped',
      (WidgetTester tester) async {
    await _buildVerificationView(tester);

    // Tap on the resend text
    await tester.tap(find.text('Did not receive a code? Send new email'));
    await tester.pumpAndSettle();

    // Verify that AuthService.authenticate was called with the correct email
    verify(mockAuthService.authenticate('test@example.com', '')).called(1);
  });
}
