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
      return File.Exists("mock/services/" + serviceName + ".service");
    }

    public override string Status(string serviceName)
    {
      return "  [mock] systemctl status " + serviceName + "\nStatus: active (running)";
    }
  }
}
