using System;
using System.IO;
using System.Threading;

namespace GreenSense.Index.Tests
{
    public class TestProcessStarter
    {
        public ProcessStarter Starter = new ProcessStarter ();

        public string WorkingDirectory = Directory.GetCurrentDirectory ();

        public string PreCommand = "sh prepare-for-test.sh";

        public bool IsMockSystemCTL = true;
        public bool IsMockHardware = true;
        public bool IsMockMqttBridge = true;

        public TestProcessStarter ()
        {
            Starter.IsVerbose = false;
        }

        public void Initialize ()
        {
            Console.WriteLine ("Initializing the test");

            RunProcess (PreCommand);

            if (IsMockHardware)
                RunProcess ("sh init-mock-hardware.sh");
            else
                File.Delete (Path.GetFullPath ("is-mock-hardware.txt"));

            if (IsMockSystemCTL)
                RunProcess ("sh init-mock-systemctl.sh");
            else
                File.Delete (Path.GetFullPath ("is-mock-systemctl.txt"));

            if (IsMockMqttBridge)
                RunProcess ("sh init-mock-mqtt-bridge.sh");
            else
                File.Delete (Path.GetFullPath ("is-mock-mqtt-bridge.txt"));

            Thread.Sleep (1000);
        }

        protected string RunProcess (string command)
        {
            var currentDirectory = Environment.CurrentDirectory;

            Directory.SetCurrentDirectory (WorkingDirectory);

            Console.WriteLine ("Running process...");
            Console.WriteLine (command);

            Starter.Start (command);
            var output = Starter.Output;

            Directory.SetCurrentDirectory (currentDirectory);

            return output;
        }

        public string RunBash (string internalCommand)
        {
            Console.WriteLine ("Running bash command: ");
            Console.WriteLine (internalCommand);

            var output = String.Empty;

            output += RunProcess (internalCommand);

            return output;
        }

        public string RunScript (string scriptName)
        {
            if (!scriptName.EndsWith (".sh"))
                scriptName += ".sh";

            var fullCommand = "sh " + scriptName;

            return RunBash (fullCommand);
        }

    }
}
