using System;
using System.IO;
namespace GreenSense.Index.Tests.Integration
{
	public class DockerProcessStarter
	{
		public ProcessStarter Starter = new ProcessStarter();

		public string WorkingDirectory = Directory.GetCurrentDirectory();

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
			var fullCommand = "docker run -i --rm -v " + WorkingDirectory + ":/src -v /var/run/docker.sock:/var/run/docker.sock compulsivecoder/ubuntu-arm-iot-mono";
			fullCommand += " " + command;

			return RunProcess(fullCommand);
		}

		protected string RunDockerBash(string internalCommand)
		{
			var fullCommand = "/bin/bash -c \"" + internalCommand + "\"";

			return RunDockerProcess(fullCommand);
		}

		protected string RunClonedDockerBash(string internalCommand)
		{
			var fullCommand = "rsync -av --exclude='.git' /src/* /dest/ && cd /dest && " + internalCommand;

			return RunDockerBash(fullCommand);
		}

		public string RunScript(string scriptName)
		{
			if (!scriptName.EndsWith(".sh"))
				scriptName += ".sh";

			var fullCommand = "sh " + scriptName;

			return RunClonedDockerBash(fullCommand);
		}

	}
}
