using System;
using System.IO;

namespace GreenSense.Index.Tests
{
	public class DockerProcessStarter
	{
		public ProcessStarter Starter = new ProcessStarter();

		public string WorkingDirectory = Directory.GetCurrentDirectory();

		public string PreCommand = "";

		public string ExtraDockerArguments = "";

		public bool IsMockDocker = false;

		public DockerProcessStarter()
		{
		}

		protected string RunProcess(string command)
		{
			var currentDirectory = Environment.CurrentDirectory;

			Directory.SetCurrentDirectory(WorkingDirectory);

			Console.WriteLine("Running docker process...");
			Console.WriteLine(command);

			Starter.Start(command);
			var output = Starter.Output;

			Directory.SetCurrentDirectory(currentDirectory);

			return output;
		}

		protected string RunDockerProcess(string command)
		{
			var fullCommand = "";
			if (IsMockDocker)
			{
				fullCommand += "docker run -i --rm ";
				fullCommand += ExtraDockerArguments;
				fullCommand += " -v " + WorkingDirectory + ":/project -v /var/run/docker.sock:/var/run/docker.sock compulsivecoder/ubuntu-arm-iot-mono";
			}
			fullCommand += " " + command;

			return RunProcess(fullCommand.Trim());
		}

		protected string RunDockerBash(string internalCommand)
		{
			var fullPreCommand = "";
			if (!String.IsNullOrEmpty(PreCommand))
				fullPreCommand = PreCommand + " && ";

			var fullCommand = "/bin/bash -c \"cd /project && " + fullPreCommand + internalCommand + "\"";

			return RunDockerProcess(fullCommand);
		}

		public string RunScript(string scriptName)
		{
			if (!scriptName.EndsWith(".sh"))
				scriptName += ".sh";

			var fullCommand = "sh " + scriptName;

			return RunDockerBash(fullCommand);
		}

	}
}
