﻿
using System;
using NUnit.Framework;
using System.IO;

namespace GreenSense.Index.Tests.Integration
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

            var installedMqttBridgeConfigFile = "mock/mqtt-bridge/BridgeArduinoSerialToMqttSplitCsv.exe.config";
            CheckConfigFile (installedMqttBridgeConfigFile, host, username, password, port);

            var internalUIControllerConfigFile = "scripts/apps/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIController.exe.config";
            CheckConfigFile (internalUIControllerConfigFile, host, username, password, port);

            var installedUIControllerConfigFile = "mock/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIController.exe.config";
            CheckConfigFile (installedUIControllerConfigFile, host, username, password, port);

            Assert.IsFalse (starter.Starter.IsError, "An error occurred.");
        }

        public void CheckConfigFile (string configFileName, string host, string username, string password, int port)
        {
            var configFileContent = File.ReadAllText (configFileName);
			
            AssertConfigFileContains (configFileContent, "Host", host);
            AssertConfigFileContains (configFileContent, "UserId", username);
            AssertConfigFileContains (configFileContent, "Password", password);
            AssertConfigFileContains (configFileContent, "MqttPort", port.ToString ());

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
