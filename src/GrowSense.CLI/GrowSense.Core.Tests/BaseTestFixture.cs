using System;
using System.IO;
using NUnit.Framework;
using GrowSense.Index.Tests;


namespace GrowSense.Core.Tests
{
  public class BaseTestFixture
  {
    public string ProjectDirectory;
    public string TemporaryDirectory;
    public TemporaryDirectoryCreator TmpDirCreator = new TemporaryDirectoryCreator ();

    [SetUp]
    public void Initialize ()
    {
      Console.WriteLine ("");
      Console.WriteLine ("=== Starting test");
      Console.WriteLine ("Test: " + TestContext.CurrentContext.Test.FullName);

      var dir = Environment.CurrentDirectory;

      dir = dir.Replace ("/tests/nunit/bin/Release", "");
      dir = dir.Replace ("/tests/nunit/bin/Debug", "");

      dir = dir.Replace ("/bin/Release", "");
      dir = dir.Replace ("/bin/Debug", "");

      ProjectDirectory = dir;
      Console.WriteLine ("Project directory: ");
      Console.WriteLine ("  " + ProjectDirectory);
      Console.WriteLine ("");

      Directory.SetCurrentDirectory (ProjectDirectory);

      ClearDevices ();
    }

    public void CopyDirectory (string source, string destination)
    {
      var starter = new ProcessStarter ();
      starter.Start ("rsync -arh --exclude='.git' --exclude='.pioenvs' " + source + "/ " + destination + "/");
      Console.WriteLine (starter.Output);
    }

    [TearDown]
    public void Finish ()
    {
      Directory.SetCurrentDirectory(ProjectDirectory);
      
      Console.WriteLine ("=== Finished test");
      Console.WriteLine ("");
    }

    public void ClearDevices ()
    {
      // Clear all devices for the test
      var devicesPath = Path.GetFullPath ("devices");
      if (Directory.Exists (devicesPath))
        Directory.Delete (devicesPath, true);
    }

    public TestProcessStarter GetTestProcessStarter ()
    {
      return GetTestProcessStarter (true, Environment.CurrentDirectory);
    }

    public TestProcessStarter GetTestProcessStarter (string workingDirectory)
    {
      return GetTestProcessStarter (true, workingDirectory);
    }

    public TestProcessStarter GetTestProcessStarter (bool initializeStarter, string workingDirectory)
    {
      var starter = new TestProcessStarter ();

      starter.WorkingDirectory = workingDirectory;

      if (initializeStarter)
        starter.Initialize ();

      return starter;
    }

    public void CheckDeviceInfoWasCreated (string deviceBoard, string deviceGroup, string deviceProject, string deviceLabel, string deviceName, string devicePort)
    {
      var devicesDir = Path.GetFullPath ("devices");
      var deviceDir = Path.Combine (devicesDir, deviceName);

      Console.WriteLine ("Device dir:");
      Console.WriteLine (deviceDir);

      var deviceDirExists = Directory.Exists (deviceDir);

      Assert.IsTrue (deviceDirExists, "Device directory not found: " + deviceDir);

      var foundBoard = File.ReadAllText (Path.Combine (deviceDir, "board.txt")).Trim ();
      Assert.AreEqual (deviceBoard, foundBoard, "Device board doesn't match.");

      var foundGroup = File.ReadAllText (Path.Combine (deviceDir, "group.txt")).Trim ();
      Assert.AreEqual (deviceGroup, foundGroup, "Device group doesn't match.");

      var foundProject = File.ReadAllText (Path.Combine (deviceDir, "project.txt")).Trim ();
      Assert.AreEqual (deviceProject, foundProject, "Device project doesn't match.");

      var foundLabel = File.ReadAllText (Path.Combine (deviceDir, "label.txt")).Trim ();
      Assert.AreEqual (deviceLabel, foundLabel, "Device label doesn't match.");

      var foundName = File.ReadAllText (Path.Combine (deviceDir, "name.txt")).Trim ();
      Assert.AreEqual (deviceName, foundName, "Device name doesn't match.");

      var foundPort = File.ReadAllText (Path.Combine (deviceDir, "port.txt")).Trim ();
      Assert.AreEqual (devicePort, foundPort, "Device port doesn't match.");
    }

    public void CheckMqttBridgeServiceFileWasCreated (string deviceName)
    {
      var serviceFile = Path.Combine (GetServicesDirectory (), "growsense-mqtt-bridge-" + deviceName + ".service");

      var fileExists = File.Exists (serviceFile);

      Assert.IsTrue (fileExists, "MQTT bridge service file not created: " + serviceFile);
    }

    public void CheckFlagWasCreated (string deviceName)
    {
      var deviceInfoDir = Path.Combine (ProjectDirectory, "devices/" + deviceName);

      var flagFile = Path.Combine (deviceInfoDir, "is-ui-created.txt");

      var fileExists = File.Exists (flagFile);

      Assert.IsTrue (fileExists, "'UI is created' flag file not found: " + flagFile);
    }

    public string GetServicesDirectory ()
    {
      var servicesDirectory = "";
      if (File.Exists (Path.GetFullPath (Path.Combine (ProjectDirectory, "is-mock-systemctl.txt")))) {
        servicesDirectory = Path.Combine (ProjectDirectory, "mock/services");
      } else {
        servicesDirectory = "/lib/systemd/system/";
      }
      return servicesDirectory;
    }

    public void PullFileFromProject (string fileName)
    {
      PullFileFromProject (fileName, false);
    }

    public void PullFileFromProject (string fileName, bool removeDestinationDirectory)
    {
      var sourceFile = Path.Combine (ProjectDirectory, fileName);
      var destinationFile = Path.Combine (Environment.CurrentDirectory, fileName);

      if (removeDestinationDirectory) {
        var shortenedFileName = Path.GetFileName (fileName);
        destinationFile = Path.Combine (Environment.CurrentDirectory, shortenedFileName);
      }

      if (!Directory.Exists(Path.GetDirectoryName(destinationFile)))
      Directory.CreateDirectory(Path.GetDirectoryName(destinationFile));

      File.Copy (sourceFile, destinationFile);
    }

    public void PullDirectoryFromProject(string directoryPath)
    {
      var sourceDir = ProjectDirectory + "/" + directoryPath;
      var destinationDir = TemporaryDirectory + "/" + directoryPath;

      if (!Directory.Exists(destinationDir))
        Directory.CreateDirectory(destinationDir);

      CopyDirectory(sourceDir, destinationDir);
    }

    public void MoveToProjectDirectory ()
    {
      Directory.SetCurrentDirectory (ProjectDirectory);
    }

    public void MoveToTemporaryDirectory ()
    {
      var tmpTestDir = TmpDirCreator.Create (ProjectDirectory);
      
      if (!Directory.Exists (tmpTestDir))
        Directory.CreateDirectory (tmpTestDir);

      TemporaryDirectory = tmpTestDir;

      Directory.SetCurrentDirectory (tmpTestDir);
    }

    public void CleanTemporaryDirectory ()
    {
      var tmpDir = TemporaryDirectory;

      Directory.SetCurrentDirectory (ProjectDirectory);

      Console.WriteLine ("Cleaning temporary directory:");
      Console.WriteLine (tmpDir);

      //Directory.Delete (tmpDir, true);
    }

    public void EnableMocking (string path, string key)
    {
      var filePath = Path.GetFullPath (path) + "/is-mock-" + key + ".txt";
      Directory.CreateDirectory (Path.GetDirectoryName (filePath));
      File.WriteAllText (filePath, 1.ToString ());

    }

    public string GetBranch ()
    {
      Console.WriteLine ("Getting git branch...");
      var branchDetector = new BranchDetector (ProjectDirectory);
      return branchDetector.Branch;
    }
  }
}
