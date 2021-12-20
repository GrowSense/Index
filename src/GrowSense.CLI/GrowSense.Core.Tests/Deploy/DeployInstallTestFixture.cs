using System;
using NUnit.Framework;
using Newtonsoft.Json;
using System.IO;
using GrowSense.Core.Tools;
namespace GrowSense.Core.Tests.Deploy
{
  [TestFixture(Category = "DeployInstall")]
  public class DeployInstallTestFixture : BaseTestFixture
  {
    [Test]
    public void Test_DeployInstall()
    {
      Console.WriteLine("Testing deploy install...");

      //var starter = new ProcessStarter();
      //starter.Start("./detect-deployment-details.sh");

      var deployment = GetDeploymentInfo();


      Console.WriteLine("  Host: " + deployment.Ssh.Host);
      Console.WriteLine("  SSH Username: " + deployment.Ssh.Username);
      Console.WriteLine("  SSH Password: hidden (length " + (String.IsNullOrEmpty(deployment.Ssh.Password) ? deployment.Ssh.Password.Length : 0) + ")");
      Console.WriteLine("  SSH Port: " + deployment.Ssh.Port);
      
      
      var version = File.ReadAllText(ProjectDirectory + "/full-version.txt").Trim();
      var branch = new BranchDetector(ProjectDirectory).Branch;

      CreateAndPushRelease(deployment);
      
      var manager = new DeploymentManager(deployment, branch, version);

      var ssh = new SshHelper(deployment.Ssh);
      ssh.UseSshPass = true;
      

      if (ssh.DirectoryExists("/usr/local/GrowSense/Index"))
      {
        manager.WaitForUnlock();
      }

      manager.Ssh.Execute("sudo echo hello > /usr/local/GrowSense/Installer/hello.txt");

      manager.DownloadAndLaunchInstaller();

      manager.SetConfigValues();
    }

    public DeploymentInfo GetDeploymentInfo()
    {
      Console.WriteLine("  Getting deployment info...");
      
      if (Directory.Exists("deployments"))
        return GetDeploymentInfoFromSecurityFile();
      else
        return GetDeploymentInfoFromEnvironmentVariables();
    }

    public DeploymentInfo GetDeploymentInfoFromSecurityFile()
    {
      Console.WriteLine("    From security file...");
      var filePath = ProjectDirectory + "/deployments/dev.json.security";
      var deployment = JsonConvert.DeserializeObject<DeploymentInfo>(File.ReadAllText(filePath));
      return deployment;
    }

    public DeploymentInfo GetDeploymentInfoFromEnvironmentVariables()
    {
      Console.WriteLine("    From environment variables...");
      
      var deployment = new DeploymentInfo();
      //var branch = 
      //deployment.Name = "devstaging";
      deployment.Ssh = new SshTarget();
      deployment.Ssh.Host = Environment.GetEnvironmentVariable("INSTALL_HOST");
      deployment.Ssh.Username = Environment.GetEnvironmentVariable("INSTALL_SSH_USERNAME");
      deployment.Ssh.Password = Environment.GetEnvironmentVariable("INSTALL_SSH_PASSWORD");
      deployment.Ssh.Port = Convert.ToInt32(Environment.GetEnvironmentVariable("INSTALL_SSH_PORT"));

      deployment.Mqtt = new MqttTarget();
      deployment.Mqtt.Host = "";
      deployment.Mqtt.Username = "";
      deployment.Mqtt.Password = "";
      deployment.Mqtt.Port = 1883;

      return deployment;
    }

    public string GetEnvironmentVariable(string variableName)
    {

      var value = Environment.GetEnvironmentVariable(variableName);

      if (String.IsNullOrEmpty(value))
        throw new ArgumentException("No environment variable found for: " + variableName);

      return value;
    
    }

    public void CreateAndPushRelease(DeploymentInfo deployment)
    {
      var starter = new ProcessStarter(ProjectDirectory);

      starter.StartBash("bash create-release-zip.sh");

      var releaseFile = Directory.GetFiles(ProjectDirectory + "/releases/")[0];

      var cmd = "sshpass -p " + deployment.Ssh.Password + " scp " + releaseFile + " " + deployment.Ssh.Username + "@" + deployment.Ssh.Host + ":/usr/local/GrowSense/Installer/GrowSenseIndex.zip";
      starter.StartBash(cmd);
    }
  }
}
