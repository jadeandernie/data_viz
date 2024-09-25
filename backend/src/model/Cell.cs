using System.Text.Json;
using System.Text.Json.Nodes;

public enum CellType {
    PlainText,
    Link,
    Number,
    Boolean,
}

public class Cell {
    public required CellType Type { get; set; }
    public required object Data { get; set; }

    public static Cell fromString(String? str) {
        if(Uri.IsWellFormedUriString(str, UriKind.Absolute)) {
            return new Cell {
            Type = CellType.Link,
            Data = str
        };
        }
        return new Cell {
            Type = CellType.PlainText,
            Data = str != null ? str : "",
        };
    }

    public static Cell fromEncodedString(String str) {
        string spacedVal = str.Replace(" ", "_");
        return new Cell {
            Type = CellType.PlainText,
            Data = string.Concat(spacedVal[0].ToString().ToUpper(), spacedVal.Replace("_", " ").AsSpan(1)),
        };
    }

    public static Cell fromArray(JsonElement.ArrayEnumerator strs) {
        List<string?> strValues = [];
        foreach(var strElement in strs) {
            strValues.Add(strElement.GetString());
        }
        return new Cell {
            Type = CellType.PlainText,
            Data = string.Join(",", strValues)
        };
    }
    
    public static Cell fromJsonProperty(JsonProperty property) {
        return property.Value.ValueKind switch {
            JsonValueKind.String => Cell.fromString(property.Value.GetString()),
            JsonValueKind.Number => new Cell{
                Type = CellType.Number,
                Data = property.Value.GetDecimal()
            },
            JsonValueKind.True => new Cell{
                Type = CellType.Boolean,
                Data = true
            },
            JsonValueKind.False => new Cell{
                Type = CellType.Boolean,
                Data = false
            },
            JsonValueKind.Null => new Cell{
                Type = CellType.PlainText,
                Data = ""
            },
            JsonValueKind.Array => fromArray(property.Value.EnumerateArray()),
            JsonValueKind.Undefined => throw new NotImplementedException(),
            JsonValueKind.Object => throw new NotImplementedException(),
            _ => new Cell{
                Type = CellType.PlainText,
                Data = property.Value.ToString() // Fallback for other types
            }
        };
    }
}