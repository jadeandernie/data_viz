
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataFetchHandler extends ChangeNotifier {

  // ignore: non_constant_identifier_names
  final int LIMIT = 400;

  var data = {};
  bool isLoading = false;
  DateTime lastRefresh = DateTime(0);
  int lastPageNum = 0;
  String errorMessage = '';
  int maxRows = 0;
  String _selectedDataSrc = 'test_1';

  String get selectedDataSrc => _selectedDataSrc;

  DataFetchHandler() {
    loadFromSrc(lastPageNum);
  }

  Future<void> loadFromSrc(pageNum) async {
    errorMessage = '';
    if (isLoading == false && lastRefresh != DateTime(0)) {
      isLoading = true;
      notifyListeners();
    }
    try {
      var uriStr = 'http://localhost:8080/api/fetch?position=$pageNum&limit=$LIMIT&src=$selectedDataSrc';
      var res = await http.get(Uri.parse(uriStr))
        .timeout(const Duration(seconds: 10),
          onTimeout: () {
            return http.Response('Error', 408); // Request Timeout response status code
          });
      if(res.statusCode == 200 && res.body.isNotEmpty) {
        data = jsonDecode(res.body);
      } else {
        data = {};
      }
      isLoading = false;

      notifyListeners();
    } on TimeoutException catch (_) {
      // Handle timeout error
      errorMessage = 'Fetching data timed out. This may be due to internet connection.';
          notifyListeners();
    } on http.ClientException catch (_) {
      // Handle client error
      errorMessage = 'We are unable to process the data.';
          notifyListeners();
    } catch (e) {
      // Handle other errors
       errorMessage = 'Sorry, we\'ve had a glitch.';
          notifyListeners();
    }
  }


  void refresh() {
    if (isLoading && DateTime.now().difference(lastRefresh).inSeconds < 10) {
      return;
    }
    loadFromSrc(lastPageNum);
  }

  void updateMaxRows(int newMax) {
    maxRows = newMax;
    notifyListeners();
  }

  void updateSelectedDataSrc(String? newSrc) {
    if (newSrc != null && newSrc.isNotEmpty) _selectedDataSrc = newSrc;
    notifyListeners();
  }
}
