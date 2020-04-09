using System;
using NUnit.Framework;
using System.IO;
using System.Xml;
using System.Threading;

namespace GrowSense.Index.Tests.Integration
{
  [TestFixture (Category = "Integration")]
  public class SetEmailDetailsTestFixture : BaseTestFixture
  {
    [Test]
    public void Test_SetEmailDetailsScript ()
    {
      var scriptName = "set-email-details";

      Console.WriteLine ("Script:");
      Console.WriteLine (scriptName);

      Console.WriteLine ("Running " + scriptName + " script");

      var random = new Random ();
      var smtpServer = "smtp.example" + random.Next (200) + ".com";
      var adminEmail = "user" + random.Next (9) + "@example.com";
      var smtpUsername = "user" + random.Next (100);
      var smtpPassword = "pass" + random.Next (100);
      var smtpPort = random.Next (100);

      var arguments = smtpServer + " " + adminEmail + " " + smtpUsername + " " + smtpPassword + " " + smtpPort;

      var starter = GetTestProcessStarter ();

      var cmd = "sh " + scriptName + ".sh " + arguments;

      var output = starter.RunBash (cmd);

      Thread.Sleep (1000);

      var successfulText = "Finished setting email details";

      Assert.IsTrue (output.Contains (successfulText), "Failed");

      Console.WriteLine ("Checking MQTT bridge config files...");

      //var internalMqttBridgeConfigFile = "scripts/apps/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv.exe.config";
      //CheckConfigFile (internalMqttBridgeConfigFile, smtpServer, adminEmail);

      var internalPackageMqttBridgeConfigFile = "scripts/apps/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config";
      CheckConfigFile (internalPackageMqttBridgeConfigFile, smtpServer, adminEmail, smtpUsername, smtpPassword, smtpPort);


      //var installedMqttBridgeConfigFile = "mock/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv.exe.config";
      //CheckConfigFile (installedMqttBridgeConfigFile, smtpServer, adminEmail);

      var installedPackageMqttBridgeConfigFile = "mock/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config";
      CheckConfigFile (installedPackageMqttBridgeConfigFile, smtpServer, adminEmail, smtpUsername, smtpPassword, smtpPort);


      Console.WriteLine ("Checking serial UI controller config files...");

      var internalPackageUIControllerConfigFile = "scripts/apps/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIController/lib/net40/Serial1602ShieldSystemUIControllerConsole.exe.config";
      CheckConfigFile (internalPackageUIControllerConfigFile, smtpServer, adminEmail, smtpUsername, smtpPassword, smtpPort);

      //var installedUIControllerConfigFile = "mock/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIControllerConsole.exe.config";
      //CheckConfigFile (installedUIControllerConfigFile, smtpServer, adminEmail);

      var installedPackageUIControllerConfigFile = "mock/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIController/lib/net40/Serial1602ShieldSystemUIControllerConsole.exe.config";
      CheckConfigFile (installedPackageUIControllerConfigFile, smtpServer, adminEmail, smtpUsername, smtpPassword, smtpPort);

      Assert.IsFalse (starter.Starter.IsError, "An error occurred.");
    }

    public void CheckConfigFile (string configFileName, string smtpServer, string adminEmail, string smtpUsername, string smtpPassword, int smtpPort)
    {
      Console.WriteLine ("Checking config file for email details...");
      Console.WriteLine ("  " + configFileName);

      var configFileContent = File.ReadAllText (configFileName);
			
      AssertConfigFileContains (configFileContent, "SmtpServer", smtpServer);
      AssertConfigFileContains (configFileContent, "EmailAddress", adminEmail);
      AssertConfigFileContains (configFileContent, "SmtpUsername", smtpUsername);
      AssertConfigFileContains (configFileContent, "SmtpPassword", smtpPassword);
      AssertConfigFileContains (configFileContent, "SmtpPort", smtpPort.ToString ());

    }

    public void AssertConfigFileContains (string configFileContent, string key, string value)
    {
        
      var doc = new XmlDocument ();
      doc.LoadXml (configFileContent);

      var configElement = doc.SelectSingleNode ("configuration/appSettings/add[@key='" + key + "']");

      Assert.IsNotNull (configElement, "Can't find config element for '" + key + "' key.");

      var valueAttribute = configElement.Attributes ["value"];

      var valueInConfigFile = valueAttribute.Value;

      Assert.AreEqual (value, valueInConfigFile, "Value for '" + key + "' wasn't set in config file.");

    }
  }
}
