using System;
using NUnit.Framework;
using ArduinoPlugAndPlay;
using ArduinoPlugAndPlay.Tests;

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

            deviceManager.DeviceAddedCommand = "sh auto-connect-device.sh {BOARD} {FAMILY} {GROUP} {PROJECT} {PORT}";
            deviceManager.DeviceRemovedCommand = "sh auto-disconnect-device.sh {PORT}";

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

            var deviceCreatedText = "Garden " + deviceInfo.GroupName + " created with device name '" + deviceInfo.GroupName + "1'";
            Assert.IsTrue (deviceManager.Starter.Output.Contains (deviceCreatedText));

            Assert.IsFalse (deviceManager.Starter.IsError, "An error occurred.");

            Console.WriteLine ("");
            Console.WriteLine ("Preparing remove device test...");
            Console.WriteLine ("");

            mockPlatformio.DisconnectDevice (shortPortName);

            Console.WriteLine ("");
            Console.WriteLine ("Performing remove device test...");
            Console.WriteLine ("");

            deviceManager.RunLoop ();

            var deviceRemovedText = "Garden device removed: " + deviceName;

            Assert.IsTrue (deviceManager.Starter.Output.Contains (deviceRemovedText));

            Assert.IsFalse (deviceManager.Starter.IsError, "An error occurred.");

        }
    }
}

