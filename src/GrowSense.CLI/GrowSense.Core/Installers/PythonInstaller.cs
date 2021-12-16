﻿using System;
namespace GrowSense.Core.Installers
{
  public class PythonInstaller
  {
    public AptHelper Apt = new AptHelper();
    public ProcessStarter Starter = new ProcessStarter();

    public string PythonName = "python3";

    public string[] Packages = new string[]{
    //"python",
    //"python-pip",
    //"python-setuptools",
    //"python-distutils",
      "python3",
      "python3-distutils",
      "python3-setuptools",
      "python3-serial",
      "python3-venv",
      "python3-pip"
    };

    public string[] Modules = new string[]{
    //"ensurepip",
    //"setuptools"//,
    //"wheel"
    };
    

    public string[] OtherCommands = new string[]{
    //"alias python3=/usr/bin/python3.8",
    "whereis python3",
    "python3 -m ensurepip"
    //"python3 -m pip install --upgrade requests"//,
    //"pip3 install --upgrade requests"
    //"export LC_ALL=C.UTF-8 && export LANG=C.UTF-8"
    };
    
    public PythonInstaller()
    {
    }

    public void Install()
    {
      //Console.WriteLine("");
      Console.WriteLine("Installing python...");
      
      Apt.Install(Packages);

      InstallModules(Modules);

      foreach (var command in OtherCommands)
      {
        Console.WriteLine("  Executing command: " + command);
        Starter.StartBash(command);
      }

      Console.WriteLine(Starter.Output);

      Starter.OutputBuilder.Clear();

      Console.WriteLine("Finished installing python");
      //Console.WriteLine("");
    }

    public void InstallModules(params string[] modules)
    {
      foreach (var module in modules)
        InstallModule(module);
    }

    public void InstallModule(string moduleName)
    {
      Console.WriteLine("Installing python module: " + moduleName);
      Starter.StartBash(PythonName + " -m " + moduleName);
      Console.WriteLine(Starter.Output);
      if (Starter.Output.IndexOf("no module named") > -1)
        throw new Exception("[python3] No module named: " + moduleName);
      Starter.OutputBuilder.Clear();
      
    }
  }
}

