using System;
using NUnit.Framework;
using System.IO;

namespace GrowSense.Index.Tests.Install.Web
{
    [TestFixture (Category = "InstallFromWeb")]
    public class SetWiFiCredentialsFromWebTestFixture : BaseTestFixture
    {
        [Test]
        public void Test_SetWiFiCredentialsFromWeb ()
        {
            MoveToTemporaryDirectory ();

            Console.WriteLine ("");
            Console.WriteLine ("Preparing set WiFi credentials from web test...");
            Console.WriteLine ("");

            var scriptName = "set-wifi-credentials-from-web.sh";

            PullFileFromProject ("scripts-web/" + scriptName, true);

            var scriptPath = Path.GetFullPath (scriptName);

            var branchDetector = new BranchDetector ();
            var branch = branchDetector.Branch;

            var installDir = "installation";

            var random = new Random ();

            var wifiName = "MyWifi" + random.Next (99);
            var wifiPass = "MyPass" + random.Next (99);

            var cmd = "bash " + scriptPath + " " + branch + " " + installDir + " " + wifiName + " " + wifiPass;

            Console.WriteLine ("Command:");
            Console.WriteLine ("  " + cmd);

            var starter = new ProcessStarter ();

            Console.WriteLine ("");
            Console.WriteLine ("Performing test...");
            Console.WriteLine ("");

            starter.Start (cmd);

            Console.Write (starter.Output);

            Assert.IsFalse (starter.IsError, "An error occurred.");

            AssertSecurityFile (installDir, "wifi-name", wifiName);
            AssertSecurityFile (installDir, "wifi-password", wifiPass);
        }

        public void AssertSecurityFile (string installDir, string name, string value)
        {
            Console.WriteLine ("Checking for security file...");

            var expectedSecurityfile = Path.Combine (Path.Combine (TemporaryDirectory, installDir), name + ".security");

            Console.WriteLine ("  " + expectedSecurityfile);

            Assert.IsTrue (File.Exists (expectedSecurityfile), name + ".security file not found.");

            var fileContent = File.ReadAllText (expectedSecurityfile).Trim ();
            Assert.AreEqual (value, fileContent, "The content of the security file wasn't set properly: " + name);
        }
    }
}

