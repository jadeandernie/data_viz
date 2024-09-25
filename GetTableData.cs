using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace Sumday
{
    public class GetTableData
    {
        private readonly ILogger<GetTableData> _logger;

        public GetTableData(ILogger<GetTableData> logger)
        {
            _logger = logger;
        }

        [Function("GetTableData")]
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");
            return new OkObjectResult("Welcome to Azure Functions!");
        }
    }
}
