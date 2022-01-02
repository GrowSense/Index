using System;
namespace GrowSense.Core
{
  public class SettingsArgumentsExtractor
  {
      public bool SettingsChanged = false;
      public bool LoginSettingsChanged = false;
      public bool WifiSettingsChanged = false;
      public bool MqttSettingsChanged = false;
      public bool EmailSettingsChanged = false;
      
    public SettingsArgumentsExtractor()
    {
    }
    
    public bool LoadSettingsFromArguments(Arguments arguments, CLISettings settings)
    {
      
      if (arguments.Contains("branch"))
      {
        SettingsChanged = true;
        settings.Branch = arguments["branch"];

        Console.WriteLine("  Setting branch: " + settings.Branch);
      }
      
      if (arguments.Contains("version"))
      {
        SettingsChanged = true;
        settings.Version = arguments["version"];

        Console.WriteLine("  Setting version: " + settings.Version);
      }
      
      if (arguments.Contains("username"))
      {
        LoginSettingsChanged = true;
        SettingsChanged = true;
        settings.Username = arguments["username"];

        Console.WriteLine("  Setting login username: " + settings.MqttUsername);
      }
      if (arguments.Contains("password"))
      {
        LoginSettingsChanged = true;
        SettingsChanged = true;
        settings.Password = arguments["password"];

        Console.WriteLine("  Setting login password: hidden (length " + settings.MqttPassword.Length + ")");
      }
      
      if (arguments.Contains("wifi-name"))
      {
        WifiSettingsChanged = true;
        SettingsChanged = true;
        settings.WiFiName = arguments["wifi-name"];

        Console.WriteLine("  Setting WiFi name: " + settings.WiFiName);
      }
      if (arguments.Contains("wifi-password"))
      {
        WifiSettingsChanged = true;
        SettingsChanged = true;
        settings.WiFiPassword = arguments["wifi-password"];

        Console.WriteLine("  Setting WiFi password: " + settings.WiFiPassword);
      }
      
      if (arguments.Contains("mqtt-host"))
      {
        MqttSettingsChanged = true;
        SettingsChanged = true;
        settings.MqttHost = arguments["mqtt-host"];

        Console.WriteLine("  Setting MQTT host: " + settings.MqttHost);
      }
      if (arguments.Contains("mqtt-username"))
      {
        MqttSettingsChanged = true;
        SettingsChanged = true;
        settings.MqttUsername = arguments["mqtt-username"];

        Console.WriteLine("  Setting MQTT username: " + settings.MqttUsername);
      }
      if (arguments.Contains("mqtt-password"))
      {
        MqttSettingsChanged = true;
        SettingsChanged = true;
        settings.MqttPassword = arguments["mqtt-password"];

        Console.WriteLine("  Setting MQTT password: hidden (length " + settings.MqttPassword.Length + ")");
      }
      if (arguments.Contains("mqtt-port"))
      {
        MqttSettingsChanged = true;
        SettingsChanged = true;
        settings.MqttPort = Convert.ToInt32(arguments["mqtt-port"]);

        Console.WriteLine("  Setting MQTT port: " + settings.MqttPort);
      }
      if (arguments.Contains("smtp-server"))
      {
        EmailSettingsChanged = true;
        SettingsChanged = true;
        settings.SmtpServer = arguments["smtp-server"];

        Console.WriteLine("  Setting SMTP server: " + settings.SmtpServer);
      }
      if (arguments.Contains("smtp-username"))
      {
        EmailSettingsChanged = true;
        SettingsChanged = true;
        settings.SmtpUsername = arguments["smtp-username"];

        Console.WriteLine("  Setting version: " + settings.SmtpUsername);
      }
      if (arguments.Contains("smtp-password"))
      {
        EmailSettingsChanged = true;
        SettingsChanged = true;
        settings.SmtpPassword = arguments["smtp-password"];

        Console.WriteLine("  Setting SMTP password: hidden (length: " + settings.SmtpPassword.Length + ")");
      }
      if (arguments.Contains("smtp-port"))
      {
        EmailSettingsChanged = true;
        SettingsChanged = true;
        settings.SmtpPort = Convert.ToInt32(arguments["smtp-port"]);

        Console.WriteLine("  Setting SMTP password: " + settings.SmtpPort);
      }
      if (arguments.Contains("email"))
      {
        EmailSettingsChanged = true;
        SettingsChanged = true;
        settings.Email = arguments["email"];

        Console.WriteLine("  Setting email address: " + settings.Email);
      }

      if (arguments.Contains("mock-systemctl"))
      {
        settings.IsMockSystemCtl = Convert.ToBoolean(arguments["mock-systemctl"]);

        if (settings.IsMockSystemCtl)
          Console.WriteLine("  Is mock systemctl: " + settings.IsMockSystemCtl);
      }
      if (arguments.Contains("mock-docker"))
      {
        settings.IsMockDocker = Convert.ToBoolean(arguments["mock-docker"]);

        if (settings.IsMockDocker)
          Console.WriteLine("  Is mock docker: " + settings.IsMockDocker);
      }
      
      // TODO: Clean up
      //if (SettingsChanged)
      //  SaveSettings(settings);

      return SettingsChanged;
    }

  }
}
