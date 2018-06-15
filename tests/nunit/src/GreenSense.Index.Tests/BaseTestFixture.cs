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
	}
}
