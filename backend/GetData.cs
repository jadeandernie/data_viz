using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace DataService
{
    public class GetData
    {
        private readonly ILogger<GetData> _logger;

        public GetData(ILogger<GetData> logger)
        {
            _logger = logger;
        }

        [Function("fetch")]
        public async Task<IActionResult> RunAsync([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req)
        {
            
            var jsonFilePath = Path.Combine(Directory.GetCurrentDirectory(), "resources/test-data.json");
            if (!File.Exists(jsonFilePath))
            {
                _logger.LogInformation("Tried to fetch data, but file not found: " + jsonFilePath.ToString());
                return new NotFoundResult();
            }

            return new OkObjectResult(await File.ReadAllTextAsync(jsonFilePath));
        }
    }
}
