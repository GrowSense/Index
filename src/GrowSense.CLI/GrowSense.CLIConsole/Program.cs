using System;
using System.IO;
using Newtonsoft.Json;
using GrowSense.Core.Tools.Mock;

namespace GrowSense.Core
{
    class MainClass
    {
        public static SettingsManager SettingsManager;
        public static SettingsArgumentsExtractor SettingsExtractor;

        public static void Main(string[] args)
        {
            Console.WriteLine("===== GrowSense CLI Console =====");

            var arguments = new Arguments(args);

            var workingDirectory = Path.GetFullPath("/");

            if (arguments.Contains("dir"))
                workingDirectory = Path.GetFullPath(arguments["dir"]);

            var settings = GetSettings(workingDirectory, arguments);

            var context = new CLIContext(workingDirectory, settings);

            var manager = CreateManager(context);

            try
            {
                if (arguments.KeylessArguments.Length > 0)
                {
                    var command = arguments.KeylessArguments[0];

                    Console.WriteLine("  Command: " + command);

                    switch (command)
                    {
                        case "post-install":
                            //Console.WriteLine("Post install");
                            manager.PostInstallActions();
                            break;
                        case "stop":
                            //Console.WriteLine("Stop");
                            manager.Stop();
                            break;
                        case "start":
                            //Console.WriteLine("Stop");
                            manager.Start();
                            break;
                        case "verify":
                            //Console.WriteLine("Verify");
                            manager.Verify();
                            break;
                        case "config":
                            //Console.WriteLine("Config");
                            var verify = true;
                            if (arguments.Contains("verify"))
                                verify = Convert.ToBoolean(arguments["verify"]);
                            manager.ApplySettings(verify);
                            break;
                        case "add-device":
                            var port = arguments["port"];
                            manager.AddDevice(port);
                            break;
                        case "start-mqtt-bridge":
                            var deviceName = arguments["name"];
                            manager.StartMqttBridge(deviceName);
                            break;
                        case "upgrade":
                            manager.Upgrade();
                            break;
                        case "version":
                            manager.CheckVersion();
                            break;
                        default:
                            Console.WriteLine("Unknown command: " + command);
                            Environment.Exit(1);
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                Environment.Exit(1);
            }
        }

        static public CLIManager CreateManager(CLIContext context)
        {
            var manager = new CLIManager(context);

            if (context.Settings.IsMockSystemCtl)
            {
                var mockSystemCtl = new MockSystemCtlHelper(context);
                manager.PostInstall.ArduinoPlugAndPlay.Verifier.SystemCtl = mockSystemCtl;
                manager.PostInstall.Docker.Verifier.SystemCtl = mockSystemCtl;

                manager.PostInstall.Supervisor.Verifier.SystemCtl = mockSystemCtl;
                manager.PostInstall.WWW.Verifier.SystemCtl = mockSystemCtl;
                manager.PostInstall.Mqtt.SystemCtl = mockSystemCtl;
                manager.PostInstall.Verifier.SystemCtl = mockSystemCtl;
                manager.PostInstall.Verifier.ArduinoPlugAndPlay.SystemCtl = mockSystemCtl;
                manager.PostInstall.Verifier.Docker.SystemCtl = mockSystemCtl;
                manager.PostInstall.Verifier.Supervisor.SystemCtl = mockSystemCtl;
                manager.PostInstall.Verifier.WWW.SystemCtl = mockSystemCtl;
            }

            if (context.Settings.IsMockDocker)
            {
                var mockDocker = new MockDockerHelper(context);
                manager.PostInstall.Mqtt.Docker = mockDocker;
                manager.PostInstall.Mqtt.Verifier.Docker = mockDocker;
                manager.PostInstall.Verifier.Mosquitto.Docker = mockDocker;
            }

            return manager;
        }

        static public CLISettings GetSettings(string workingDirectory, Arguments arguments)
        {
            SettingsManager = new SettingsManager(workingDirectory);

            var settings = SettingsManager.LoadSettings();

            SettingsExtractor = new SettingsArgumentsExtractor();

            SettingsExtractor.LoadSettingsFromArguments(arguments, settings);

            Console.WriteLine("  Login Username: " + settings.Username);
            Console.WriteLine("  Login Password: hidden");

            Console.WriteLine("  MQTT Host: " + settings.MqttHost);
            Console.WriteLine("  MQTT Username: " + settings.MqttUsername);
            Console.WriteLine("  MQTT Password: hidden");
            Console.WriteLine("  MQTT Port: " + settings.MqttPort);

            Console.WriteLine("  WiFi Name: " + settings.WiFiName);
            Console.WriteLine("  WiFi Password: " + settings.WiFiPassword);

            Console.WriteLine("  SMTP Server: " + settings.SmtpServer);
            Console.WriteLine("  SMTP Username: " + settings.SmtpUsername);
            Console.WriteLine("  SMTP Password: hidden");
            Console.WriteLine("  SMTP Port: " + settings.SmtpPort);
            Console.WriteLine("  Email: " + settings.Email);


            return settings;
        }
    }
}