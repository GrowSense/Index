using System;
using System.IO;
namespace GrowSense.Core.Verifiers
{
  public class ArduinoPlugAndPlayVerifier : BaseVerifier
  {
    public ArduinoPlugAndPlayVerifier(CLIContext context) : base(context)
    {
    }

    public void Verify()
    {
      VerifyIsInstalled();
      
      VerifyServiceIsRunning();
    }

    public void VerifyIsInstalled()
    {
      var installPath = GetInstallPath();

      AssertDirectoryExists(installPath);
    }

    public void VerifyServiceIsRunning()
    {
    var mockSystemctlFile = GetInstallPath() + "/is-mock-systemctl.txt";

      if (!File.Exists(mockSystemctlFile))
      {
        var cmd = "systemctl status arduino-plug-and-play.service";

        Starter.StartBash(cmd);

        var output = Starter.Output;

        AssertTextContains(output, "active (running)", "Arduino plug and play service is not running.");
      }
    }

    public string GetInstallPath()
    {
      return Path.Combine(Context.WorkingDirectory, "../../ArduinoPlugAndPlay");
    }
  }
}
