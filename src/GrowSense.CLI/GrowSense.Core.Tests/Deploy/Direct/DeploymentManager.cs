﻿using System;
using GrowSense.Core.Tools;
using System.IO;
namespace GrowSense.Core.Tests.Deploy
{
    public class DeploymentManager
    {
        public DeploymentInfo Deployment;
        public SshHelper Ssh;
        public string Version;
        public string Branch;
        public bool EnableDownload = true;
        public bool AllowSkipDownload = false;


        public DeploymentManager(DeploymentInfo deployment, string branch, string version)
        {
            Deployment = deployment;
            Ssh = new SshHelper(deployment.Ssh);
            Ssh.StartDirectory = "/usr/local/GrowSense/Index";
            Version = version;
            Branch = branch;
        }

        public bool IsInstalledOnTarget()
        {
            Console.WriteLine("Checking if GrowSense is installed on target host...");

            Ssh.MoveToStartDirectory = false;

            var indexDirExists = Ssh.DirectoryExists(Ssh.StartDirectory);

            Ssh.MoveToStartDirectory = true;

            var gsScriptFileExists = Ssh.FileExists("gs.sh");

            var isInstalled = indexDirExists && gsScriptFileExists;

            Console.WriteLine("  Is installed: " + isInstalled);
            Console.WriteLine("");

            return isInstalled;
        }

        public void DownloadAndLaunchInstall()
        {
            Console.WriteLine("");
            Console.WriteLine("Downloading installer and launching install (via script)...");

            var installCommand = "sudo wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Installer/" + Branch + "/scripts-download/download-installer.sh | sudo bash -s -- install --branch=" + Branch + " --to=/usr/local/ --enable-download=" + EnableDownload + " --allow-skip-download=" + AllowSkipDownload + " --version=" + Version;

            Ssh.Starter.EnableErrorCheckingByTextMatching = false;
            Ssh.Execute(installCommand);
            Ssh.Starter.EnableErrorCheckingByTextMatching = true;
        }

        public void DownloadAndLaunchUpgrade()
        {
            Console.WriteLine("");
            Console.WriteLine("Downloading installer and launching upgrade (via script)...");

            var installCommand = "sudo wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Installer/" + Branch + "/scripts-download/download-installer.sh | sudo bash -s -- upgrade --branch=" + Branch + " --to=/usr/local/ --enable-download=" + EnableDownload + " --allow-skip-download=" + AllowSkipDownload + " --version=" + Version;
            Ssh.Starter.EnableErrorCheckingByTextMatching = false;
            Ssh.Execute(installCommand);
            Ssh.Starter.EnableErrorCheckingByTextMatching = true;
        }

        public void SetConfigValues()
        {
            Console.WriteLine("");
            Console.WriteLine("  Setting configuration values...");

            var mode = "Release";
#if DEBUG
            mode = "Debug";
#endif

            var configCommand = "bash gs.sh config" +
            " --mode=" + mode +
            " --username=" + Deployment.Username +
            " --password=" + Deployment.Password +
            " --wifi-name=''" +
            " --wifi-password=''" +
            " --mqtt-host=" + Deployment.Mqtt.Host +
            " --mqtt-username=" + Deployment.Mqtt.Username +
            " --mqtt-password=" + Deployment.Mqtt.Password +
            " --mqtt-port=" + Deployment.Mqtt.Port +
            " --smtp-server=''" +
            " --email=''" +
            " --smtp-username=''" +
            " --smtp-password=''" +
            " --smtp-port=25";

            Ssh.Starter.EnableErrorCheckingByTextMatching = false;
            Ssh.Execute(configCommand);
            Ssh.Starter.EnableErrorCheckingByTextMatching = true;
        }

        public void AddRemotes()
        {
            Console.WriteLine("Adding GrowSense remotes to target host...");

            foreach (var remote in Deployment.Remotes)
            {
                Console.WriteLine("  Remote: " + remote.Name);
                Console.WriteLine("    Host: " + remote.Ssh.Host);

                if (Ssh.DirectoryExists("/usr/local/GrowSense/Index/remote/" + remote.Name))
                {
                    Console.WriteLine("    Deleting existing remote...");
                    Ssh.DeleteDirectory("/usr/local/GrowSense/Index/remote/" + remote.Name);
                }

                Console.WriteLine("    Adding remote");
                var command = "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/" + Branch + "/scripts-web/add-remote-index-from-web.sh | bash -s -- " + Branch + " ? " + remote.Name + " " + remote.Ssh.Host + " " + remote.Ssh.Username + " " + remote.Ssh.Password + " " + remote.Ssh.Port;
                Ssh.Execute(command);

                Console.WriteLine("    Verifying remote was added...");

                if (!Ssh.DirectoryExists("/usr/local/GrowSense/Index/remote/" + remote.Name))
                    throw new Exception("GrowSense remote '" + remote.Name + "' wasn't added successfully.");
            }
        }

        public void RenameDevice(string currentName, string newName)
        {
            // TODO: Make it possible to either skip error or fail on error
            Ssh.Execute("bash rename-device.sh " + currentName + " " + newName + " || echo \"Failed to rename device. It may not exist.\"");
        }

        public void WaitForUnlock()
        {
            Ssh.Execute("if [ -f wait-for-unlock.sh ]; then bash wait-for-unlock.sh; fi", true, false);
        }

        public void CreateReleaseZipAndPushToHost(string projectDirectory, DeploymentInfo deployment, SshHelper ssh)
        {
            Console.WriteLine("");
            Console.WriteLine("Creating release zip...");
            var starter = new ProcessStarter(projectDirectory);

            starter.StartBash("bash create-release-zip.sh");

            starter.OutputBuilder.Clear();


            var sourceReleaseFilePath = Directory.GetFiles(projectDirectory + "/releases/")[0];

            var destinationReleaseFilePath = "/usr/local/GrowSense/Installer/" + Path.GetFileName(sourceReleaseFilePath);

            ssh.CopyFileTo(sourceReleaseFilePath, destinationReleaseFilePath);
        }

        public void AssertStatus(string version)
        {
            var output = Ssh.Execute("bash gs.sh status");

            var versionMatches = output.Contains("Version: " + version);

            if (!versionMatches)
                throw new Exception("Incorrect version detected. Expected '" + version + "'.");
        }
    }
}