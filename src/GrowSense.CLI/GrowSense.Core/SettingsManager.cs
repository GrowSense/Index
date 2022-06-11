using System;
using Newtonsoft.Json;
using System.IO;
namespace GrowSense.Core
{
    public class SettingsManager
    {
        //public CLIContext Context;
        public string WorkingDirectory;

        public SettingsManager(string workingDirectory) //CLIContext context)
        {
            //Context = context;
            WorkingDirectory = workingDirectory;
        }

        public CLISettings LoadSettings()//CLIContext context)
        {
            Console.WriteLine("Loading settings...");

            var settingsFile = GetSettingsFilePath();

            Console.WriteLine("  Path: " + settingsFile);

            if (File.Exists(settingsFile))
            {
                Console.WriteLine("  Settings file exists.");
                var settingsJson = File.ReadAllText(settingsFile);
                var settings = JsonConvert.DeserializeObject<CLISettings>(settingsJson);

                var starter = new ProcessStarter(WorkingDirectory);
                starter.StartBash("hostname");
                settings.HostName = starter.Output.Trim();

                // Load the version from the full-version.txt file
                var versionFile = WorkingDirectory + "/full-version.txt";
                if (File.Exists(versionFile))
                {
                    settings.Version = File.ReadAllText(versionFile).Trim();
                }

                return settings;
            }
            else
            {
                Console.WriteLine("  Settings file doesn't exist. Loading from legacy settings files...");
                var settings = new CLISettings();


                // Load settings from legacy files if they exist
                if (File.Exists(WorkingDirectory + "/mqtt-host.security"))
                    settings.MqttHost = File.ReadAllText(WorkingDirectory + "/mqtt-host.security").Trim();
                if (File.Exists(WorkingDirectory + "/mqtt-username.security"))
                    settings.MqttUsername = File.ReadAllText(WorkingDirectory + "/mqtt-username.security").Trim();
                if (File.Exists(WorkingDirectory + "/mqtt-password.security"))
                    settings.MqttPassword = File.ReadAllText(WorkingDirectory + "/mqtt-password.security").Trim();
                if (File.Exists(WorkingDirectory + "/mqtt-port.security"))
                    settings.MqttPort = Convert.ToInt32(File.ReadAllText(WorkingDirectory + "/mqtt-port.security").Trim());

                if (File.Exists(WorkingDirectory + "/wifi-name.security"))
                    settings.WiFiName = File.ReadAllText(WorkingDirectory + "/wifi-name.security").Trim();
                if (File.Exists(WorkingDirectory + "/wifi-password.security"))
                    settings.WiFiPassword = File.ReadAllText(WorkingDirectory + "/wifi-password.security").Trim();

                if (File.Exists(WorkingDirectory + "/smtp-server.security"))
                    settings.SmtpServer = File.ReadAllText(WorkingDirectory + "/smtp-server.security").Trim();
                if (File.Exists(WorkingDirectory + "/smtp-username.security"))
                    settings.SmtpUsername = File.ReadAllText(WorkingDirectory + "/smtp-username.security").Trim();
                if (File.Exists(WorkingDirectory + "/smtp-password.security"))
                    settings.SmtpPassword = File.ReadAllText(WorkingDirectory + "/smtp-password.security").Trim();
                if (File.Exists(WorkingDirectory + "/smtp-port.security"))
                    settings.SmtpPort = Convert.ToInt32(File.ReadAllText(WorkingDirectory + "/smtp-port.security").Trim());
                if (File.Exists(WorkingDirectory + "/admin-email.security"))
                    settings.Email = File.ReadAllText(WorkingDirectory + "/admin-email.security").Trim();

                return settings;
            }
        }

        public void SaveSettings(CLISettings settings)
        {
            Console.WriteLine("Saving settings...");

            var json = JsonConvert.SerializeObject(settings, Formatting.Indented);

            var settingsFile = GetSettingsFilePath();

            Console.WriteLine("  Path: " + settingsFile);

            File.WriteAllText(settingsFile, json);

            SaveSettingsToLegacyFiles(settings);
        }

        public void SaveSettingsToLegacyFiles(CLISettings settings)
        {
            // TODO: Phase this out once scripts no longer rely on it.

            var basePath = WorkingDirectory;

            File.WriteAllText(basePath + "/mqtt-host.security", settings.MqttHost);
            File.WriteAllText(basePath + "/mqtt-username.security", settings.MqttUsername);
            File.WriteAllText(basePath + "/mqtt-password.security", settings.MqttPassword);
            File.WriteAllText(basePath + "/mqtt-port.security", settings.MqttPort.ToString());

            File.WriteAllText(basePath + "/wifi-name.security", settings.WiFiName);
            File.WriteAllText(basePath + "/wifi-password.security", settings.WiFiPassword);

            File.WriteAllText(basePath + "/smtp-server.security", settings.SmtpServer);
            File.WriteAllText(basePath + "/smpt-username.security", settings.SmtpUsername);
            File.WriteAllText(basePath + "/smtp-password.security", settings.SmtpPassword);
            File.WriteAllText(basePath + "/smtp-port.security", settings.SmtpPort.ToString());
            File.WriteAllText(basePath + "/admin-email.security", settings.Email);
        }

        public string GetSettingsFilePath()
        {
            return Path.Combine(WorkingDirectory, "growsense.settings");
        }
    }
}