using System;
using NUnit.Framework;

namespace GreenSense.Index.Tests.Integration
{
	[TestFixture(Category = "Integration")]
	public class CreateIlluminatorUnoTestFixture : BaseTestFixture
	{
		[Test]
		public void Test_CreateIlluminatorUnoScript()
		{
			var scriptName = "create-garden-illuminator-uno.sh";

			Console.WriteLine("Script:");
			Console.WriteLine(scriptName);

			var deviceType = "illuminator/LightPRSensorCalibratedLight";
			var deviceLabel = "MyIlluminator";
			var deviceName = "myIlluminator";
			var devicePort = "ttyUSB1";

			var arguments = deviceLabel + " " + deviceName + " " + devicePort;

			var starter = GetTestProcessStarter();
			starter.RunBash("sh " + scriptName + " " + arguments);

			CheckDeviceInfoWasCreated(deviceType, deviceLabel, deviceName, devicePort);

			CheckDeviceUIWasCreated(deviceLabel, deviceName, "Light", "L");

			CheckMqttBridgeServiceFileWasCreated(deviceName);

			CheckUpdaterServiceFileWasCreated(deviceName);
		}
	}
}
