using System;
using NUnit.Framework;
using System.IO;

namespace GrowSense.Index.Tests.Install.Web
{
    [TestFixture (Category = "InstallFromWeb")]
    public class AddRemoteIndexFromWebTestFixture : BaseTestFixture
    {
        [Test]
        public void Test_AddRemoteIndexFromWeb ()
        {
            MoveToTemporaryDirectory ();

            Console.WriteLine ("");
            Console.WriteLine ("Preparing add remote index from web test...");
            Console.WriteLine ("");

            var scriptName = "add-remote-index-from-web.sh";

            PullFileFromProject ("scripts-web/" + scriptName, true);

            var scriptPath = Path.GetFullPath (scriptName);

            var branchDetector = new BranchDetector ();
            var branch = branchDetector.Branch;

            var installDir = Path.Combine (TemporaryDirectory, "installation");

            Directory.CreateDirectory (installDir);

            Directory.SetCurrentDirectory (installDir);

            PullFileFromProject ("add-remote-index.sh");

            var random = new Random ();
            var remoteName = "remote" + random.Next (9);
            var remoteHost = "10.0.0." + random.Next (99);
            var remoteUser = "user" + random.Next (99);
            var remotePass = "pass" + random.Next (99);

            var cmd = "bash " + scriptPath + " " + branch + " " + installDir + " " + remoteName + " " + remoteHost + " " + remoteUser + " " + remotePass;

            Console.WriteLine ("Command:");
            Console.WriteLine ("  " + cmd);

            var starter = new ProcessStarter ();

            Console.WriteLine ("");
            Console.WriteLine ("Performing test...");
            Console.WriteLine ("");

            starter.Start (cmd);

            Console.Write (starter.Output);

            Assert.IsFalse (starter.IsError, "An error occurred.");

            AssertRemoteIndexFile (installDir, remoteName, "host", remoteHost);
            AssertRemoteIndexFile (installDir, remoteName, "username", remoteUser);
            AssertRemoteIndexFile (installDir, remoteName, "password", remotePass);
        }

        public void AssertRemoteIndexFile (string installDir, string remoteName, string key, string value)
        {
            Console.WriteLine ("Checking for security file...");

            var expectedSecurityfile = Path.Combine (Path.Combine (TemporaryDirectory, installDir), "remote/" + remoteName + "/" + key + ".security");

            Console.WriteLine ("  " + expectedSecurityfile);

            Assert.IsTrue (File.Exists (expectedSecurityfile), key + ".security file not found.");

            var fileContent = File.ReadAllText (expectedSecurityfile).Trim ();
            Assert.AreEqual (value, fileContent, "The content of the security file wasn't set properly: " + key);
        }
    }
}

