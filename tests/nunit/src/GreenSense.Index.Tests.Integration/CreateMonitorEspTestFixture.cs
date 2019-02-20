using System;
using NUnit.Framework;

namespace GreenSense.Index.Tests.Integration
{
	[TestFixture(Category = "Integration")]
	public class CreateMonitorEspTestFixture : BaseTestFixture
	{
		[Test]
		public void Test_CreateMonitorEspScript()
		{
			var scriptName = "test-monitor-esp";

			Console.WriteLine("Script:");
			Console.WriteLine(scriptName);

			var starter = GetTestProcessStarter();
			var output = starter.RunScript(scriptName);

			var successfulText = "Monitor ESP8266 test complete";

			Assert.IsTrue(output.Contains(successfulText), "Failed");

			var type = "monitor/SoilMoistureSensorCalibratedSerialESP";
			var label = "MyMonitor";
			var name = "mymonitor";
			var port = "ttyUSB0";

			CheckDeviceInfoWasCreated(type, label, name, port);

			CheckDeviceUIWasCreated(label, name, "Soil Moisture", "C");
		}
	}
}
