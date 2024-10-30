// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wildgids/services/auth.dart';
import 'package:wildgids/views/login/login.dart';
import 'package:wildgids/views/login/verfication.dart';

import 'login_test.mocks.dart';

@GenerateMocks([AuthService])
void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  Future<void> _buildLoginView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginView(authService: mockAuthService),
      ),
    );
  }

  testWidgets('Displays LoginView with email input and Send code button',
      (WidgetTester tester) async {
    await _buildLoginView(tester);

    // Check for the main widgets in LoginView
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Enter your email to login'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.widgetWithText(MaterialButton, 'Send code'), findsOneWidget);
  });

  testWidgets('Validates email field - empty and invalid email',
      (WidgetTester tester) async {
    await _buildLoginView(tester);

    // Test for empty email
    await tester.tap(find.widgetWithText(MaterialButton, 'Send code'));
    await tester.pumpAndSettle();

    expect(find.text('Field cannot be empty.'), findsOneWidget);

    // Test for invalid email format
    await tester.enterText(find.byType(TextFormField), 'invalidemail');
    await tester.tap(find.widgetWithText(MaterialButton, 'Send code'));
    await tester.pumpAndSettle();

    expect(find.text('Give a valid email address.'), findsOneWidget);
  });

  testWidgets(
      'Calls AuthService.authenticate and navigates to VerificationView on valid email',
      (WidgetTester tester) async {
    const validEmail = 'test@example.com';

    // Mock the authenticate method to complete without errors
    when(mockAuthService.authenticate(any, any)).thenAnswer((_) async => {});

    await _buildLoginView(tester);

    // Enter a valid email
    await tester.enterText(find.byType(TextFormField), validEmail);
    await tester.tap(find.widgetWithText(MaterialButton, 'Send code'));

    // Trigger validation and navigation
    await tester.pumpAndSettle();

    // Check that AuthService.authenticate was called with the correct email
    verify(mockAuthService.authenticate(validEmail, "")).called(1);

    // Check that VerificationView is displayed
    expect(find.byType(VerificationView), findsOneWidget);
  });

  testWidgets('Does not navigate to VerificationView if email is invalid',
      (WidgetTester tester) async {
    const invalidEmail = 'invalidemail';

    await _buildLoginView(tester);

    // Enter an invalid email
    await tester.enterText(find.byType(TextFormField), invalidEmail);
    await tester.tap(find.widgetWithText(MaterialButton, 'Send code'));

    // Allow the widget to rebuild
    await tester.pumpAndSettle();

    // Check that VerificationView is not displayed
    expect(find.byType(VerificationView), findsNothing);
  });
}
