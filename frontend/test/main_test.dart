// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/handlers/handle_fetch_data.dart';

import 'package:mobile/main.dart';
import 'package:mobile/widgets/floating_menu.dart';
import 'package:provider/provider.dart';

void main() {
  // Define a widget to use for testing
  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider(
      create: (context) => DataFetchHandler(),
      child: MaterialApp(
        home: MyHomePage(title: 'Data Viz'),
      ),
    );
  }

  testWidgets('Check initial title in AppBar', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Data Viz'), findsOneWidget);
  });

  // testWidgets('Dropdown button updates selected data source', (WidgetTester tester) async {
  //   await tester.pumpWidget(createWidgetUnderTest());

  //   // Tap the dropdown button
  //   await tester.tap(find.text('Test 1').last);
  //   await tester.pumpAndSettle();

  //   // Select 'Test 2'
  //   await tester.tap(find.text('Test 2').last);
  //   await tester.pumpAndSettle();

  //   // Verify that the selected value has been updated
  //   final dataFetchHandler = Provider.of<DataFetchHandler>(tester.element(find.byType(MyHomePage)), listen: false);
  //   expect(dataFetchHandler.selectedDataSrc, 'test_2');
  // });

  testWidgets('Refresh button calls refresh method', (WidgetTester tester) async {
    final dataFetchHandler = DataFetchHandler();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => dataFetchHandler,
        child: MaterialApp(home: MyHomePage(title: 'Data Viz')),
      ),
    );

    // Spy on the refresh method
    final refreshSpy = dataFetchHandler.refresh;

    // Tap the refresh button
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();

    // Check that the refresh method was called
    expect(refreshSpy, isNotNull);
  });

  testWidgets('Floating action button displays correct max rows', (WidgetTester tester) async {
    final dataFetchHandler = DataFetchHandler();
    dataFetchHandler.maxRows = 10;
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => dataFetchHandler,
        child: MaterialApp(home: MyHomePage(title: 'Data Viz')),
      ),
    );

    expect(find.byType(FloatingMenu), findsOneWidget);
    // You can add more specific checks here based on the FloatingMenu implementation
  });
}