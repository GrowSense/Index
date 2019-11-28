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

      //PullFileFromProject ("upgrade.sh", true);

      var scriptName = "upgrade.sh";
      var cmd = "bash " + scriptName;

      Console.WriteLine ("Command:");
      Console.WriteLine ("  " + cmd);

      var starter = GetTestProcessStarter ();

      Console.WriteLine ("");
      Console.WriteLine ("Performing upgrade test...");
      Console.WriteLine ("");

      starter.RunBash (cmd);

      Console.Write (starter.Starter.Output);

      Assert.IsFalse (starter.Starter.IsError, "An error occurred.");

      Console.WriteLine ("Checking that the ArduinoPlugAndPlay service file was installed.");
      var expectedServiceFile = Path.Combine (pnpInstallDir, "mock/services/arduino-plug-and-play.service");
      Assert.IsTrue (File.Exists (expectedServiceFile), "Plug and play service file not found.");

      Console.WriteLine ("Checking that GrowSense index was installed.");
      var indexGitDir = Path.Combine (installDir, ".git");
      Assert.IsTrue (Directory.Exists (indexGitDir), "The GrowSense index .git folder wasn't found.");
    }
    // TODO: Find a faster way of setting up a fake installation instead of doing an actual install
    public void PrepareGrowSenseInstallation (string branch, string growSenseInstallDir, string arduinoPlugAndPlayInstallDir)
    {
      Directory.CreateDirectory (growSenseInstallDir);
      
      Directory.SetCurrentDirectory (growSenseInstallDir);

      var scriptName = "install-plug-and-play-from-web.sh";

      EnableMocking (arduinoPlugAndPlayInstallDir, "systemctl");

      var random = new Random ();

      var wifiName = "MyWifi" + random.Next (99);
      var wifiPass = "MyPass" + random.Next (99);

      var mqttHost = "10.0.0." + random.Next (99);
      var mqttUser = "user" + random.Next (99);
      var mqttPass = "pass" + random.Next (99);
      var mqttPort = "18" + random.Next (99);

      var smtpServer = "mail.server" + random.Next (9) + ".com";
      var emailAddress = "user" + random.Next (9) + "@server.com";
      
      var cmd = "bash " + scriptName + " " + branch + " " + growSenseInstallDir + " " + wifiName + " " + wifiPass + " " + mqttHost + " " + mqttUser + " " + mqttPass + " " + mqttPort + " " + smtpServer + " " + emailAddress;

      Console.WriteLine ("Command:");
      Console.WriteLine ("  " + cmd);

      var starter = GetTestProcessStarter (growSenseInstallDir);
      
      PullFileFromProject ("scripts-web/install-plug-and-play-from-web.sh", true);

      Console.WriteLine ("");
      Console.WriteLine ("Performing install from web test...");
      Console.WriteLine ("");

      starter.RunBash (cmd);

      Console.Write (starter.Starter.Output);

      Assert.IsFalse (starter.Starter.IsError, "An error occurred.");

      Console.WriteLine ("Checking that the ArduinoPlugAndPlay service file was installed.");
      var expectedServiceFile = Path.Combine (arduinoPlugAndPlayInstallDir, "mock/services/arduino-plug-and-play.service");
      Assert.IsTrue (File.Exists (expectedServiceFile), "Plug and play service file not found.");

      Console.WriteLine ("Checking that GrowSense index was installed.");
      var indexGitDir = Path.Combine (growSenseInstallDir, ".git");
      Assert.IsTrue (Directory.Exists (indexGitDir), "The GrowSense index .git folder wasn't found.");

    }
  }
}

