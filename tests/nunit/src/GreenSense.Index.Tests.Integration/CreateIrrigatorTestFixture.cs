using System;
using NUnit.Framework;

namespace GreenSense.Index.Tests.Integration
{
	[TestFixture(Category = "Integration")]
	public class CreateIrrigatorTestFixture : BaseTestFixture
	{
		[Test]
		public void Test_CreateIrrigatorScript()
		{
			var scriptName = "test-irrigator";

			Console.WriteLine("Script:");
			Console.WriteLine(scriptName);

			var starter = GetDockerProcessStarter();
			starter.PreCommand = "sh init-mock-setup.sh";
			var output = starter.RunScript(scriptName);

			var successfulText = "Irrigator test complete";

			Assert.IsTrue(output.Contains(successfulText), "Failed");
		}
	}
}
