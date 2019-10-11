using System;

namespace GrowSense.Index.Tests
{
    public class BranchDetector
    {
        public string Branch { get; set; }

        public BranchDetector ()
        {
            Initialize ();
        }

        public void Initialize ()
        {
            var cmd = "/bin/bash -c \"echo $(git branch | sed -n -e 's/^\\* \\(.*\\)/\\1/p')\"";
            var starter = new ProcessStarter ();
            starter.WriteOutputToConsole = false;
            starter.Start (cmd);
            Branch = starter.Output.Trim ();
        }
    }
}

