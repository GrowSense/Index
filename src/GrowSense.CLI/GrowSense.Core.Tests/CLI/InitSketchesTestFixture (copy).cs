using System;
using NUnit.Framework;
using System.Threading;
namespace GrowSense.Core.Tests.CLI
{
[TestFixture]
  public class PostInstallerTestFixture : BaseTestFixture
  {
  [Test]
    public void Test()
    {
      MoveToTemporaryDirectory();

      var starter = new ProcessStarter();
      var dockerImage = "10.0.0.101:5000/ubuntu-mono";

      var finishedMessage = "Test finished!";

      //Console.WriteLine(ProjectDirectory);
      //starter.Start("docker run hello-world");

      var dockerName = "test" + new Random().Next(1000, 9000);
      
       
      starter.Start("docker run -d -v " + ProjectDirectory + ":/usr/local/GrowSense/Index --name " + dockerName + " " + dockerImage + " /bin/bash -c \"cd /usr/local/GrowSense/Index && sh gs.sh post-install; echo '" + finishedMessage + "'\"");
      //starter.Start("docker run -d -v " + ProjectDirectory + ":/usr/local/GrowSense/Index --name " + dockerName + " " + dockerImage + " --entrypoint=/bin/bash echo hello");

     // WaitForTestToFinish(dockerName, finishedMessage);

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
