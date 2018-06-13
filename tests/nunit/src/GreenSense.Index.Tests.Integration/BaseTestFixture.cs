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
		}

		[TearDown]
		public void Finish()
		{
		}

		public DockerProcessStarter GetDockerProcessStarter()
		{
			var starter = new DockerProcessStarter();
			starter.WorkingDirectory = ProjectDirectory;
			return starter;
		}
	}
}
