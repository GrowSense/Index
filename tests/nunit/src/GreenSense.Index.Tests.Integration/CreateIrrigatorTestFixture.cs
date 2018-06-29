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
			starter.RunScript(scriptName);

			var type = "irrigator/SoilMoistureSensorCalibratedPump";
			var label = "MyIrrigator";
			var name = "myirrigator";
			var port = "ttyUSB1";

			CheckDeviceInfoWasCreated(type, label, name, port);

			CheckDeviceUIWasCreated(label, name);

			CheckMqttBridgeServiceFileWasCreated(name);

			CheckUpdaterServiceFileWasCreated(name);
		}
	}
}
