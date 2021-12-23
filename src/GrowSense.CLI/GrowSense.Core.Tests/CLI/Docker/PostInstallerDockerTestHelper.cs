using System;
using System.Threading;
using NUnit.Framework;
using System.IO;
using GrowSense.Core.Tools;
namespace GrowSense.Core.Tests.CLI.Docker
{
  public class PostInstallerDockerTestHelper
  {
    public string DockerRegistryHost = "10.0.0.101:5000";
    public string DockerImage = "ubuntu-mono";

    public string ProjectDirectory;
    public string WorkingDirectory;
  
    public PostInstallerDockerTestHelper(string projectDirectory, string workingDirectory)
    {
      ProjectDirectory = projectDirectory;
      WorkingDirectory = workingDirectory;
    }

    public void Test()
    {    
      var starter = new ProcessStarter();
      starter.EnableErrorCheckingByTextMatching = false;

      var dockerName = "test" + new Random().Next(1000, 9000);

      var version = File.ReadAllText(ProjectDirectory + "/full-version.txt").Trim();
      
      var mode = "Release";
      #if DEBUG
      mode = "Debug";
      #endif

      var commands = new string[]{
       "bash gs.sh post-install --mock-systemctl=true --mock-docker=true --mode=" + mode + " --version=" + version//,
       //"bash build-all.sh",
       //"sh gs.sh verify --mock-systemctl=true --mode=" + mode
      };

      var commandsString = String.Join(" && ", commands);

      var fullDockerImage = DockerRegistryHost + "/" + DockerImage;

      Console.WriteLine("Checking prerequisites...");
      if (!File.Exists(ProjectDirectory + "/gs.sh"))
        Assert.Fail("gs.sh script not found at: " + ProjectDirectory + "/gs.sh");

      Console.WriteLine("");
      Console.WriteLine("Pulling latest docker image...");

      //var docker = new DockerHelper(context);

      starter.Start("docker pull " + fullDockerImage);


      var finishedMessage = "Test finished!";

      Console.WriteLine("");
      Console.WriteLine("Launching docker container and running commands...");
      
      var command = "docker run --restart=no --privileged -v " + ProjectDirectory + ":/usr/local/GrowSense/Index  --tmpfs /tmp --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /run/systemd/system:/run/systemd/system -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket -v /var/run/docker.sock:/var/run/docker.sock --name " + dockerName + " " + fullDockerImage + " /bin/bash -c \"cd /usr/local/GrowSense/Index && ls && " + commandsString + " && echo '" + finishedMessage + "' || exit 1\"";
      Console.WriteLine("  " + command);
      starter.Start(command);
      //starter.Start("docker run -d -v " + ProjectDirectory + ":/usr/local /GrowSense/Index --name " + dockerName + " " + dockerImage + " --entrypoint=/bin/bash echo hello");

      // WaitForTestToFinish(dockerName, finishedMessage);

      Console.WriteLine("");
      Console.WriteLine("Checking results...");

      Assert.IsFalse(starter.IsError, "An error occurred.");

      var output = GetDockerOutput(dockerName, finishedMessage);
  
      // TODO: Disabled because it causes false positive test fails
      // Assert.IsFalse(starter.Output.ToLower().IndexOf("exception") > -1, "An exception was thrown.");
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
