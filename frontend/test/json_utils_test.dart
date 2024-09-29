import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/utils/json_utils.dart';

void main() {
  group('jsonToDataColumns', () {
    test('returns empty list when headerRow is null', () {
      final json = {'headerRow': null};
      final columns = jsonToDataColumns(json);
      expect(columns, isEmpty);
    });

    test('returns correct data columns from json', () {
      final json = {
        'headerRow': [
          {'data': 'Column 1'},
          {'data': 'Column 2'}
        ]
      };
      final columns = jsonToDataColumns(json);
      expect(columns.length, 2);
      expect(columns[0].label, isA<Text>().having((text) => text.data, 'data', 'Column 1'));
      expect(columns[1].label, isA<Text>().having((text) => text.data, 'data', 'Column 2'));
    });
  });

  group('JsonDataTableSrc', () {
    test('returns correct row count', () {
      final dataSource = JsonDataTableSrc(rows: []);
      expect(dataSource.rowCount, 0);

      final row1 = DataRow(cells: [DataCell(Text('Row 1'))]);
      final row2 = DataRow(cells: [DataCell(Text('Row 2'))]);
      final dataSourceWithRows = JsonDataTableSrc(rows: [row1, row2]);
      expect(dataSourceWithRows.rowCount, 2);
    });

    test('returns the correct row based on index', () {
      final row1 = DataRow(cells: [DataCell(Text('Row 1'))]);
      final row2 = DataRow(cells: [DataCell(Text('Row 2'))]);
      final dataSource = JsonDataTableSrc(rows: [row1, row2]);

      expect(dataSource.getRow(0), row1);
      expect(dataSource.getRow(1), row2);
      try {
        dataSource.getRow(2);
        fail('Index was outside range');
      } catch(err) {
        // Expected.
      }
      try {
        dataSource.getRow(-1);
        fail('Index was outside range');
      } catch(err) {
        // Expected.
      }
    });

    test('isRowCountApproximate is false', () {
      final dataSource = JsonDataTableSrc(rows: []);
      expect(dataSource.isRowCountApproximate, isFalse);
    });

    test('selectedRowCount is zero', () {
      final dataSource = JsonDataTableSrc(rows: []);
      expect(dataSource.selectedRowCount, 0);
    });
  });

  group('jsonToDataSrc', () {
    test('returns empty JsonDataTableSrc when rows is null', () {
      final json = {'rows': null};
      final dataSource = jsonToDataSrc(json);
      expect(dataSource.rowCount, 0);
    });

    // test('returns correct data source from json', () {
    //   final json = {
    //     'columns': [
    //       'data',
    //       'Column 1',
    //       'Column 2',
    //     ],
    //     'rows': [
    //       {'data': 'Row 1 Col 1', 'type': "0"},
    //     ]
    //   };

    //   final dataSource = jsonToDataSrc(json);
    //   expect(dataSource.rowCount, 2);
    //   expect(dataSource.getRow(0)?.cells.length, 2);
    //   expect(dataSource.getRow(0)?.cells[0].child, isA<Text>().having((text) => text.data, 'data', 'Row 1 Col 1'));
    //   expect(dataSource.getRow(0)?.cells[1].child, isA<InkWell>());
    // });

    test('throws error for unknown cell type', () {
      final json = {
        'columns': [
          {'data': 'Column 1'}
        ],
        'rows': [
          {
            'Column 1': {'data': 'Row 1 Col 1', 'type': 4} // Unknown type
          }
        ]
      };

      expect(() => jsonToDataSrc(json), throwsA(isA<Error>()));
    });
  });
}
