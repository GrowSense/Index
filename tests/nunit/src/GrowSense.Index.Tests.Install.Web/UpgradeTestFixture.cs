using System;
using NUnit.Framework;
using System.IO;

namespace GrowSense.Index.Tests.Install.Web
{
    [TestFixture (Category = "Install")]
    public class UpgradeTestFixture : BaseTestFixture
    {
        [Test]
        public void Test_Upgrade ()
        {
            MoveToTemporaryDirectory ();

            Console.WriteLine ("");
            Console.WriteLine ("Preparing upgrade test...");
            Console.WriteLine ("");

            var installDir = Path.GetFullPath ("GrowSense/Index");
            var pnpInstallDir = Path.GetFullPath ("ArduinoPlugAndPlay");

            var branchDetector = new BranchDetector ();
            var branch = branchDetector.Branch;


            PrepareGrowSenseInstallation (branch, installDir, pnpInstallDir);

            Directory.SetCurrentDirectory (installDir);

            PullFileFromProject ("upgrade.sh", true);

            var scriptPath = Path.GetFullPath ("upgrade.sh");
            var cmd = "bash " + scriptPath;

            Console.WriteLine ("Command:");
            Console.WriteLine ("  " + cmd);

            var starter = new ProcessStarter ();

            Console.WriteLine ("");
            Console.WriteLine ("Performing upgrade test...");
            Console.WriteLine ("");

            starter.Start (cmd);

            Console.Write (starter.Output);

            Assert.IsFalse (starter.IsError, "An error occurred.");

            Console.WriteLine ("Checking that the ArduinoPlugAndPlay service file was installed.");
            var expectedServiceFile = Path.Combine (pnpInstallDir, "mock/services/arduino-plug-and-play.service");
            Assert.IsTrue (File.Exists (expectedServiceFile), "Plug and play service file not found.");

            Console.WriteLine ("Checking that GrowSense index was installed.");
            var indexGitDir = Path.Combine (installDir, ".git");
            Assert.IsTrue (Directory.Exists (indexGitDir), "The GrowSense index .git folder wasn't found.");
        }

        // TODO: Find a faster way of setting up a fake installation instead of doing an actual install
        public void PrepareGrowSenseInstallation (string branch, string greenSenseInstallDir, string arduinoPlugAndPlayInstallDir)
        {
            PullFileFromProject ("scripts-web/install-plug-and-play-from-web.sh", true);

            var scriptPath = Path.GetFullPath ("install-plug-and-play-from-web.sh");

            EnableMocking (greenSenseInstallDir, "systemctl");
            EnableMocking (greenSenseInstallDir, "mqtt-bridge");
            EnableMocking (greenSenseInstallDir, "docker");
            EnableMocking (greenSenseInstallDir, "install");
            EnableMocking (greenSenseInstallDir, "apt");


            EnableMocking (arduinoPlugAndPlayInstallDir, "systemctl");

            var random = new Random ();

            var wifiName = "MyWifi" + random.Next (99);
            var wifiPass = "MyPass" + random.Next (99);

            var mqttHost = "10.0.0." + random.Next (99);
            var mqttUser = "user" + random.Next (99);
            var mqttPass = "pass" + random.Next (99);
            var mqttPort = "18" + random.Next (99);

            var cmd = "bash " + scriptPath + " " + branch + " " + greenSenseInstallDir + " " + wifiName + " " + wifiPass + " " + mqttHost + " " + mqttUser + " " + mqttPass + " " + mqttPort;

            Console.WriteLine ("Command:");
            Console.WriteLine ("  " + cmd);

            var starter = new ProcessStarter ();

            Console.WriteLine ("");
            Console.WriteLine ("Performing install from web test...");
            Console.WriteLine ("");

            starter.Start (cmd);

            Console.Write (starter.Output);

            Assert.IsFalse (starter.IsError, "An error occurred.");

            Console.WriteLine ("Checking that the ArduinoPlugAndPlay service file was installed.");
            var expectedServiceFile = Path.Combine (arduinoPlugAndPlayInstallDir, "mock/services/arduino-plug-and-play.service");
            Assert.IsTrue (File.Exists (expectedServiceFile), "Plug and play service file not found.");

            Console.WriteLine ("Checking that GrowSense index was installed.");
            var indexGitDir = Path.Combine (greenSenseInstallDir, ".git");
            Assert.IsTrue (Directory.Exists (indexGitDir), "The GrowSense index .git folder wasn't found.");

        }
    }
}

