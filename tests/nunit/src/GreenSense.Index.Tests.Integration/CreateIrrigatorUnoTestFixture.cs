﻿using System;
using NUnit.Framework;

namespace GreenSense.Index.Tests.Integration
{
	[TestFixture(Category = "Integration")]
	public class CreateIrrigatorUnoTestFixture : BaseTestFixture
	{
		[Test]
		public void Test_CreateIrrigatorUnoScript()
		{
			var scriptName = "create-garden-irrigator-uno.sh";

			Console.WriteLine("Script:");
			Console.WriteLine(scriptName);

			var deviceType = "irrigator/SoilMoistureSensorCalibratedPump";
			var deviceLabel = "MyIrrigator";
			var deviceName = "myIrrigator";
			var devicePort = "ttyUSB1";

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
