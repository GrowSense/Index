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
  }
}
