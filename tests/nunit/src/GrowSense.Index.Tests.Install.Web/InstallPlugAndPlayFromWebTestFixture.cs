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
      var branch = GetBranch ();
      
      MoveToTemporaryDirectory ();

      Console.WriteLine ("");
      Console.WriteLine ("Preparing install from web test...");
      Console.WriteLine ("");

      var scriptName = "install-plug-and-play-from-web.sh";

      var installDir = Path.GetFullPath ("GrowSense/Index");
      
      Directory.CreateDirectory (installDir);

      var pnpInstallDir = Path.GetFullPath ("ArduinoPlugAndPlay");

      EnableMocking (pnpInstallDir, "systemctl");
      
      Directory.SetCurrentDirectory (installDir);
      
      var random = new Random ();

      var wifiName = "MyWifi" + random.Next (99);
      var wifiPass = "MyPass" + random.Next (99);

      var mqttHost = "10.0.0." + random.Next (99);
      var mqttUser = "user" + random.Next (99);
      var mqttPass = "pass" + random.Next (99);
      var mqttPort = "18" + random.Next (99);
      
      var smtpServer = "mail.server" + random.Next (9) + ".com";
      var emailAddress = "user" + random.Next (9) + "@server.com";

      var cmd = "bash " + scriptName + " " + branch + " " + installDir + " " + wifiName + " " + wifiPass + " " + mqttHost + " " + mqttUser + " " + mqttPass + " " + mqttPort + " " + smtpServer + " " + emailAddress;

      Console.WriteLine ("Command:");
      Console.WriteLine ("  " + cmd);

      var starter = GetTestProcessStarter (installDir);
      
      PullFileFromProject ("scripts-web/install-plug-and-play-from-web.sh", true);

      Console.WriteLine ("");
      Console.WriteLine ("Performing install from web test...");
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
  }
}

