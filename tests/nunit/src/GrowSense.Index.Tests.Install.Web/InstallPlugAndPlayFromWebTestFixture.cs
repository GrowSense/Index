using System;
using NUnit.Framework;
using System.IO;

namespace GrowSense.Index.Tests.Install.Web
{
    [TestFixture (Category = "InstallFromWeb")]
    public class InstallPlugAndPlayFromWebTestFixture : BaseTestFixture
    {
        [Test]
        public void Test_Install_FromWeb ()
        {
            MoveToTemporaryDirectory ();

            Console.WriteLine ("");
            Console.WriteLine ("Preparing install from web test...");
            Console.WriteLine ("");

            PullFileFromProject ("scripts-web/install-plug-and-play-from-web.sh", true);

            var scriptPath = Path.GetFullPath ("install-plug-and-play-from-web.sh");

            var branchDetector = new BranchDetector ();
            var branch = branchDetector.Branch;

            var installDir = Path.GetFullPath ("GrowSense/Index");

            EnableMocking (installDir, "systemctl");
            EnableMocking (installDir, "mqtt-bridge");
            EnableMocking (installDir, "docker");
            EnableMocking (installDir, "install");

            var pnpInstallDir = Path.GetFullPath ("ArduinoPlugAndPlay");

            EnableMocking (pnpInstallDir, "systemctl");

            var random = new Random ();

            var wifiName = "MyWifi" + random.Next (99);
            var wifiPass = "MyPass" + random.Next (99);

            var mqttHost = "10.0.0." + random.Next (99);
            var mqttUser = "user" + random.Next (99);
            var mqttPass = "pass" + random.Next (99);
            var mqttPort = "18" + random.Next (99);

            var cmd = "bash " + scriptPath + " " + branch + " " + installDir + " " + wifiName + " " + wifiPass + " " + mqttHost + " " + mqttUser + " " + mqttPass + " " + mqttPort;

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
            var expectedServiceFile = Path.Combine (pnpInstallDir, "mock/services/arduino-plug-and-play.service");
            Assert.IsTrue (File.Exists (expectedServiceFile), "Plug and play service file not found.");

            Console.WriteLine ("Checking that GrowSense index was installed.");
            var indexGitDir = Path.Combine (installDir, ".git");
            Assert.IsTrue (Directory.Exists (indexGitDir), "The GrowSense index .git folder wasn't found.");

        }
    }
}

