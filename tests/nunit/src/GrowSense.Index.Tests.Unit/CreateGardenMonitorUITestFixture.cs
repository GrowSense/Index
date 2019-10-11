using System;
using NUnit.Framework;
using System.IO;
using Newtonsoft.Json.Linq;
namespace GrowSense.Index.Tests.Unit
{
	[TestFixture(Category = "Unit")]
	public class CreateGardenMonitorUITestFixture : BaseTestFixture
	{
		[Test]
		public void Test_CreateGardenMonitorUI()
		{
			var scriptName = "create-garden-monitor-ui.sh";

			Console.WriteLine("Testing " + scriptName + " script");

			var deviceLabel = "Monitor1";
			var deviceName = "monitor1";

			var arguments = deviceLabel + " " + deviceName;

			var command = "sh " + scriptName + " " + arguments;

			var starter = GetTestProcessStarter ();

			Console.WriteLine("Running script...");

			starter.RunBash(command);

			Console.WriteLine("Checking device UI was created...");

			CheckDeviceUIWasCreated(deviceLabel, deviceName, "Soil Moisture", "C");

			Console.WriteLine("Creating device info folder...");

			Directory.CreateDirectory(Path.GetFullPath("devices/" + deviceName));

			Console.WriteLine("Attempting to create a duplicate...");

			starter.RunBash(command);

			Console.WriteLine("Ensuring that no duplicate UI was created...");

			CheckDeviceUICount(1);
		}
	}
}
