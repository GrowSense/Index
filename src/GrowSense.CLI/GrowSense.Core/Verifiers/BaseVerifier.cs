using System;
using System.IO;
using GrowSense.Core.Model;
using System.Xml.Serialization;
using System.Linq;
namespace GrowSense.Core.Verifiers
{
  public class BaseVerifier
  {
    public CLIContext Context;
    public ProcessStarter Starter;
    
    public BaseVerifier(CLIContext context)
    {
      Context = context;
      Starter = new ProcessStarter(context.WorkingDirectory);
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
      if (entireText.IndexOf(searchTerm) == -1)
        throw new Exception(errorMessage);
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

  }
}
