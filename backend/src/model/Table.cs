using System.Text.Json;

public class Table {
    
    public required List<string> Columns { get; set; }
    public required List<Cell> HeaderRow { get; set; }
    public required List<Dictionary<string, Cell>> Rows { get; set; }
    public required int totalNumRows { get; set; }

    public static Table fromJson(Metadata meta, List<string> jsonData) {
        Table table = new Table {
            Columns = meta.columns,
            HeaderRow = new List<Cell>(),
            Rows = new List<Dictionary<string, Cell>>(),
            totalNumRows = meta.numDataRows,
        };

        // Iterate through each item in the root array (each object represents a row)
        foreach (string str in jsonData) {
            if (string.IsNullOrEmpty(str)) {
                continue;
            }
            Dictionary<string, Cell> row = new Dictionary<string, Cell>();
            // Process each key-value pair in the object
            foreach (var property in JsonDocument.Parse(str).RootElement.EnumerateObject()) {
                row[property.Name] = Cell.fromJsonProperty(property);
            }

            table.Rows.Add(row);
        }

        // Populate the table's columns with the unique keys found
        foreach (var col in table.Columns) {
            table.HeaderRow.Add(Cell.fromEncodedString(col));
        }

        return table;
    }
}