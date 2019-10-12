using System;
using System.IO;
using NUnit.Framework;
using Newtonsoft.Json.Linq;

namespace GrowSense.Index.Tests
{
    public class BaseTestFixture
    {
        public string ProjectDirectory;

        public string TemporaryDirectory;

        public string LinearMqttSettingsFile = "mobile/linearmqtt/newsettings.json";

        public BaseTestFixture ()
        {
        }

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
            return GetTestProcessStarter (true);
        }

        public TestProcessStarter GetTestProcessStarter (bool initializeStarter)
        {
            var starter = new TestProcessStarter ();

            starter.WorkingDirectory = ProjectDirectory;

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

        public void CheckDeviceUIWasCreated (string deviceLabel, string deviceName, string valueLabel, string valueKey)
        {
            CheckDeviceUIWasCreated (deviceLabel, deviceName, valueLabel, valueKey, valueLabel, valueKey);
        }

        public void CheckDeviceUIWasCreated (string deviceLabel, string deviceName, string summaryValueLabel, string summaryValueKey, string valueLabel, string valueKey)
        {
            Console.WriteLine ("Checking that the device UI was created...");
            var jsonString = File.ReadAllText (LinearMqttSettingsFile);
            var json = JObject.Parse (jsonString);

            // Disabled to reduce the console output length
            //Console.WriteLine(jsonString);

            CheckDeviceSummaryWasCreated (json, deviceLabel, deviceName, summaryValueKey);
            CheckDeviceTabIndexWasCreated (json, deviceLabel, deviceName);
            CheckDeviceTabWasCreated (json, deviceLabel, deviceName, valueLabel, valueKey);
            CheckFlagWasCreated (deviceName);
        }

        public void CheckDeviceSummaryWasCreated (JObject json, string deviceLabel, string deviceName, string dataKey)
        {
            Console.WriteLine ("Checking the device summary was created...");

            // Disabled to reduce the console output length
            //Console.WriteLine("Full JSON:");
            //Console.WriteLine(json.ToString());

            var dashboardsElement = json ["dashboards"];

            // Disabled to reduce the console output length
            //Console.WriteLine("Dashboards element:");
            //Console.WriteLine(dashboardsElement);

            var summaryDashboardElement = dashboardsElement [0];

            // Disabled to reduce the console output length
            //Console.WriteLine("Summary dashboard element:");
            //Console.WriteLine(summaryDashboardElement);

            var summaryDeviceMeterElement = summaryDashboardElement ["dashboard"] [0];

            // Disabled to reduce the console output length
            //Console.WriteLine("Summary dashboard element:");
            //Console.WriteLine(summaryDeviceMeterElement);

            //Console.WriteLine ("Details from json:");
            //Console.WriteLine ("  name: " + summaryDeviceMeterElement ["name"]);
            //Console.WriteLine ("  topic: " + summaryDeviceMeterElement ["topic"]);

            //Console.WriteLine ("Checking summary device meter name matches device label...");

            Assert.AreEqual (deviceLabel, summaryDeviceMeterElement ["name"].ToString (), "Summary element name doesn't match the device label.");

            //Console.WriteLine ("Checking summary device meter topic matches device name...");

            var expectedTopic = "/" + deviceName + "/" + dataKey;

            Assert.AreEqual (expectedTopic, summaryDeviceMeterElement ["topic"].ToString (), "Summary element topic doesn't match the device name.");
        }

        public void CheckDeviceTabIndexWasCreated (JObject json, string deviceLabel, string deviceName)
        {
            Console.WriteLine ("Checking the device tab index was created...");
            var tabsElement = json ["tabs"];

            var deviceTabElement = tabsElement [1];

            // Disabled to reduce the console output length
            //Console.WriteLine("Device tab element:");
            //Console.WriteLine(deviceTabElement);

            //Console.WriteLine ("Details from json:");
            //Console.WriteLine ("  name: " + deviceTabElement ["name"]);

            //Console.WriteLine ("Checking device tab name matches device label...");

            Assert.AreEqual (deviceLabel, deviceTabElement ["name"].ToString (), "Summary element name doesn't match the device label.");
        }

        public void CheckDeviceTabWasCreated (JObject json, string deviceLabel, string deviceName, string valueMeterLabel, string valueKey)
        {
            Console.WriteLine ("Checking the device tab content was created...");
            var dashboardsElement = json ["dashboards"];

            var deviceElement = dashboardsElement [1];
            var deviceElementId = dashboardsElement [1] ["id"];

            // Disabled to reduce the console output length
            //Console.WriteLine("Device element:");
            //Console.WriteLine(deviceElement);
            //Console.WriteLine ("Device element ID: " + deviceElementId);

            //Console.WriteLine ("Checking device element ID is correct...");

            var expectedDeviceElementId = "2";

            Assert.AreEqual (expectedDeviceElementId, deviceElementId.ToString (), "Value meter topic doesn't match the device name.");

            // The value meter element has index 0 for the monitor and index 1 for the irrigator
            var valueMeterIndex = (deviceName.ToLower ().Contains ("irrigator") ? 1 : 0);

            var valueMeterElement = deviceElement ["dashboard"] [valueMeterIndex];

            // Disabled to reduce the console output length
            //Console.WriteLine("Value meter element:");
            //Console.WriteLine(valueMeterElement);

            //Console.WriteLine ("Details from json:");
            //Console.WriteLine ("  name: " + valueMeterElement ["name"]);
            //Console.WriteLine ("  topic: " + valueMeterElement ["topic"]);

            //Console.WriteLine ("Checking value meter name is valid...");

            var expectedValueMeterName = valueMeterLabel;

            Assert.AreEqual (expectedValueMeterName, valueMeterElement ["name"].ToString (), "Value meter name is invalid.");

            //Console.WriteLine ("Checking value meter topic matches device name...");

            var expectedValueMeterTopic = "/" + deviceName + "/" + valueKey;

            Assert.AreEqual (expectedValueMeterTopic, valueMeterElement ["topic"].ToString (), "Value meter topic doesn't match the device name.");
        }

        public void CheckDeviceUICount (int numberOfDevicesExpected)
        {
            Console.WriteLine ("Checking that the device UI was created...");
            var jsonString = File.ReadAllText (LinearMqttSettingsFile);
            var json = JObject.Parse (jsonString);

            Console.WriteLine ("Checking the number of devices is correct...");
            var dashboardsElement = json ["dashboards"];

            var expectedCount = 1 + numberOfDevicesExpected;
            var actualCount = ((JArray)dashboardsElement).Count;

            Assert.AreEqual (expectedCount, actualCount, "Wrong number of devices in UI");
        }

        public void CheckMqttBridgeServiceFileWasCreated (string deviceName)
        {
            var serviceFile = Path.Combine (GetServicesDirectory (), "greensense-mqtt-bridge-" + deviceName + ".service");

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
                destinationFile = Path.Combine (TemporaryDirectory, shortenedFileName);
            }

            File.Copy (sourceFile, destinationFile);
        }

        public void MoveToProjectDirectory ()
        {
            Directory.SetCurrentDirectory (ProjectDirectory);
        }

        public void MoveToTemporaryDirectory ()
        {
            var tmpDir = Path.Combine (ProjectDirectory, "_tmp");

            if (!Directory.Exists (tmpDir))
                Directory.CreateDirectory (tmpDir);

            var tmpTestDir = Path.Combine (tmpDir, Guid.NewGuid ().ToString ());

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
    }
}
