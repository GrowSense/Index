using System;
using System.IO;

namespace GreenSense.Index.Tests
{
	public class TestProcessStarter
	{
		public ProcessStarter Starter = new ProcessStarter();

		public string WorkingDirectory = Directory.GetCurrentDirectory();

		public string PreCommand = "sh prepare-for-test.sh";

		public TestProcessStarter()
		{
		}

		public void Initialize()
		{
			Console.WriteLine ("Initializing the test");

			RunProcess (PreCommand);
		}

		protected string RunProcess(string command)
		{
			var currentDirectory = Environment.CurrentDirectory;

			Directory.SetCurrentDirectory(WorkingDirectory);

			Console.WriteLine("Running process...");
			Console.WriteLine(command);

			Starter.Start(command);
			var output = Starter.Output;

			Directory.SetCurrentDirectory(currentDirectory);

			return output;
		}

		public string RunBash(string internalCommand)
		{
			Console.WriteLine ("Running bash command: ");
			Console.WriteLine (internalCommand);

			var output = String.Empty;

			output += RunProcess (internalCommand);

			return output;
		}

		public string RunScript(string scriptName)
		{
			if (!scriptName.EndsWith(".sh"))
				scriptName += ".sh";

			var fullCommand = "sh " + scriptName;

			return RunBash(fullCommand);
		}

	}
}
