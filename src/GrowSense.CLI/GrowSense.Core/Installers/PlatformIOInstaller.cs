using System;
namespace GrowSense.Core.Installers
{
  public class PlatformIOInstaller : BaseInstaller
  {
    public ProcessStarter Starter = new ProcessStarter();
    public PythonInstaller Python = new PythonInstaller();
    
    public PlatformIOInstaller()
    {
    }

    public void Install()
    {
    Console.WriteLine("");


      if (!IsInstalled())
      {
        Console.WriteLine("Installing platform.io...");

        //Console.WriteLine("  Installing/upgrading pip extras...");
        //Starter.StartBash(Python.PythonName + " -m pip install --ignore-installed --upgrade setuptools wheel");

        Console.WriteLine("  Installing platformio via pip3");

//Starter.StartBash("export LC_ALL=C.UTF-8; export LANG=C.UTF-8; sudo " + Python.PythonName + " -m pip install --ignore-installed -U platformio");
        Starter.StartBash(Python.PythonName + " -m pip install --ignore-installed -U platformio");
        //Starter.StartBash("sudo python3 -c \"$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py\")");

        //Console.WriteLine(Starter.Output);
        Starter.OutputBuilder.Clear();

        if (!IsInstalled())
          throw new Exception("Error: Failed to install platform.io.");

        Console.WriteLine("Finished installing platform.io");
        Console.WriteLine("");
      }
      else
        Console.WriteLine("Platform.io is already installed.");
        
    }

    public bool IsInstalled()
    {
      var starter = new ProcessStarter();
      starter.EnableErrorCheckingByTextMatching = false;
      starter.ThrowExceptionOnError = false;

// TODO: Disabled because pio is not installed via apt
      //if (Apt.IsPackageInstalled("pio"))
      //  return true;
      
      starter.StartBash("pio --version");

      var output = starter.Output;

      if (output.IndexOf("command not found") > -1)
        return false;
      else if (output.IndexOf("PlatformIO Core, version") == -1)
        return false;
      else if (starter.IsError)
        return false;
      else
        return true;
    }
  }
}
