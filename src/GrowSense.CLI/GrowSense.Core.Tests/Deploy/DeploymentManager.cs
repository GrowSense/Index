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

    public void WaitForUnlock()
    {
      Ssh.Execute("bash wait-for-unlock.sh || echo \"Failed to wait for unlock. The script might not exist so it can be skipped\"");
    }

  }
}
