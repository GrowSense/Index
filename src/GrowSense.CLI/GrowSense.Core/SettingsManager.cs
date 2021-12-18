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
        var settingsJson = File.ReadAllText(settingsFile);
        return JsonConvert.DeserializeObject<CLISettings>(settingsJson);
      }
      else
        return new CLISettings();
    }

    public bool ProcessSettingsFromArguments(Arguments arguments, CLISettings settings)
    {
      var settingsChanged = false;
      var wifiSettingsChanged = false;
      var mqttSettingsChanged = false;
      var emailSettingsChanged = false;
      
      if (arguments.Contains("branch"))
      {
        settingsChanged = true;
        settings.Branch = arguments["branch"];

        Console.WriteLine("  Setting branch: " + settings.Branch);
      }
      
      if (arguments.Contains("version"))
      {
        settingsChanged = true;
        settings.Version = arguments["version"];

        Console.WriteLine("  Setting version: " + settings.Version);
      }
      
      if (arguments.Contains("wifi-name"))
      {
        wifiSettingsChanged = true;
        settingsChanged = true;
        settings.WiFiName = arguments["wifi-name"];

        Console.WriteLine("  Setting WiFi name: " + settings.WiFiName);
      }
      if (arguments.Contains("wifi-password"))
      {
        wifiSettingsChanged = true;
        settingsChanged = true;
        settings.WiFiPassword = arguments["wifi-password"];

        Console.WriteLine("  Setting WiFi password: " + settings.WiFiPassword);
      }
      
      if (arguments.Contains("mqtt-host"))
      {
        mqttSettingsChanged = true;
        settingsChanged = true;
        settings.MqttHost = arguments["mqtt-host"];

        Console.WriteLine("  Setting MQTT host: " + settings.MqttHost);
      }
      if (arguments.Contains("mqtt-username"))
      {
        mqttSettingsChanged = true;
        settingsChanged = true;
        settings.MqttUsername = arguments["mqtt-username"];

        Console.WriteLine("  Setting MQTT username: " + settings.MqttUsername);
      }
      if (arguments.Contains("mqtt-password"))
      {
        mqttSettingsChanged = true;
        settingsChanged = true;
        settings.MqttPassword = arguments["mqtt-password"];

        Console.WriteLine("  Setting MQTT password: hidden (length " + settings.MqttPassword.Length + ")");
      }
      if (arguments.Contains("mqtt-port"))
      {
        mqttSettingsChanged = true;
        settingsChanged = true;
        settings.MqttPort = Convert.ToInt32(arguments["mqtt-port"]);

        Console.WriteLine("  Setting MQTT port: " + settings.MqttPort);
      }
      if (arguments.Contains("smtp-server"))
      {
        emailSettingsChanged = true;
        settingsChanged = true;
        settings.SmtpServer = arguments["smtp-server"];

        Console.WriteLine("  Setting SMTP server: " + settings.SmtpServer);
      }
      if (arguments.Contains("smtp-username"))
      {
        emailSettingsChanged = true;
        settingsChanged = true;
        settings.SmtpUsername = arguments["smtp-username"];

        Console.WriteLine("  Setting version: " + settings.SmtpUsername);
      }
      if (arguments.Contains("smtp-password"))
      {
        emailSettingsChanged = true;
        settingsChanged = true;
        settings.SmtpPassword = arguments["smtp-password"];

        Console.WriteLine("  Setting SMTP password: hidden (length: " + settings.SmtpPassword.Length + ")");
      }
      if (arguments.Contains("smtp-port"))
      {
        emailSettingsChanged = true;
        settingsChanged = true;
        settings.SmtpPort = Convert.ToInt32(arguments["smtp-port"]);

        Console.WriteLine("  Setting SMTP password: " + settings.SmtpPort);
      }
      if (arguments.Contains("email"))
      {
        emailSettingsChanged = true;
        settingsChanged = true;
        settings.Email = arguments["email"];

        Console.WriteLine("  Setting email address: " + settings.Email);
      }

      if (settingsChanged)
        SaveSettings(settings);

      return settingsChanged;
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
