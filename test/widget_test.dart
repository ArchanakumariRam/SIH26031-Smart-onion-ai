import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smart_onion_ai/main.dart';
import 'package:smart_onion_ai/providers/app_state_provider.dart';

void main() {
  testWidgets('Smart Onion AI App smoke test', (WidgetTester tester) async {
    final appState = AppStateProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const SmartOnionApp(),
      ),
    );

    expect(find.byType(SmartOnionApp), findsOneWidget);
  });
}
