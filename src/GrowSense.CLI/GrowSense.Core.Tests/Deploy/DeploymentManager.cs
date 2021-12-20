using System;
using GrowSense.Core.Tools;
namespace GrowSense.Core.Tests.Deploy
{
  public class DeploymentManager
  {
    public DeploymentInfo Deployment;
    public SshHelper Ssh;
    public string Version;
    public string Branch;

    
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
      
      var isInstalled = Ssh.DirectoryExists(Ssh.StartDirectory);
      
      Console.WriteLine("  Is installed: " + isInstalled);
      Console.WriteLine("");
      
      Ssh.MoveToStartDirectory = true;
      
      return isInstalled;
    }
    
    public void DownloadAndLaunchInstaller()
    {
      Console.WriteLine("");
      Console.WriteLine("Downloading and launching installer...");

      var installCommand = "sudo wget --no-cache -O - https://raw.githubusercontent.com/GrowSense/Installer/" + Branch + "/scripts-download/download-installer.sh | sudo bash -s -- --branch=" + Branch + " --to=/usr/local/ --enable-download=false --allow-skip-download=true --version=" + Version;
      Ssh.Execute(installCommand);      
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

      Ssh.Execute(configCommand);
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
      Ssh.Execute("bash wait-for-unlock.sh || echo \"Failed to wait for unlock. The script might not exist so it can be skipped\"");
    }

  }
}
