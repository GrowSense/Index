using System;
using NUnit.Framework;
using System.IO;

namespace GreenSense.Index.Tests.Install.Web
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

            var branch = new BranchDetector ().GetBranch ();

            var destination = "installation/ArduinoPlugAndPlay";

            // Configure systemctl mocking
            var isMockSystemCtlFile = Path.Combine (TemporaryDirectory, destination + "/is-mock-systemctl.txt");
            Directory.CreateDirectory (Path.GetDirectoryName (isMockSystemCtlFile));
            File.WriteAllText (isMockSystemCtlFile, 1.ToString ());

            // Configure install mocking
            var isMockInstallFile = Path.Combine (TemporaryDirectory, destination + "/is-mock-install.txt");
            Directory.CreateDirectory (Path.GetDirectoryName (isMockInstallFile));
            File.WriteAllText (isMockInstallFile, 1.ToString ());

            var wifiName = "MyWifi";
            var wifiPass = "MyWifiPass";
            var mqttHost = "localhost";
            var mqttUser = "user";
            var mqttPass = "pass";

            var cmd = "bash " + scriptPath + " " + wifiName + " " + wifiPass + " " + mqttHost + " " + mqttUser + " " + mqttPass;

            Console.WriteLine ("Command:");
            Console.WriteLine ("  " + cmd);

            var starter = new ProcessStarter ();

            Console.WriteLine ("");
            Console.WriteLine ("Performing install from web test...");
            Console.WriteLine ("");

            starter.Start (cmd);

            Console.Write (starter.Output);

            Assert.IsFalse (starter.IsError, "An error occurred.");

            var expectedServiceFile = Path.Combine (Path.Combine (TemporaryDirectory, destination), "mock/services/arduino-plug-and-play.service");

            Assert.IsTrue (File.Exists (expectedServiceFile), "Plug and play service file not found.");
        }
    }
}

