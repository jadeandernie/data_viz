import 'dart:convert';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/handlers/handle_fetch_data.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

// Create a mock class for http.Client
class MockClient extends Mock implements http.Client {}

void main() {
  group('DataFetchHandler Tests', () {
    late DataFetchHandler dataFetchHandler;
    late MockClient mockClient;

    setUp(() {
      // Initialize the mock client and data fetch handler
      mockClient = MockClient();
      dataFetchHandler = DataFetchHandler();
    });

    test('initial values are set correctly', () {
      expect(dataFetchHandler.data, {});
      expect(dataFetchHandler.isLoading, false);
      expect(dataFetchHandler.lastRefresh, DateTime(0));
      expect(dataFetchHandler.maxRows, 0);
      expect(dataFetchHandler.selectedDataSrc, 'test_1');
    });

    // test('successful data fetch updates data', () async {
    //   // Mock successful response
    //   final mockResponse = jsonEncode({
    //     'rows': [{'column1': {'data': 'value', 'type': 0}}],
    //     'columns': ['column1']
    //   });

    //   // Mock the http GET call
    //   when(mockClient.get(any as Uri)).thenAnswer(
    //     (_) async => http.Response(mockResponse, 200),
    //   );

    //   // Load data using the handler
    //   await dataFetchHandler.loadFromSrc(0);
      
    //   expect(dataFetchHandler.isLoading, false);
    //   expect(dataFetchHandler.data['rows'].length, 1); // Adjust to actual expected data structure
    // });

    // test('handles data fetch error', () async {
    //   // Mock an error response
    //   when(mockClient.get(any as Uri)).thenAnswer(
    //     (_) async => http.Response('Error', 500),
    //   );

    //   await dataFetchHandler.loadFromSrc(0);

    //   expect(dataFetchHandler.data, {});
    //   expect(dataFetchHandler.isLoading, false);
    //   expect(dataFetchHandler.errorMessage, 'Sorry, we\'ve had a glitch.');
    // });

    // test('handles timeout exception', () async {
    //   // Mock timeout
    //   when(mockClient.get(any as Uri)).thenThrow(TimeoutException('timeout'));

    //   await dataFetchHandler.loadFromSrc(0);

    //   expect(dataFetchHandler.errorMessage, 'Fetching data timed out. This may be due to internet connection.');
    //   expect(dataFetchHandler.isLoading, false);
    // });

    // test('refresh does not load if still loading within 10 seconds', () async {
    //   dataFetchHandler.isLoading = true;
    //   dataFetchHandler.lastRefresh = DateTime.now();

    //   dataFetchHandler.refresh();
      
    //   // Ensure no new load call is made
    //   verifyNever(mockClient.get(any as Uri));
    // });

    // test('refresh loads new data after 10 seconds', () async {
    //   dataFetchHandler.isLoading = false;
    //   dataFetchHandler.lastRefresh = DateTime.now().subtract(Duration(seconds: 11));

    //   // Mock successful response
    //   final mockResponse = jsonEncode({
    //     'rows': [{'column1': {'data': 'value', 'type': 0}}],
    //     'columns': ['column1']
    //   });

    //   when(mockClient.get(any as Uri)).thenAnswer(
    //     (_) async => http.Response(mockResponse, 200),
    //   );

    //   dataFetchHandler.refresh();

    //   // Verify the mock was called, indicating a refresh
    //   verify(mockClient.get(any)).called(1);
    // });

    test('updateMaxRows updates maxRows and notifies listeners', () {
      dataFetchHandler.updateMaxRows(10);
      expect(dataFetchHandler.maxRows, 10);
    });

    test('updateSelectedDataSrc updates data source and notifies listeners', () {
      dataFetchHandler.updateSelectedDataSrc('test_2');
      expect(dataFetchHandler.selectedDataSrc, 'test_2');
    });

    test('updateSelectedDataSrc does not update with null or empty', () {
      dataFetchHandler.updateSelectedDataSrc(null);
      expect(dataFetchHandler.selectedDataSrc, 'test_1'); // Should remain unchanged

      dataFetchHandler.updateSelectedDataSrc('');
      expect(dataFetchHandler.selectedDataSrc, 'test_1'); // Should remain unchanged
    });
  });
}
