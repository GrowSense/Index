using System;
using System.IO;
using GrowSense.Core.Model;
using System.Xml.Serialization;
using System.Xml;
namespace GrowSense.Core.Installers
{
  public class BaseInstaller
  {
    public AptHelper Apt;
    
    public BaseInstaller()
    {
      Apt = new AptHelper();
    }


    public void CopyFiles(string sourceDir, string destinationDir, params string[] filesToCopy)
    {
      Console.WriteLine("Copying files...");
      foreach (var filePattern in filesToCopy)
      {
        Console.WriteLine("  Pattern: " + filePattern);
        
        foreach (var file in Directory.GetFiles(sourceDir, filePattern))
        {
          Console.WriteLine("  " + file);

          var source = file;
          var destination = file.Replace(sourceDir, destinationDir);// + "/" + file;

          Console.WriteLine("    Source: " + source);
          Console.WriteLine("    Destination: " + destination);

          File.Copy(source, destination, true);
        }
        
      }
    }
    
    public void CopyDirectories(string sourceDir, string destinationDir, params string[] dirsToCopy)
    {
      Console.WriteLine("Copying directories...");
      foreach (var dir in dirsToCopy)
      {
        Console.WriteLine("  " + dir);

        var source = sourceDir + "/" + dir;
        var destination = destinationDir + "/" + dir;

        Console.WriteLine("    Source: " + source);
        Console.WriteLine("    Destination: " + destination);

        CopyDirectory(source, destination, true);
      }
    }

    public void CopyDirectory(string sourceDirName, string destDirName, bool copySubDirs)
    {
      // Get the subdirectories for the specified directory.
      DirectoryInfo dir = new DirectoryInfo(sourceDirName);

      if (!dir.Exists)
      {
        throw new DirectoryNotFoundException(
            "Source directory does not exist or could not be found: "
            + sourceDirName);
      }

      DirectoryInfo[] dirs = dir.GetDirectories();

      // If the destination directory doesn't exist, create it.       
      Directory.CreateDirectory(destDirName);

      // Get the files in the directory and copy them to the new location.
      FileInfo[] files = dir.GetFiles();
      foreach (FileInfo file in files)
      {
        string tempPath = Path.Combine(destDirName, file.Name);
        file.CopyTo(tempPath, true);
      }

      // If copying subdirectories, copy them and their contents to new location.
      if (copySubDirs)
      {
        foreach (DirectoryInfo subdir in dirs)
        {
          string tempPath = Path.Combine(destDirName, subdir.Name);
          CopyDirectory(subdir.FullName, tempPath, copySubDirs);
        }
      }
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

    public void SerializeAppConfig(AppConfig config, string filePath)
    {
      /*var serializer = new XmlSerializer(typeof(AppConfig));
      using (var stream = File.OpenWrite(filePath))
      {
        serializer.Serialize(stream, config);
      }*/
      
        // Remove Declaration
  var settings = new XmlWriterSettings
         {
              Indent = true,
              OmitXmlDeclaration = true
         };
    
  // Remove Namespace
     var ns = new XmlSerializerNamespaces(new[] { XmlQualifiedName.Empty });
     
      File.Delete(filePath);
      
    // using (var stream = File.Create(filePath))
     using (var writer = XmlWriter.Create(filePath))
     {
         var serializer = new XmlSerializer(typeof(AppConfig));
         serializer.Serialize(writer, config, ns);
         //return stream.ToString();
     }

      Console.WriteLine("----- Start Output -----");
      Console.WriteLine(File.ReadAllText(filePath));
      Console.WriteLine("----- End Output -----");
    }
  }
}