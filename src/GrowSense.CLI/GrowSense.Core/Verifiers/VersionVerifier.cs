using System;
using System.IO;
namespace GrowSense.Core.Verifiers
{
  public class VersionVerifier
  {
    public CLIContext Context;
    
    public VersionVerifier(CLIContext context)
    {
      Context = context;
    }

    public void Verify()
    {
     var targetVersion = Context.Settings.Version;

      var detectedVersion = File.ReadAllText(Context.IndexDirectory + "/full-version.txt").Trim();

      if (targetVersion != detectedVersion)
        throw new Exception("Incorrect version. Target: " + targetVersion + "; Detected: " + detectedVersion);
    }
  }
}
