using System;
using System.IO;

namespace GrowSense.Core
{
    public class UpgradeLauncher
    {
        public CLIContext Context { get; set; }

        public ProcessStarter Starter { get; set; }

        public UpgradeLauncher(CLIContext context)
        {
            Context = context;
            Starter = new ProcessStarter();
        }

        /// <summary>
        /// Upgrades the installer, then uses it to upgrade the GrowSense system.
        /// </summary>
        public void Upgrade()
        {
            Console.WriteLine("Launching upgrade...");
            var sudo = "sudo";

            DeleteObsoleteInstallerZip(); // This is necessary otherwise it will get reused

            var upgradeCommand = "wget --no-cache -O - https://raw.githubusercontent.com/GrowSense/Installer/" + Context.Settings.Branch + "/scripts-download/download-installer.sh | bash -s -- upgrade --branch=" + Context.Settings.Branch + " --to=" + Context.ParentDirectory;

            if (Context.Settings.IsMockDocker || Context.Settings.IsMockSystemCtl)
                upgradeCommand += " --test=true";

            if (!String.IsNullOrEmpty(Context.Settings.GitHubUsername) && !String.IsNullOrEmpty(Context.Settings.GitHubToken))
                upgradeCommand += String.Format(" --github-username={0} --github-token={1}", Context.Settings.GitHubUsername, Context.Settings.GitHubToken);

            Console.WriteLine("  Command: " + upgradeCommand);

            Starter.StartBash(upgradeCommand);
        }

        public void DeleteObsoleteInstallerZip()
        {
            var obsoleteInstallerZip = Context.ParentDirectory + "/Installer/GrowSenseInstaller.zip";

            if (File.Exists(obsoleteInstallerZip))
                File.Delete(obsoleteInstallerZip);
        }
    }
}
