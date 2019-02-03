using System;
using NUnit.Framework;

namespace GreenSense.Index.Tests.Integration
{
	[TestFixture(Category = "Integration")]
	public class CreateVentilatorUnoTestFixture : BaseTestFixture
	{
		[Test]
		public void Test_CreateVentilatorUnoScript()
		{
			var scriptName = "create-garden-ventilator-uno.sh";

			Console.WriteLine("Script:");
			Console.WriteLine(scriptName);

			var deviceType = "ventilator/TemperatureHumidityDHTSensorFan";
			var deviceLabel = "MyVentilator";
			var deviceName = "myVentilator";
			var devicePort = "ttyUSB1";

			var arguments = deviceLabel + " " + deviceName + " " + devicePort;

			var starter = GetDockerProcessStarter();
			starter.PreCommand = "sh init-mock-setup.sh && sh clean.sh";
			starter.RunDockerBash("sh " + scriptName + " " + arguments);

			CheckDeviceInfoWasCreated(deviceType, deviceLabel, deviceName, devicePort);

			CheckDeviceUIWasCreated(deviceLabel, deviceName, "Ventilator1", "A", "Temperature", "T");

			CheckMqttBridgeServiceFileWasCreated(deviceName);

			CheckUpdaterServiceFileWasCreated(deviceName);
		}
	}
}
