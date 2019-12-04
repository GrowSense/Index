using System;
using NUnit.Framework;
using ArduinoPlugAndPlay;
using ArduinoPlugAndPlay.Tests;
using System.IO;
using System.Threading;

namespace GrowSense.Index.Tests.Integration
{
  [TestFixture (Category = "Hardware")]
  public class PlugAndPlayTestFixture : BaseTestFixture
  {
    public DeviceManager DeviceManager;
    public MockSerialPortWrapper SerialPortWrapper;
    public MockSerialDeviceReaderWriter DeviceReaderWriter;
    public MockDeviceOutputs DeviceOutputs;

    [Test]
    public void Test_PlugAndPlay ()
    {
      Console.WriteLine ("");
      Console.WriteLine ("Preparing add device test...");
      Console.WriteLine ("");
      

      CreateDeviceManager ();
      
      var deviceInfo = CreateDeviceInfo ();

      Console.WriteLine ("");
      Console.WriteLine ("Connecting mock device...");
      Console.WriteLine ("");
      
      SerialPortWrapper.ConnectDevice (deviceInfo.Port);
      DeviceReaderWriter.SetMockOutput (deviceInfo.Port, DeviceOutputs.GetDeviceSerialOutput (deviceInfo));

      Console.WriteLine ("");
      Console.WriteLine ("Performing add device test...");
      Console.WriteLine ("");

      RunLoopToAddDevice (deviceInfo);
      
      Console.WriteLine ("");
      Console.WriteLine ("Disconnecting mock device...");
      Console.WriteLine ("");

      SerialPortWrapper.DisconnectDevice (deviceInfo.Port);

      Console.WriteLine ("");
      Console.WriteLine ("Performing remove device test...");
      Console.WriteLine ("");

      RunLoopToRemoveDevice (deviceInfo);

      ClearLogs ();
    }

    public string ReadPlugAndPlayLogFile ()
    {
      var output = String.Empty;

      var logsDir = Path.Combine (ProjectDirectory, "logs");
      foreach (var logFile in Directory.GetFiles(logsDir))
        output = File.ReadAllText (logFile);

      return output;
    }

    public void CreateDeviceManager ()
    {
    
      SerialPortWrapper = new MockSerialPortWrapper ();
      DeviceReaderWriter = new MockSerialDeviceReaderWriter ();
      DeviceOutputs = new MockDeviceOutputs ();
      
      DeviceManager = new DeviceManager ();
      DeviceManager.SerialPort = SerialPortWrapper;
      DeviceManager.ReaderWriter = DeviceReaderWriter;

      DeviceManager.USBDeviceConnectedCommand = "sh auto-connect-usb-device.sh {BOARD} {FAMILY} {GROUP} {PROJECT} {SCRIPTCODE} {PORT} {DEVICENAME}";
      DeviceManager.USBDeviceDisconnectedCommand = "sh auto-disconnect-usb-device.sh {PORT}";

    }

    public DeviceInfo CreateDeviceInfo ()
    {
      var shortPortName = "ttyUSB0";

      var deviceInfo = new DeviceInfo ();

      deviceInfo.FamilyName = "GrowSense";
      deviceInfo.GroupName = "irrigator";
      deviceInfo.ProjectName = "SoilMoistureSensorCalibratedPump";
      deviceInfo.BoardType = "uno";
      deviceInfo.DeviceName = "irrigator1";
      deviceInfo.ScriptCode = "irrigator";
      deviceInfo.Port = shortPortName;
      
      return deviceInfo;
    }

    public void RunLoopToAddDevice (DeviceInfo deviceInfo)
    {
      ClearLogs ();
      
      DeviceManager.RunLoop ();
      Console.WriteLine (ProjectDirectory);

      var addProcessKey = "add-" + deviceInfo.Port;

      Assert.AreEqual (1, DeviceManager.BackgroundStarter.QueuedProcesses.Count, "Invalid process count.");

      var addProcessWrapper = DeviceManager.BackgroundStarter.QueuedProcesses.Peek ();

      Assert.AreEqual (addProcessKey, addProcessWrapper.Key, "Can't find add device process.");
         
      // Wait while the process runs
      while (addProcessWrapper != null && !addProcessWrapper.HasExited)
        Thread.Sleep (200);
      
      var output = ReadPlugAndPlayLogFile ();

      var deviceCreatedText = "Finished connecting device: " + deviceInfo.DeviceName;
      Assert.IsTrue (output.Contains (deviceCreatedText), "Didn't find the expected output in the log: " + deviceCreatedText);

      Assert.IsFalse (DeviceManager.Starter.IsError, "An error occurred.");

      ClearLogs ();
    }

    public void RunLoopToRemoveDevice (DeviceInfo deviceInfo)
    {
      ClearLogs ();
      
      // Run a loop to detecte the removed device
      DeviceManager.RunLoop ();

      var removeProcessKey = "remove-" + deviceInfo.Port;

      Assert.AreEqual (1, DeviceManager.BackgroundStarter.QueuedProcesses.Count, "Invalid process count.");

      var removeProcessWrapper = DeviceManager.BackgroundStarter.QueuedProcesses.Peek ();

      Assert.AreEqual (removeProcessKey, removeProcessWrapper.Key, "Can't find remove device process.");

      // Wait while the process runs
      while (removeProcessWrapper != null && !removeProcessWrapper.HasExited)
        Thread.Sleep (200);

      var deviceRemovedText = "Finished disconnecting device: " + deviceInfo.DeviceName;

      var output = ReadPlugAndPlayLogFile ();

      Assert.IsTrue (output.Contains (deviceRemovedText), "Output doesn't contain expected text: " + deviceRemovedText);

      Assert.IsFalse (DeviceManager.Starter.IsError, "An error occurred.");

      ClearLogs ();
    }

    public void ClearLogs ()
    {
      var logsPath = Path.Combine (ProjectDirectory, "logs");
      if (Directory.Exists (logsPath))
        Directory.Delete (logsPath, true);
    }
  }
}

