using System;
namespace GrowSense.Core.Tests
{
  public class BranchDetector
  {
    public string Branch { get; set; }

    public BranchDetector (string projectDirectory)
    {
      Initialize (projectDirectory);
    }

    public void Initialize (string projectDirectory)
    {
      var cmd = "/bin/bash -c \"echo $(git branch | sed -n -e 's/^\\* \\(.*\\)/\\1/p')\"";
      var starter = new ProcessStarter (projectDirectory);
      starter.WriteOutputToConsole = false;
      starter.Start (cmd);
      Branch = starter.Output.Trim ();
    }
  }
}

