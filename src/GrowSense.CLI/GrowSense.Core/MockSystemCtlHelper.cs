using System;
using System.IO;
namespace GrowSense.Core
{
  public class MockSystemCtlHelper : SystemCtlHelper
  {
    public MockSystemCtlHelper(CLIContext context) : base(context)
    {
    }

    public override string Run(string command)
    {
      return "  [mock] systemctl " + command;
    }

    public override bool Exists(string serviceName)
    {
      return File.Exists(GetServiceFilePath(serviceName));
    }

    public override string Status(string serviceName)
    {
      return "  [mock] systemctl status " + serviceName + "  Status: active (running)";
    }

    public override string GetServiceFilePath(string serviceName)
    {
      return "mock/services/" + serviceName.Replace(".service", "") + ".service";
    }
  }
}
