using System.Text.Json;

public class Table {
    public required List<string> Columns { get; set; }
    public required List<Cell> HeaderRow { get; set; }
    public required List<Dictionary<string, Cell>> Rows { get; set; }

    public static Table fromJson(string jsonData) {
        using (JsonDocument doc = JsonDocument.Parse(jsonData)) {
            Table table = new Table {
                Columns = new List<string>(),
                HeaderRow = new List<Cell>(),
                Rows = new List<Dictionary<string, Cell>>()
            };

            // A set to keep track of column names
            HashSet<string> columnSet = new HashSet<string>();
            
            // Iterate through each item in the root array (each object represents a row)
            foreach (var element in doc.RootElement.EnumerateArray()) {
                Dictionary<string, Cell> row = new Dictionary<string, Cell>();

                // Process each key-value pair in the object
                foreach (var property in element.EnumerateObject()) {
                    columnSet.Add(property.Name); // Adding to set, so will be only unique values.
                    row[property.Name] = Cell.fromJsonProperty(property);
                }

                table.Rows.Add(row);
            }

            // Populate the table's columns with the unique keys found
            table.Columns.AddRange(columnSet);
            foreach (var col in columnSet) {
                table.HeaderRow.Add(Cell.fromEncodedString(col));
            }

            return table;
        }
    }
}