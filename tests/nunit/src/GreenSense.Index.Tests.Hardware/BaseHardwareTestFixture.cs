using System;

namespace GreenSense.Index.Tests.Hardware
{
    public class BaseHardwareTestFixture : BaseTestFixture
    {
        public BaseHardwareTestFixture ()
        {
        }


        public string GetIrrigatorPort ()
        {
            var devicePort = Environment.GetEnvironmentVariable ("IRRIGATOR_PORT");

            if (String.IsNullOrEmpty (devicePort))
                devicePort = "/dev/ttyUSB0";

            Console.WriteLine ("Device port: " + devicePort);

            return devicePort;
        }

        public string GetIlluminatorPort ()
        {
            var devicePort = Environment.GetEnvironmentVariable ("ILLUMINATOR_PORT");

            if (String.IsNullOrEmpty (devicePort))
                devicePort = "/dev/ttyUSB1";

            Console.WriteLine ("Device port: " + devicePort);

            return devicePort;
        }

        public string GetVentilatorPort ()
        {
            var devicePort = Environment.GetEnvironmentVariable ("VENTILATOR_PORT");

            if (String.IsNullOrEmpty (devicePort))
                devicePort = "/dev/ttyUSB5";

            Console.WriteLine ("Device port: " + devicePort);

            return devicePort;
        }

        public string GetSimulatorPort ()
        {
            var simulatorPort = Environment.GetEnvironmentVariable ("IRRIGATOR_SIMULATOR_PORT");

            if (String.IsNullOrEmpty (simulatorPort))
                simulatorPort = "/dev/ttyUSB1";

            Console.WriteLine ("Simulator port: " + simulatorPort);

            return simulatorPort;
        }

        public int GetDeviceSerialBaudRate ()
        {
            var baudRateString = Environment.GetEnvironmentVariable ("IRRIGATOR_BAUD_RATE");
            
            var baudRate = 0;
            
            if (String.IsNullOrEmpty (baudRateString))
                baudRate = 9600;
            else
                baudRate = Convert.ToInt32 (baudRateString);
            
            Console.WriteLine ("Device baud rate: " + baudRate);
            
            return baudRate;
        }

        public int GetSimulatorSerialBaudRate ()
        {
            var baudRateString = Environment.GetEnvironmentVariable ("IRRIGATOR_SIMULATOR_BAUD_RATE");
            
            var baudRate = 0;
            
            if (String.IsNullOrEmpty (baudRateString))
                baudRate = 9600;
            else
                baudRate = Convert.ToInt32 (baudRateString);
            
            Console.WriteLine ("Simulator baud rate: " + baudRate);
            
            return baudRate;
        }
    }
}

