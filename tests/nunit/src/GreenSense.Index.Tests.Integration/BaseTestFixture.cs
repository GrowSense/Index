using System;
using NUnit.Framework;
using System.Collections.Generic;
using System.IO.Ports;
using System.IO;

namespace GreenSense.Index.Tests.Integration
{
	public class BaseTestFixture
	{
		public bool CalibrationIsReversedByDefault = true;

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

		}

		public void CopyDirectory(string source, string destination)
		{
			var starter = new ProcessStarter();
			starter.Start("rsync -arzh --exclude='.git' " + source + "/ " + destination + "/");
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

			var systemServicesDir = "/lib/systemd/system/";

			TemporaryServicesDirectory = Path.Combine(TemporaryDirectory, "services");

			Directory.CreateDirectory(TemporaryServicesDirectory);

			starter.ExtraDockerArguments = "-v " + TemporaryServicesDirectory + ":" + systemServicesDir;

			return starter;
		}
	}
}
