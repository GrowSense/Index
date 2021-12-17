using System;
namespace GrowSense.Core.Installers
{
  public class PlatformIOInstaller
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

        Console.WriteLine("  Installing/upgrading pip extras...");
        Starter.StartBash(Python.PythonName + " -m pip install --ignore-installed --upgrade setuptools wheel");

        Console.WriteLine("  Installing platformio via pip3");

        Starter.StartBash(Python.PythonName + " -m pip install --ignore-installed -U platformio");

        Console.WriteLine(Starter.Output);
        Starter.OutputBuilder.Clear();

        Console.WriteLine("Finished installing platform.io");
        Console.WriteLine("");
      }
      else
        Console.WriteLine("Platform.io is already installed.");
        
    }

    public bool IsInstalled()
    {
      var starter = new ProcessStarter();
      starter.StartBash("pio --version");

      var output = starter.Output;

      if (output.IndexOf("PlatformIO Core, version") == -1)
        return false;
      else
        return true;
    }
  }
}
