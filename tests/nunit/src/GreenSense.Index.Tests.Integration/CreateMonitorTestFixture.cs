using System;
using NUnit.Framework;
namespace GreenSense.Index.Tests.Integration
{
	[TestFixture(Category = "Integration")]
	public class CreateMonitorTestFixture : BaseTestFixture
	{
		[Test]
		public void Test_CreateMonitorScript()
		{
			var scriptName = "test-monitor";

			Console.WriteLine("Script:");
			Console.WriteLine(scriptName);

			var starter = GetDockerProcessStarter();
			starter.PreCommand = "sh init-mock-setup.sh";
			var output = starter.RunScript(scriptName);

			var successfulText = "Monitor test complete";

			Assert.IsTrue(output.Contains(successfulText), "Failed");

			var type = "monitor/SoilMoistureSensorCalibratedSerial";
			var label = "MyMonitor";
			var name = "mymonitor";
			var port = "ttyUSB0";

			CheckDeviceInfoWasCreated(type, label, name, port);

			CheckDeviceUIWasCreated(label, name);
		}
	}
}
