import 'package:flutter_test/flutter_test.dart';
import 'package:personal_budget_calculator/main.dart';

void main() {
  testWidgets('Budget app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const BudgetApp());

    expect(find.text('Manage Your Budget'), findsOneWidget);

    expect(find.text('Calculate Budget'), findsOneWidget);
  });
}
