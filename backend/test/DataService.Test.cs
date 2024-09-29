using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace DataService.Tests
{
    public class GetDataTests
    {
        private readonly Mock<ILogger<GetData>> _mockLogger;
        private readonly GetData _getData;

        public GetDataTests()
        {
            _mockLogger = new Mock<ILogger<GetData>>();
            _getData = new GetData(_mockLogger.Object);
        }

        // Mocking the File.ReadAllTextAsync for metadata
        private void MockMetadata(string filePath, string content)
        {
            Mock.Get(typeof(File))
                .Setup(f => f.ReadAllTextAsync(It.IsAny<string>()))
                .Returns(Task.FromResult(content));
        }

        // Mocking StreamReader for reading data rows
        private void MockDataFile(string filePath, List<string> lines)
        {
            var mockReader = new Mock<StreamReader>(filePath);
            var setup = mockReader.SetupSequence(r => r.ReadLineAsync());

            foreach (var line in lines)
            {
                setup.ReturnsAsync(line);
            }

            setup.ReturnsAsync(null); // End of file

            Mock.Get(typeof(StreamReader))
                .Setup(f => f.ReadToEndAsync())
                .Returns(Task.FromResult(string.Join(Environment.NewLine, lines)));
        }

        [Fact]
        public async Task Run_ReturnsMetadataOnly_WhenMetaQueryParamIsSet()
        {
            // Arrange
            var mockMetadata = "{\"numDataRows\": 100}";
            MockMetadata("test_1_metadata.json", mockMetadata);

            var mockHttpRequest = new Mock<HttpRequest>();
            mockHttpRequest.Setup(req => req.QueryString).Returns(new QueryString("?meta=true"));

            // Act
            var result = await _getData.Run(mockHttpRequest.Object) as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            Assert.IsType<Metadata>(result.Value); // Ensure it's the Metadata object
        }

        [Fact]
        public async Task Run_ReturnsBadRequest_WhenMetadataNotFound()
        {
            // Arrange
            MockMetadata("test_1_metadata.json", string.Empty); // No metadata found

            var mockHttpRequest = new Mock<HttpRequest>();
            mockHttpRequest.Setup(req => req.QueryString).Returns(new QueryString(""));

            // Act
            var result = await _getData.Run(mockHttpRequest.Object) as BadRequestObjectResult;

            // Assert
            Assert.NotNull(result);
            Assert.Equal("JSON metadata is empty or invalid.", result.Value);
        }

        [Fact]
        public async Task Run_ReturnsDataRows_WhenValidDataIsRequested()
        {
            // Arrange
            var mockMetadata = "{\"numDataRows\": 100}";
            MockMetadata("test_1_metadata.json", mockMetadata);

            var dataRows = new List<string>
            {
                "{\"col1\": {\"data\": \"row1\", \"type\": 0}}",
                "{\"col1\": {\"data\": \"row2\", \"type\": 0}}"
            };

            MockDataFile("test_1_data.json", dataRows);

            var mockHttpRequest = new Mock<HttpRequest>();
            mockHttpRequest.Setup(req => req.QueryString).Returns(new QueryString("?position=0&limit=2"));

            // Act
            var result = await _getData.Run(mockHttpRequest.Object) as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            var fetchResponse = Assert.IsType<FetchResponseObject>(result.Value);
            Assert.Equal(2, fetchResponse.Data.Rows.Count);
        }

        [Fact]
        public async Task Run_ReturnsBadRequest_WhenPaginationExceedsDataset()
        {
            // Arrange
            var mockMetadata = "{\"numDataRows\": 100}";
            MockMetadata("test_1_metadata.json", mockMetadata);

            var mockHttpRequest = new Mock<HttpRequest>();
            mockHttpRequest.Setup(req => req.QueryString).Returns(new QueryString("?position=200&limit=10"));

            // Act
            var result = await _getData.Run(mockHttpRequest.Object) as BadRequestObjectResult;

            // Assert
            Assert.NotNull(result);
            Assert.Equal("Invalid request. Pagination parameters greater than dataset size.", result.Value);
        }

        // More tests can be added for different query parameter scenarios
    }
}
