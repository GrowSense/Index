using System;
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

            var upgradeCommand = "wget --no-cache -O - https://raw.githubusercontent.com/GrowSense/Installer/" + Context.Settings.Branch + "/scripts-download/download-installer.sh | bash -s -- upgrade --branch=" + Context.Settings.Branch + " --to=" + Context.ParentDirectory;

            if (Context.Settings.IsMockDocker || Context.Settings.IsMockSystemCtl)
                upgradeCommand += " --test=true";

            Console.WriteLine("  Command: " + upgradeCommand);

            Starter.StartBash(upgradeCommand);
        }
    }
}
