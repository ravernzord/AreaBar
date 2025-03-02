import 'package:flutter_test/flutter_test.dart';
import 'package:areabaa/main.dart'; // Ensure this path matches the actual structure of your project

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const AreabaaApp());

    // Example test: Check if a widget with the text 'Areabaa' is present.
    // Adjust or remove this expectation based on your actual UI.
    expect(find.text('Areabaa'), findsOneWidget);
  });
}
