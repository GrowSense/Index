
using System;
using NUnit.Framework;
using System.IO;
using System.Xml;
using System.Threading;

namespace GreenSense.Index.Tests.Integration
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

            var arguments = smtpServer + " " + adminEmail;

            var starter = GetTestProcessStarter (false);
            starter.IsMockUIController = true;
            starter.Initialize ();

            var cmd = "sh " + scriptName + ".sh " + arguments;

            var output = starter.RunBash (cmd);

            Thread.Sleep (1000);

            var successfulText = "Finished setting email details";

            Assert.IsTrue (output.Contains (successfulText), "Failed");

            var internalMqttBridgeConfigFile = "scripts/apps/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv.exe.config";
            CheckConfigFile (internalMqttBridgeConfigFile, smtpServer, adminEmail);

            var installedMqttBridgeConfigFile = "mock/mqtt-bridge/BridgeArduinoSerialToMqttSplitCsv.exe.config";
            CheckConfigFile (installedMqttBridgeConfigFile, smtpServer, adminEmail);

            var internalUIControllerConfigFile = "scripts/apps/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIControllerConsole.exe.config";
            CheckConfigFile (internalUIControllerConfigFile, smtpServer, adminEmail);

            var installedUIControllerConfigFile = "mock/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIControllerConsole.exe.config";
            CheckConfigFile (installedUIControllerConfigFile, smtpServer, adminEmail);

            Assert.IsFalse (starter.Starter.IsError, "An error occurred.");
        }

        public void CheckConfigFile (string configFileName, string smtpServer, string adminEmail)
        {
            Console.WriteLine ("Checking config file for email details...");
            Console.WriteLine ("  " + configFileName);

            var configFileContent = File.ReadAllText (configFileName);
			
            AssertConfigFileContains (configFileContent, "SmtpServer", smtpServer);
            AssertConfigFileContains (configFileContent, "EmailAddress", adminEmail);

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
