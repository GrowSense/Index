﻿using System;
using System.IO;
namespace GrowSense.Core
{
  public class SystemCtlHelper
  {
    public CLIContext Context;
    public ProcessStarter Starter;
    
    public SystemCtlHelper(CLIContext context)
    {
      Context = context;
      Starter = new ProcessStarter(Context.IndexDirectory);
    }

    public virtual string Status(string serviceName)
    {
      return Run("status " + serviceName);
    }

    public virtual bool Exists(string serviceName)
    {
      //var isMockSystemCtl = IsMockSystemCtl();

      var servicePath = "/lib/systemd/system/" + serviceName.Replace(".service", "") + ".service";
      
      //if (File.Exists(mockSystemctlFile))
      //  servicePath = Context.IndexDirectory + "/mock/services/" + serviceName.Replace(".service", "") + ".service";

      return File.Exists(servicePath);
    }

    public virtual string Run(string command)
    {
      if (Context.Settings.IsMockSystemCtl)
      {
      var output = "[mock] systemctl " + command;
        Console.WriteLine(output);
        return output;
      }
      else
      {
        Starter.StartBash("systemctl " + command);
        return Starter.Output;
      }
    }
  }
}
