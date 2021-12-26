using System;
using System.IO;
using GrowSense.Core.Model;
using System.Xml.Serialization;
using System.Linq;
using GrowSense.Core.Tools;
namespace GrowSense.Core.Verifiers
{
  public class BaseVerifier
  {
    public CLIContext Context;
    public ProcessStarter Starter;
    public SystemCtlHelper SystemCtl;
    
    public BaseVerifier(CLIContext context)
    {
      Context = context;
      Starter = new ProcessStarter(context.IndexDirectory);
      SystemCtl = new SystemCtlHelper(context);
    }
    
    public void AssertDirectoryExists(string directory)
    {
      if (!Directory.Exists(directory))
        throw new DirectoryNotFoundException(directory);
    }

    public void AssertFileExists(string file)
    {
      if (!File.Exists(file))
        throw new FileNotFoundException(file);
    }

    public void AssertTextContains(string entireText, string searchTerm, string errorMessage)
    {
      Console.WriteLine("  Asserting that a particular search term is found in provided text...");
      Console.WriteLine("    Search term:");
      Console.WriteLine("      " + searchTerm);
      Console.WriteLine("");
      Console.WriteLine("----- Start Provided Text -----");
      Console.WriteLine(entireText);
      Console.WriteLine("----- End Provided Text -----");
      Console.WriteLine("");
      if (entireText.ToLower().IndexOf(searchTerm.ToLower()) == -1)
        throw new Exception(errorMessage);
      else
        Console.WriteLine("  Search term found: true");
    }
    
    
    public void AssertAppConfig(AppConfig config, string key, string value)
    {        
        var entry = config.AppSettings.Add.Where(e => e.Key == key).FirstOrDefault();

        if (entry is null)
          throw new Exception("Can't find app.config entry '" + key + "' in '" + config.FilePath + "'.");

        if (entry.Value != value)
          throw new Exception("Config value for '" + key + "' is '" + entry.Value + "' when it should be '" + value + "' in '" + config.FilePath + "'.");
    }

    public AppConfig DeserializeAppConfig(string configFilePath)
    {
    // TODO: This is a duplicate of BaseInstaller function. Move both to a common location.
    
      if (!File.Exists(configFilePath))
        throw new FileNotFoundException("Config file not found: " + configFilePath);
        
      var serializer = new XmlSerializer(typeof(AppConfig));

      AppConfig config = null;

      using (var stream = File.OpenRead(configFilePath))
      {
        config = (AppConfig)serializer.Deserialize(stream);
        config.FilePath = configFilePath;
      }
     

      return config;
    }

    public void AssertLegacySecurityFile(string fileKey, string value)
    {
      var filePath = Context.IndexDirectory + "/" + fileKey + ".security";

      if (!File.Exists(filePath))
        throw new FileNotFoundException("Can't find file: " + filePath);
    
      var foundValue = File.ReadAllText(filePath).Trim();

      if (foundValue != value)
        throw new Exception("Legacy security file value '" + foundValue + "' doesn't match expected '" + value + "' in file '" + filePath);
    }
    
    public void AssertSystemctlService(string serviceName)
    {
      AssertSystemctlServiceExists(serviceName);
      AssertSystemctlServiceIsRunning(serviceName);
    }

    public void AssertSystemctlServiceExists(string serviceName)
    {
      Console.WriteLine("Asserting systemctl service file exists...");

      Console.WriteLine("  Is mock systemctl: " + (this.SystemCtl.GetType().Name.IndexOf("Mock") > -1));
      
      var fileExists = SystemCtl.Exists(serviceName);

      if (!fileExists)
      {
        var filePath = SystemCtl.GetServiceFilePath(serviceName);
        
        throw new Exception("Systemctl service file " + serviceName + " doesn't exist at " + filePath);
      }
    }

    public void AssertSystemctlServiceIsRunning(string serviceName)
    {
      Console.WriteLine("  Asserting systemctl service is running...");

      Console.WriteLine("    Is mock systemctl: " + (this.SystemCtl.GetType().Name.IndexOf("Mock") > -1));

      var output = SystemCtl.StatusReport(serviceName);

      AssertTextContains(output, "active (running)", "Systemctl service is not running: " + serviceName);
      /*
      var mockSystemctlFile = Context.IndexDirectory + "/is-mock-systemctl.txt";

      var isMockSystemCtl = File.Exists(mockSystemctlFile) || Context.Settings.IsMockSystemCtl;

      Console.WriteLine("  Mock flag file exists: " + File.Exists(mockSystemctlFile));
      Console.WriteLine("  Mock setting: " + Context.Settings.IsMockSystemCtl);
      Console.WriteLine("  Is mock systemctl:" + isMockSystemCtl);

      if (isMockSystemCtl)
      {
        var cmd = "systemctl status " + serviceName.Replace(".service", "") + ".service";

        Starter.StartBash(cmd);

        var output = Starter.Output;

        AssertTextContains(output, "active (running)", "Systemctl service is not running: " + serviceName);
      }*/
    }
  }
}
