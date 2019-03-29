﻿using System;
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
        public bool IsMockMqtt = true;

        public TestProcessStarter ()
        {
            Starter.IsVerbose = false;
        }

        public void Initialize ()
        {
            Console.WriteLine ("Initializing the test");

            RunProcess (PreCommand);

            if (IsMockHardware)
                File.WriteAllText (Path.GetFullPath ("is-mock-hardware.txt"), 1.ToString ());
            else
                File.Delete (Path.GetFullPath ("is-mock-hardware.txt"));

            if (IsMockSystemCTL)
                File.WriteAllText (Path.GetFullPath ("is-mock-systemctl.txt"), 1.ToString ());
            else
                File.Delete (Path.GetFullPath ("is-mock-systemctl.txt"));

            if (IsMockMqttBridge)
                File.WriteAllText (Path.GetFullPath ("is-mock-mqtt-bridge.txt"), 1.ToString ());
            else
                File.Delete (Path.GetFullPath ("is-mock-mqtt-bridge.txt"));

            if (IsMockMqtt)
                File.WriteAllText (Path.GetFullPath ("is-mock-mqtt.txt"), 1.ToString ());
            else
                File.Delete (Path.GetFullPath ("is-mock-mqtt.txt"));

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
            // Console.WriteLine ("Running bash command: ");
            // Console.WriteLine (internalCommand);

            var output = String.Empty;

            var fixedCommand = "/bin/bash -c '" + internalCommand + "'";

            output += RunProcess (fixedCommand);

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
