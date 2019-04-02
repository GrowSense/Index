
using System;
using NUnit.Framework;
using System.IO;

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

            var successfulText = "Finished setting email details";

            Assert.IsTrue (output.Contains (successfulText), "Failed");

            var internalMqttBridgeConfigFile = "scripts/apps/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv.exe.config";
            CheckConfigFile (internalMqttBridgeConfigFile, smtpServer, adminEmail);

            var installedMqttBridgeConfigFile = "mock/mqtt-bridge/BridgeArduinoSerialToMqttSplitCsv.exe.config";
            CheckConfigFile (installedMqttBridgeConfigFile, smtpServer, adminEmail);

            var internalUIControllerConfigFile = "scripts/apps/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIController.exe.config";
            CheckConfigFile (internalUIControllerConfigFile, smtpServer, adminEmail);

            var installedUIControllerConfigFile = "mock/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIController.exe.config";
            CheckConfigFile (installedUIControllerConfigFile, smtpServer, adminEmail);

            Assert.IsFalse (starter.Starter.IsError, "An error occurred.");
        }

        public void CheckConfigFile (string configFileName, string smtpServer, string adminEmail)
        {
            var configFileContent = File.ReadAllText (configFileName);
			
            AssertConfigFileContains (configFileContent, "SmtpServer", smtpServer);
            AssertConfigFileContains (configFileContent, "EmailAddress", adminEmail);

        }

        public void AssertConfigFileContains (string configFileContent, string key, string value)
        {
            var pattern = "<add key=\"{0}\" value=\"{1}\"/>";
            var populatedPattern = String.Format (pattern, key, value);

            //Console.WriteLine ("Pattern: " + populatedPattern);

            Assert.IsTrue (configFileContent.Contains (populatedPattern),
                "Config file doesn't contain value with key '" + key + "' and value '" + value + "'.");
			
        }
    }
}
