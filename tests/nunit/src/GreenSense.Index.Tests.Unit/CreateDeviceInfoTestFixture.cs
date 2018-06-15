using System;
using NUnit.Framework;
using System.IO;
namespace GreenSense.Index.Tests.Unit
{
	[TestFixture(Category = "Unit")]
	public class CreateDeviceInfoTestFixture : BaseTestFixture
	{
		[Test]
		public void Test_CreateDeviceInfo()
		{
			Console.WriteLine("Testing create-garden-info.sh script");

			var scriptName = "create-device-info.sh";

			Console.WriteLine("Script:");
			Console.WriteLine(scriptName);

			var deviceType = "monitor/SoilMoistureSensorCalibratedSerial";
			var deviceLabel = "Monitor1";
			var deviceName = "monitor1";
			var devicePort = "ttyUSB0";

			var arguments = deviceType + " " + deviceLabel + " " + deviceName + " " + devicePort;

			var command = "sh " + scriptName + " " + arguments;

			var starter = new ProcessStarter();
			//starter.PreCommand = "sh init-mock-setup.sh";

			Console.WriteLine("Running script...");

			starter.Start(command);

			var output = starter.Output;

			Console.WriteLine("Checking device info was created...");

			CheckDeviceInfoWasCreated(deviceType, deviceLabel, deviceName, devicePort);


			Console.WriteLine("Checking console output is correct...");
			var successfulText = "Device info created";

			Assert.IsTrue(output.Contains(successfulText), "Failed");

			Console.WriteLine("Test complete");
		}

		public void CheckDeviceInfoWasCreated(string deviceType, string deviceLabel, string deviceName, string devicePort)
		{
			var devicesDir = Path.GetFullPath("devices");
			var deviceDir = Path.Combine(devicesDir, deviceName);

			Console.WriteLine("Device dir:");
			Console.WriteLine(deviceDir);

			var deviceDirExists = Directory.Exists(deviceDir);

			Assert.IsTrue(deviceDirExists, "Device directory not found: " + deviceDir);

			var foundType = File.ReadAllText(Path.Combine(deviceDir, "type.txt")).Trim();

			Assert.AreEqual(deviceType, foundType, "Device type doesn't match.");

			var foundLabel = File.ReadAllText(Path.Combine(deviceDir, "label.txt")).Trim();

			Assert.AreEqual(deviceLabel, foundLabel, "Device label doesn't match.");

			var foundName = File.ReadAllText(Path.Combine(deviceDir, "name.txt")).Trim();

			Assert.AreEqual(deviceName, foundName, "Device name doesn't match.");

			var foundPort = File.ReadAllText(Path.Combine(deviceDir, "port.txt")).Trim();

			Assert.AreEqual(devicePort, foundPort, "Device port doesn't match.");
		}
	}
}
