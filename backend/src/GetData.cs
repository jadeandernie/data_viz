using System.Collections;
using System.Text.Json;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace DataService {

    public class GetData {
        private readonly ILogger<GetData> _logger;

        public GetData(ILogger<GetData> logger) {
            _logger = logger;
        }

        async Task<Metadata?> asyncGetMetadata(string metadataSrc) {
            var jsonFilePath = Path.Combine(Directory.GetCurrentDirectory(), metadataSrc);
            if (!File.Exists(jsonFilePath)) {
                _logger.LogInformation("Fetch | Metadata not found: " + jsonFilePath.ToString());
                return null;
            }
            List<string> metadata = new List<string>();
            string jsonString = await File.ReadAllTextAsync(metadataSrc);
            try {
                return JsonSerializer.Deserialize<Metadata>(jsonString);
            } catch {
                _logger.LogError("Could not deserialize " + metadataSrc);
                return null;
            }
        }

        async Task<IActionResult> asyncGetJsonData(Metadata meta, string dataSrc, int position, int limit) {
            if (position >= meta.numDataRows && position > 0) {
                return new BadRequestObjectResult("Invalid request. Pagination parameters greater than dataset size.");
            }

            var jsonFileData = new List<string>();
            using (var reader = new StreamReader(dataSrc)) {
                // Skip lines until we reach the starting position
                for (int i = 0; i < position; i++) {
                    if (await reader.ReadLineAsync() == null) break; // Break if the end of the file is reached
                }

                // Read the specified number of lines
                for (int i = position; i < position + limit; i++) {
                    var line = await reader.ReadLineAsync();
                    if (line == null) break; // Break if the end of the file is reached
                    jsonFileData.Add(line);
                }
            }

            int newPosition = jsonFileData.Count < limit ? jsonFileData.Count : position + limit;

            return new OkObjectResult(
                new FetchResponseObject {
                    Data = Table.fromJson(meta, jsonFileData),
                    Position = newPosition,
                }
            );
        }

        [Function("fetch")]
        public async Task<IActionResult> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req) {
            _logger.LogInformation("Fetch | Retrieving data");
            
            // Parse query params
            var queryParams = System.Web.HttpUtility.ParseQueryString(req.QueryString.Value ?? "");
            
            string limitString = queryParams["limit"] ?? Environment.GetEnvironmentVariable("DEFAULT_FETCH_LIMIT") ?? "50";
            var limit = int.TryParse(limitString, out int limitInt) ? limitInt : 50;
            
            string positionString = queryParams["position"] ?? "0";
            var position = int.TryParse(positionString, out int positionInt) ? positionInt : 0;
            
            string dataSrcString = queryParams["src"] ?? "test_1";
            var srcRoot = Constants.DATA_SRCS[dataSrcString] ?? Constants.DATA_SRCS["test_1"];
            
            string? metaOnly = queryParams["meta"];            

            Metadata? meta = await asyncGetMetadata(srcRoot + "_metadata.json");
            if (meta == null) {
                return new BadRequestObjectResult("JSON metadata is empty or invalid.");
            }

            if (metaOnly != null) {
                return new OkObjectResult(meta);
            }

            return await asyncGetJsonData(meta, srcRoot + "_data.json", position, limit);
        }
    }
}
