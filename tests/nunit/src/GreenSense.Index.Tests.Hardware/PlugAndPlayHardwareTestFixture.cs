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

            // Set up the device manager with the mock dependencies
            var deviceManager = new DeviceManager ();
            //deviceManager.Platformio = mockPlatformio; // Don't set it yet

            deviceManager.DeviceAddedCommand = "sh auto-add-device.sh {BOARD} {FAMILY} {GROUP} {PROJECT} {PORT}";
            deviceManager.DeviceRemovedCommand = "sh auto-remove-device.sh {PORT}";

            var shortPortName = GetDevicePort ().Replace ("/dev/", "");

            var deviceInfo = new DeviceInfo ();

            var deviceName = "irrigator1";

            deviceInfo.FamilyName = "GreenSense";
            deviceInfo.GroupName = "irrigator";
            deviceInfo.ProjectName = "SoilMoistureSensorCalibratedPump";
            deviceInfo.BoardType = "uno";
            deviceInfo.Port = shortPortName;

            Console.WriteLine ("");
            Console.WriteLine ("Uploading the irrigator sketch to the device...");
            Console.WriteLine ("");

            var starter = GetTestProcessStarter (false);
            starter.IsMockHardware = false;
            starter.Initialize ();
            starter.RunBash ("sh upload-irrigator-nano-sketch.sh " + shortPortName);

            var uploadCompletedText = "avrdude done.  Thank you.";
            Assert.IsTrue (starter.Starter.Output.Contains (uploadCompletedText));

            Assert.IsFalse (starter.Starter.IsError, "An error occurred.");

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

            // Set the mock platformio object to the device manager so it can simulate no devices found
            deviceManager.Platformio = mockPlatformio;

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

