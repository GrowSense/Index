using System;
namespace GrowSense.Core.Installers
{
  public class MonoInstaller
  {
    public AptHelper Apt = new AptHelper();

    public string[] Packages = new string[]{
    "tzdata",
    "mono-devel",
    "mono-complete",
    "ca-certificates-mono",
    "mono-xsp4"
    };
    
    public MonoInstaller()
    {
    }

    public void Install()
    {
      Apt.Install(Packages);
    }
  }
}
