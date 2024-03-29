﻿using System;
using GrowSense.Core.Verifiers;
using GrowSense.Core.Installers;
using System.IO;
using GrowSense.Core.Devices;
using System.Threading;
namespace GrowSense.Core
{
    public class CLIManager
    {
        public CLIContext Context;
        public ProcessStarter Starter;
        public PostInstaller PostInstall;
        public Verifier Verifier;
        public DeviceManager Devices;
        public MqttBridgeStarter MqttBridge;
        public UpgradeLauncher Upgrader;
        public VersionReader Version;
        public StatusChecker StatusChecker;

        public CLIManager(CLIContext context)
        {
            Console.WriteLine("  Working directory: " + context.IndexDirectory);

            Context = context;
            Starter = new ProcessStarter();
            Starter.WorkingDirectory = Context.IndexDirectory;

            PostInstall = new Installers.PostInstaller(context);

            Devices = new DeviceManager(context);

            MqttBridge = new MqttBridgeStarter(context);

            Verifier = new Verifier(context);

            Upgrader = new UpgradeLauncher(context);

            Version = new VersionReader(context);

            StatusChecker = new StatusChecker(context);
        }

        public void ExecuteScript(string script)
        {
            ExecuteBash("/usr/bin/bash " + script);
        }

        public void ExecuteBash(string command)
        {
            Console.WriteLine("Executing bash: " + command);

            Starter.Start(command);
        }

        public void PostInstallActions()
        {
            PostInstall.PrepareInstallation();
        }

        public void Verify()
        {
            Verifier.VerifyInstallation();
        }

        public void ApplySettings(bool verify)
        {
            Console.WriteLine("Applying and saving new settings...");

            PostInstall.SettingsManager.SaveSettings(Context.Settings);

            PostInstall.Mqtt.SetConfigValues();
            PostInstall.Mqtt.Restart();

            PostInstall.MqttBridge.SetAppConfigValues();
            PostInstall.MqttBridge.Services.Restart(Devices.GetDevices());

            PostInstall.UIController.SetAppConfigValues();
            PostInstall.UIController.Services.Restart(Devices.GetDevices());

            PostInstall.WWW.Restart();

            PostInstall.ArduinoPlugAndPlay.SetAppConfigValues();

            SetMockingFlags();

            // Wait a few seconds for services to start
            Thread.Sleep(2000);

            if (verify)
                PostInstall.Verifier.VerifyInstallation();

            Console.WriteLine("Finished applying new settings.");
        }

        public void ApplyMqttSettings()
        {
            /*Console.WriteLine("Applying and saving new MQTT settings...");

            PostInstall.Mqtt.SetConfigValues();

            PostInstall.MqttBridge.SetAppConfigValues();
            PostInstall.UIController.SetAppConfigValues();

            PostInstall.Verifier.VerifyInstallation();

            Console.WriteLine("Finished applying new MQTT settings.");*/
        }

        public void StartMqttBridge(string deviceName)
        {
            var device = Devices.GetDevice(deviceName);

            if (device == null)
                throw new ArgumentException("No device found with name: " + deviceName);

            MqttBridge.StartMqttBridge(device);
        }

        public void AddDevice(string port)
        {
            Console.WriteLine("Adding device...");
            Console.WriteLine("  Port: " + port);

            if (String.IsNullOrEmpty(port))
                throw new ArgumentNullException(port);

            if (port.IndexOf("/dev/") == -1)
            {
                port = "/dev/" + port;
                Console.WriteLine("  Fixed port: " + port);
            }

            Devices.AddDevice(port);

            Console.WriteLine("Finished adding device.");
        }

        public void Stop()
        {
            Console.WriteLine("Stopping GrowSense system services...");

            Starter.StartBash("bash stop-garden.sh");

            Console.WriteLine("Finished stopping GrowSense system services.");
        }

        public void Start()
        {
            Console.WriteLine("Starting GrowSense system services...");

            Starter.StartBash("bash start-garden.sh");

            Console.WriteLine("Finished starting GrowSense system services.");
        }

        public void SetMockingFlags()
        {
            Console.WriteLine("Setting mocking flags...");

            if (Context.Settings.IsMockSystemCtl)
            {
                Console.WriteLine("  Creating mock systemctl flag files...");
                File.WriteAllText(Context.IndexDirectory + "/is-mock-systemctl.txt", true.ToString());
                File.WriteAllText(Context.Paths.GetApplicationPath("ArduinoPlugAndPlay") + "/is-mock-systemctl.txt", true.ToString());
            }
            else
            {
                Console.WriteLine("  Removing mock systemctl flag files...");

                if (File.Exists(Context.IndexDirectory + "/is-mock-systemctl.txt"))
                    File.Delete(Context.IndexDirectory + "/is-mock-systemctl.txt");

                if (File.Exists(Context.Paths.GetApplicationPath("ArduinoPlugAndPlay") + "/is-mock-systemctl.txt"))
                    File.Delete(Context.Paths.GetApplicationPath("ArduinoPlugAndPlay") + "/is-mock-systemctl.txt");
            }

            if (Context.Settings.IsMockDocker)
            {
                Console.WriteLine("  Creating mock docker flag file...");
                File.WriteAllText(Context.IndexDirectory + "/is-mock-docker.txt", true.ToString());
            }
            else
            {
                Console.WriteLine("  Removing mock docker flag file..");

                if (File.Exists(Context.IndexDirectory + "/is-mock-docker.txt"))
                {
                    File.Delete(Context.IndexDirectory + "/is-mock-docker.txt");
                }
            }

        }

        public void Upgrade()
        {
            Upgrader.Upgrade();
        }

        public void CheckVersion()
        {
            Version.WriteVersionsToConsole();
        }

        public void CheckStatus()
        {
            StatusChecker.WriteStatusToConsole();
        }
    }
}