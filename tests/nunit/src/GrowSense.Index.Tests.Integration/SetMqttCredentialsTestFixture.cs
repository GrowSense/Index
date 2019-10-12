
using System;
using NUnit.Framework;
using System.IO;
using System.Xml;
using System.Collections.Generic;

namespace GrowSense.Index.Tests.Integration
{
    [TestFixture (Category = "Integration")]
    public class SetMqttCredentialsTestFixture : BaseTestFixture
    {
        [Test]
        public void Test_SetMqttCredentialsScript ()
        {
            var scriptName = "set-mqtt-credentials";

            Console.WriteLine ("Script:");
            Console.WriteLine (scriptName);

            Console.WriteLine ("Running " + scriptName + " script");

            var random = new Random ();
            var host = "10.0.0." + random.Next (200);
            var username = "user" + random.Next (9);
            var password = "pass" + random.Next (9);
            var port = Convert.ToInt32 ("1234" + random.Next (9));

            var arguments = host + " " + username + " " + password + " " + port;

            var starter = GetTestProcessStarter (false);
            starter.IsMockMqttBridge = true;
            starter.Initialize ();

            var cmd = "sh " + scriptName + ".sh " + arguments;

            var output = starter.RunBash (cmd);

            var successfulText = "Finished setting MQTT credentials";

            Assert.IsTrue (output.Contains (successfulText), "Failed");

            var internalMqttBridgeConfigFile = "scripts/apps/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv.exe.config";
            CheckConfigFile (internalMqttBridgeConfigFile, host, username, password, port);

            var installedMqttBridgeConfigFile = "mock/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv.exe.config";
            CheckConfigFile (installedMqttBridgeConfigFile, host, username, password, port);

            var installedPackageMqttBridgeConfigFile = "mock/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config";
            CheckConfigFile (installedPackageMqttBridgeConfigFile, host, username, password, port);

            var internalUIControllerConfigFile = "scripts/apps/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIControllerConsole.exe.config";
            CheckConfigFile (internalUIControllerConfigFile, host, username, password, port);

            var installedUIControllerConfigFile = "mock/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIControllerConsole.exe.config";
            CheckConfigFile (installedUIControllerConfigFile, host, username, password, port);

            var installedPackageUIControllerConfigFile = "mock/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIController/lib/net40/Serial1602ShieldSystemUIControllerConsole.exe.config";
            CheckConfigFile (installedPackageUIControllerConfigFile, host, username, password, port);

            Assert.IsFalse (starter.Starter.IsError, "An error occurred.");
        }

        public void CheckConfigFile (string configFileName, string host, string username, string password, int port)
        {
            var configFileContent = File.ReadAllText (configFileName);

            Console.WriteLine ("");
            Console.WriteLine ("Checking config file...");
            Console.WriteLine ("");
            Console.WriteLine ("Config file path:");
            Console.WriteLine ("  " + configFileName);
            // Disabled to reduce log size. Can be enabled for debugging.
            //Console.WriteLine ("");
            //Console.WriteLine ("Config file content:");
            //Console.WriteLine (configFileContent);
            Console.WriteLine ("");
			
            AssertConfigFileContains (configFileContent, "Host", host);
            AssertConfigFileContains (configFileContent, "UserId", username);
            AssertConfigFileContains (configFileContent, "Password", password);
            AssertConfigFileContains (configFileContent, "MqttPort", port.ToString ());

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
