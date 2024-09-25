using DataService.Table;

namespace Test;

[TestClass]
public class TableUnitTests
{
    [TestMethod]
    public void testFromJson()
    {
        string jsonBlob = @"[{""country"": ""Australia"", ""alpha_two_code"": ""AU"", ""web_pages"": [""http://www.acs.edu.au/""], ""state-province"": null, ""name"": ""Australian Correspondence Schools"", ""domains"": [""acs.edu.au""]},
                             {""country"": ""Australia"", ""alpha_two_code"": ""AU"", ""web_pages"": [""http://www.acu.edu.au/""], ""state-province"": ""New South Wales"", ""name"": ""Australian Catholic University"", ""domains"": [""acu.edu.au""]}]";
        Table table = Table.fromJson(jsonBlob);

        Assert.AreEqual(table.Columns, []);
        foreach (var row in table.Rows)
        {
            List<string> rowValues = new List<string>();

            foreach (var column in table.Columns)
            {
                rowValues.Add(row.ContainsKey(column) ? row[column]?.ToString() : "null");
            }

            Console.WriteLine(string.Join(", ", rowValues));
        }
    }
}