using System;
using System.IO;
using NUnit.Framework;

namespace GreenSense.Index.Tests
{
	public class BaseTestFixture
	{
		public string ProjectDirectory;

		public string TemporaryDirectory;
		public string TemporaryProjectDirectory;
		public string TemporaryServicesDirectory;

		public bool AutoDeleteTemporaryDirectory = false;

		public BaseTestFixture()
		{
		}

		[SetUp]
		public void Initialize()
		{
			ProjectDirectory = Path.GetFullPath("../../../..");
			Console.WriteLine("Project directory: ");
			Console.WriteLine(ProjectDirectory);
			Console.WriteLine("");

			TemporaryDirectory = new TemporaryDirectoryCreator().Create(ProjectDirectory);
			Console.WriteLine("Temporary directory: ");
			Console.WriteLine(TemporaryDirectory);
			Console.WriteLine("");

			TemporaryProjectDirectory = Path.Combine(TemporaryDirectory, "project");
			Directory.CreateDirectory(TemporaryProjectDirectory);
			Console.WriteLine("Temporary project directory: ");
			Console.WriteLine(TemporaryProjectDirectory);
			CopyDirectory(ProjectDirectory, TemporaryProjectDirectory);
			Directory.SetCurrentDirectory(TemporaryProjectDirectory);

			if (File.Exists(Path.GetFullPath("is-mock-systemctl.txt")))
			{
				TemporaryServicesDirectory = Path.Combine(TemporaryProjectDirectory, "mock/services");
			}
			else
			{
				TemporaryServicesDirectory = "/lib/systemd/system/";
			}
			Console.WriteLine("Services directory:");
			Console.WriteLine("  " + TemporaryServicesDirectory);
		}

		public void CopyDirectory(string source, string destination)
		{
			var starter = new ProcessStarter();
			starter.Start("rsync -arh --exclude='.git' --exclude='.pioenvs' " + source + "/ " + destination + "/");
			Console.WriteLine(starter.Output);
		}

		[TearDown]
		public void Finish()
		{
			if (AutoDeleteTemporaryDirectory)
				Directory.Delete(TemporaryDirectory, true);
		}

		public DockerProcessStarter GetDockerProcessStarter()
		{
			var starter = new DockerProcessStarter();

			starter.WorkingDirectory = TemporaryProjectDirectory;

			starter.IsMockDocker = File.Exists(Path.GetFullPath("is-mock-docker.txt"));

			return starter;
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
