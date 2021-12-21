using System;
using System.Threading;
using NUnit.Framework;
using System.IO;
namespace GrowSense.Core.Tests.CLI
{
  public class PostInstallerTestHelper
  {
    public string DockerRegistryHost = "10.0.0.101:5000";
    public string DockerImage = "ubuntu-mono";

    public string ProjectDirectory;
    public string WorkingDirectory;
  
    public PostInstallerTestHelper(string projectDirectory, string workingDirectory)
    {
      ProjectDirectory = projectDirectory;
      WorkingDirectory = workingDirectory;
    }

    public void Test()
    {
    
      var starter = new ProcessStarter();

      var finishedMessage = "Test finished!";

      //Console.WriteLine(ProjectDirectory);
      //starter.Start("docker run hello-world");

      var dockerName = "test" + new Random().Next(1000, 9000);

      var version = File.ReadAllText(ProjectDirectory + "/full-version.txt").Trim();


      var mode = "Release";

#if DEBUG
mode = "Debug";
#endif

      var commands = new string[]{
       "sh gs.sh post-install --mock-systemctl=true --mode=" + mode + " --version=" + version,
       //"bash build-all.sh",
       //"sh gs.sh verify --mock-systemctl=true --mode=" + mode
      };

      var commandsString = String.Join(" && ", commands);

      var fullDockerImage = DockerRegistryHost + "/" + DockerImage;

      starter.Start("docker pull " + fullDockerImage);
       
      starter.Start("docker run --restart=no -d --privileged -v " + ProjectDirectory + ":/usr/local/GrowSense/Index  --tmpfs /tmp --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /run/systemd/system:/run/systemd/system -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket -v /var/run/docker.sock:/var/run/docker.sock --name " + dockerName + " " + fullDockerImage + " /bin/bash -c \"cd /usr/local/GrowSense/Index && " + commandsString + " && echo '" + finishedMessage + "' || exit 1\"");
      //starter.Start("docker run -d -v " + ProjectDirectory + ":/usr/local /GrowSense/Index --name " + dockerName + " " + dockerImage + " --entrypoint=/bin/bash echo hello");

      // WaitForTestToFinish(dockerName, finishedMessage);

      Assert.IsFalse(starter.IsError, "An error occurred.");

      var output = GetDockerOutput(dockerName, finishedMessage);
  
      Assert.IsFalse(starter.Output.ToLower().IndexOf("exception") > -1, "An exception was thrown.");
    }
    
    
    public string GetDockerOutput(string name, string finishedMessage)
    {
      WaitForTestToFinish(name, finishedMessage);
      
      var newStarter = new ProcessStarter();
      newStarter.Start("docker logs " + name);
      var output = newStarter.Output;

      return output;
    }

    public void WaitForTestToFinish(string name, string finishedMessage)
    {
      var isFinished = false;
      while (!isFinished)
      {
        var starter = new ProcessStarter();
        starter.Start("docker logs " + name);
        var output = starter.Output;

        if (output.IndexOf(finishedMessage) > -1)
          isFinished = true;
        else
          Thread.Sleep(2000);
      }
    }
  }
}
