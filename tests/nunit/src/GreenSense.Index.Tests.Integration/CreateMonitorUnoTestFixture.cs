using System;
using NUnit.Framework;
namespace GreenSense.Index.Tests.Integration
{
	[TestFixture(Category = "Integration")]
	public class CreateMonitorUnoTestFixture : BaseTestFixture
	{
		[Test]
		public void Test_CreateMonitorUnoScript()
		{
			var scriptName = "create-garden-monitor-uno.sh";

			Console.WriteLine("Script:");
			Console.WriteLine(scriptName);

			var deviceType = "monitor/SoilMoistureSensorCalibratedSerial";
			var deviceLabel = "MyMonitor1";
			var deviceName = "myMonitor1";
			var devicePort = "ttyUSB0";

			var arguments = deviceLabel + " " + deviceName + " " + devicePort;

			var starter = GetDockerProcessStarter();
			starter.PreCommand = "sh init-mock-setup.sh";
			starter.RunDockerBash("sh " + scriptName + " " + arguments);


			CheckDeviceInfoWasCreated(deviceType, deviceLabel, deviceName, devicePort);

			CheckDeviceUIWasCreated(deviceLabel, deviceName);

			CheckMqttBridgeServiceFileWasCreated(deviceName);

			CheckUpdaterServiceFileWasCreated(deviceName);
		}
	}
}
