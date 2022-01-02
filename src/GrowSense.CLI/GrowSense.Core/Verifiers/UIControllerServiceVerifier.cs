using System;
using GrowSense.Core.Tools;
using System.Threading;
using GrowSense.Core.Devices;
namespace GrowSense.Core.Verifiers
{
  public class UIControllerServiceVerifier
  {
    public SystemCtlHelper SystemCtl;
    public CLIContext Context;
    
    public UIControllerServiceVerifier(CLIContext context)
    {
      SystemCtl = new SystemCtlHelper(context);
      Context = context;
    }
    
    public void VerifyDevicesUIControllerServices(DeviceInfo[] devices)
    {
      Console.WriteLine("  Verifying devices UI controller services...");

      foreach (var device in devices)
      {
        Console.WriteLine("    Device: " + device.Name);
        Console.WriteLine("      Board: " + device.Board);
        Console.WriteLine("      Host: " + device.Host);
        Console.WriteLine("      Group: " + device.Group);
      
        var isOnThisMachine = device.Host == Context.Settings.HostName;

        var isUSBConnected = device.Board == "nano" || device.Board == "uno";

        var isNotUIDevice = device.Group != "ui";

        var requiresUIController = isOnThisMachine && isUSBConnected && isNotUIDevice;

        Console.WriteLine("      Requires UI controller: " + requiresUIController);

        if (requiresUIController)
          Verify(device.Name);
      }

      Console.WriteLine("  Finished verifying devices UI controller services.");
    }

    public void Verify(string deviceName)
    {
      Console.WriteLine("Verifying UI controller service is active...");
      Console.WriteLine("  Device name: " + deviceName);

      var attempt = 1;
      var isFinished = false;

      var status = SystemCtlServiceStatus.NotSet;

      var serviceName = "growsense-ui-1602-" + deviceName + ".service";

      while (!isFinished)
      {
        status = SystemCtl.Status(serviceName);

        if (attempt > 10 || status == SystemCtlServiceStatus.Active)
          isFinished = true;
        else
        {
          attempt++;
          
          Console.WriteLine("Failed attempt. Trying again...");
          Console.WriteLine("  Attempt: " + attempt);

          Thread.Sleep(1000);
        }
      }

      if (status != SystemCtlServiceStatus.Active)
      {
        throw new Exception("UI controller service is not active for device: " + deviceName);
      }
      else
      {
        Console.WriteLine("  UI controller service is active.");
      }


      Console.WriteLine("Finished verifying UI controller service is active.");
    }
  }
}
