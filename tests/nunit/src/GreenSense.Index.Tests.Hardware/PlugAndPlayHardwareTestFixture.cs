using System;
using NUnit.Framework;
using ArduinoPlugAndPlay;
using ArduinoPlugAndPlay.Tests;
using System.IO;
using System.Threading;

namespace GreenSense.Index.Tests.Hardware
{
    [TestFixture (Category = "Hardware")]
    public class PlugAndPlayHardwareTestFixture : BaseHardwareTestFixture
    {
        [Test]
        public void Test_PlugAndPlay ()
        {
            Console.WriteLine ("");
            Console.WriteLine ("Preparing add device test...");
            Console.WriteLine ("");

            // Set up the mock objects
            var mockPlatformio = new MockPlatformioWrapper ();
            var mockReaderWriter = new MockDeviceReaderWriter ();
            var mockOutputs = new MockDeviceOutputs ();

            // Set up the device manager with the mock dependencies
            var deviceManager = new DeviceManager ();
            deviceManager.Platformio = mockPlatformio;
            deviceManager.ReaderWriter = mockReaderWriter;

            deviceManager.USBDeviceConnectedCommand = "sh auto-connect-usb-device.sh {BOARD} {FAMILY} {GROUP} {PROJECT} {PORT}";
            deviceManager.USBDeviceDisconnectedCommand = "sh auto-disconnect-usb-device.sh {PORT}";

            var shortPortName = GetIrrigatorPort ().Replace ("/dev/", "");

            var deviceInfo = new DeviceInfo ();

            var deviceName = "irrigator1";

            deviceInfo.FamilyName = "GreenSense";
            deviceInfo.GroupName = "irrigator";
            deviceInfo.ProjectName = "SoilMoistureSensorCalibratedPump";
            deviceInfo.BoardType = "uno";
            deviceInfo.Port = shortPortName;

            mockPlatformio.ConnectDevice (shortPortName);
            mockReaderWriter.SetMockOutput (mockOutputs.GetDeviceSerialOutput (deviceInfo));

            Console.WriteLine ("");
            Console.WriteLine ("Performing add device test...");
            Console.WriteLine ("");

            deviceManager.RunLoop ();
            Console.WriteLine (ProjectDirectory);

            // Wait while the process runs
            var addProcessKey = "add-" + deviceInfo.Port;

            Assert.AreEqual (1, deviceManager.BackgroundStarter.QueuedProcesses.Count, "Invalid process count.");

            var addProcessWrapper = deviceManager.BackgroundStarter.QueuedProcesses.Peek ();

            Assert.AreEqual (addProcessKey, addProcessWrapper.Key, "Can't find add device process.");

            while (addProcessWrapper != null && !addProcessWrapper.HasExited)
                Thread.Sleep (200);

            var output = ReadPlugAndPlayLogFile ();

            var deviceCreatedText = "Garden " + deviceInfo.GroupName + " created with device name '" + deviceInfo.GroupName + "1'";
            Assert.IsTrue (output.Contains (deviceCreatedText), "Didn't find the expected output in the log: " + deviceCreatedText);

            Assert.IsFalse (deviceManager.Starter.IsError, "An error occurred.");

            Console.WriteLine ("");
            Console.WriteLine ("Preparing remove device test...");
            Console.WriteLine ("");

            mockPlatformio.DisconnectDevice (shortPortName);

            Console.WriteLine ("");
            Console.WriteLine ("Performing remove device test...");
            Console.WriteLine ("");

            deviceManager.RunLoop ();

            // Wait while the process runs
            var removeProcessKey = "remove-" + deviceInfo.Port;

            Assert.AreEqual (addProcessKey, addProcessWrapper.Key, "Can't find add device process.");

            Assert.AreEqual (1, deviceManager.BackgroundStarter.QueuedProcesses.Count, "Invalid process count.");

            var removeProcessWrapper = deviceManager.BackgroundStarter.QueuedProcesses.Peek ();

            Assert.AreEqual (removeProcessKey, removeProcessWrapper.Key, "Can't find remove device process.");

            while (addProcessWrapper != null && !addProcessWrapper.HasExited)
                Thread.Sleep (200);

            var deviceRemovedText = "Garden device removed: " + deviceName;

            output = ReadPlugAndPlayLogFile ();

            Assert.IsTrue (output.Contains (deviceRemovedText));

            Assert.IsFalse (deviceManager.Starter.IsError, "An error occurred.");


        }

        public string ReadPlugAndPlayLogFile ()
        {
            var output = String.Empty;

            var logsDir = Path.Combine (ProjectDirectory, "logs");
            foreach (var logFile in Directory.GetFiles(logsDir))
                output = File.ReadAllText (logFile);

            return output;
        }
    }
}

