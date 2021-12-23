using System;
namespace GrowSense.Core.Tools.Mock
{
  public class MockDockerHelper : DockerHelper
  {
    public bool MockIsRunning = true;
    
    public MockDockerHelper(CLIContext context) : base(context)
    {
    }

    public override bool IsRunning(string containerName)
    {
      return MockIsRunning;
    }

    public override string Execute(string runCmd)
    {
      var output = "  [mock] docker " + runCmd;
      Console.WriteLine(output);
      return output;
    }

    public override string Logs(string containerName)
    {
      var output = "  [mock] docker logs:  " + containerName;
      Console.WriteLine(output);
      return output;
    }

    public override string Processes()
    {
      var output = "  [mock] docker ps";
      Console.WriteLine(output);
      return output;
    }

    public override void Remove(string containerName, bool force)
    {
      var output = "  [mock] docker rm " + containerName;
      Console.WriteLine(output);
      //return output;
    }
  }
}
