

import 'package:flutter_test/flutter_test.dart';

import 'package:petcare/main.dart';

void main() {
  testWidgets('PetCare app loads and shows visible content', (WidgetTester tester) async {
    await tester.pumpWidget(const PetCareApp());

    expect(find.text('Pet Care Directory'), findsOneWidget);
    expect(find.text('Campus Pet Care'), findsOneWidget);
    expect(find.text('Harvey'), findsOneWidget);
  });
}
