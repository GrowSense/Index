using System;

namespace GreenSense.Index.Tests
{
    public class BranchDetector
    {
        public BranchDetector ()
        {
        }

        public string GetBranch ()
        {
            return "dev";
            // TODO: Clean up
            /*var cmd = "/bin/bash -c \"echo ${git branch | sed -n -e 's/^\\* \\(.*\\)/\\1/p'}\"";
            //var cmd = "git branch | sed -n -e 's/^\\* \\(.*\\)/\\1/p'";
            var starter = new ProcessStarter ();
            starter.Start (cmd);
            var branch = starter.Output.Trim ();
            return branch;*/
        }
    }
}

