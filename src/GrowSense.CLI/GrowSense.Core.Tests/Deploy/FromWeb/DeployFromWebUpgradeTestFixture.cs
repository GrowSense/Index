﻿using System;
using NUnit.Framework;
using Newtonsoft.Json;
using System.IO;
using GrowSense.Core.Tools;

namespace GrowSense.Core.Tests.Deploy.FromWeb
{
    [TestFixture(Category = "DeployFromWebUpgrade")]
    public class DeployFromWebUpgradeTestFixture : BaseTestFixture
    {
        [Test]
        public void Test_DeployUpgrade()
        {
            Console.WriteLine("Testing deploy upgrade...");

            var version = File.ReadAllText(ProjectDirectory + "/full-version.txt").Trim();

            var branch = new BranchDetector(ProjectDirectory).Branch;

            Console.WriteLine("  Version: " + version);
            Console.WriteLine("  Branch: " + branch);

            var deployment = GetDeploymentInfo(branch);

            Console.WriteLine("  Host: " + deployment.Ssh.Host);
            Console.WriteLine("  SSH Username: " + deployment.Ssh.Username);
            Console.WriteLine("  SSH Password: hidden (length " + (String.IsNullOrEmpty(deployment.Ssh.Password) ? deployment.Ssh.Password.Length : 0) + ")");
            Console.WriteLine("  SSH Port: " + deployment.Ssh.Port);

            Console.WriteLine("  MQTT Host: " + deployment.Mqtt.Host);
            Console.WriteLine("  MQTT Username: " + deployment.Mqtt.Username);
            Console.WriteLine("  MQTT Password: hidden (length " + (String.IsNullOrEmpty(deployment.Mqtt.Password) ? deployment.Mqtt.Password.Length : 0) + ")");
            Console.WriteLine("  MQTT Port: " + deployment.Mqtt.Port);

            var ssh = new SshHelper(deployment.Ssh);
            ssh.UseSshPass = true;

            var manager = new DeploymentManager(deployment, branch, version);

            if (!manager.IsInstalledOnTarget())
            {
                Assert.Fail("Can't upgrade when GrowSense is not currently installed.");
            }

            // TODO: Remove if not needed. Used for debugging
            //manager.Ssh.Execute("echo helloworld");
            //manager.Ssh.Execute("sudo echo hello > /usr/local/GrowSense/Installer/hello.txt");

            manager.EnableDownload = true;
            manager.AllowSkipDownload = false;
            manager.DownloadAndLaunchUpgrade();

            manager.SetConfigValues();

            Console.WriteLine("Setting supervisor settings...");
            manager.Ssh.Execute("echo 10 > supervisor-status-check-frequency.txt && echo 10 > supervisor-docker-check-frequency.txt && echo 10 > supervisor-mqtt-check-frequency.txt");

            Console.WriteLine("Checking system status...");
            manager.AssertStatus(version);

            Console.WriteLine("Deploy upgrade successful.");
        }


        public DeploymentInfo GetDeploymentInfo(string branch)
        {
            Console.WriteLine("  Getting deployment info...");

            if (Directory.Exists("deployments"))
                return GetDeploymentInfoFromSecurityFile(branch);
            else
                return GetDeploymentInfoFromEnvironmentVariables(branch);
        }

        public DeploymentInfo GetDeploymentInfoFromSecurityFile(string branch)
        {
            Console.WriteLine("    From security file...");
            var filePath = ProjectDirectory + "/deployments/" + branch + ".json.security";
            var deployment = JsonConvert.DeserializeObject<DeploymentInfo>(File.ReadAllText(filePath));
            return deployment;
        }

        public DeploymentInfo GetDeploymentInfoFromEnvironmentVariables(string branch)
        {
            Console.WriteLine("    From environment variables...");

            var deployment = new DeploymentInfo();
            //var branch = 
            //deployment.Name = "devstaging";
            deployment.Ssh = new SshTarget();
            deployment.Ssh.Host = GetEnvironmentVariable("SSH_HOST", branch);
            deployment.Ssh.Username = GetEnvironmentVariable("SSH_USERNAME", branch);
            deployment.Ssh.Password = GetEnvironmentVariable("SSH_PASSWORD", branch);
            deployment.Ssh.Port = Convert.ToInt32(GetEnvironmentVariable("SSH_PORT", branch));

            deployment.Mqtt = new MqttTarget();
            deployment.Mqtt.Host = GetEnvironmentVariable("MQTT_HOST", branch);
            deployment.Mqtt.Username = GetEnvironmentVariable("MQTT_USERNAME", branch);
            deployment.Mqtt.Password = GetEnvironmentVariable("MQTT_PASSWORD", branch);
            deployment.Mqtt.Port = Convert.ToInt32(GetEnvironmentVariable("MQTT_PORT", branch));

            var remote = new DeploymentInfo();

            remote.Ssh = new SshTarget();
            remote.Name = branch + "2";

            remote.Ssh.Host = GetEnvironmentVariable("SSH_HOST", branch + "2");
            remote.Ssh.Username = GetEnvironmentVariable("SSH_USERNAME", branch + "2");
            remote.Ssh.Password = GetEnvironmentVariable("SSH_PASSWORD", branch + "2");
            remote.Ssh.Port = Convert.ToInt32(GetEnvironmentVariable("SSH_PORT", branch + "2"));

            remote.Mqtt = new MqttTarget();
            remote.Mqtt.Host = GetEnvironmentVariable("MQTT_HOST", branch + "2");
            remote.Mqtt.Username = GetEnvironmentVariable("MQTT_USERNAME", branch + "2");
            remote.Mqtt.Password = GetEnvironmentVariable("MQTT_PASSWORD", branch + "2");
            remote.Mqtt.Port = Convert.ToInt32(GetEnvironmentVariable("MQTT_PORT", branch + "2"));

            if (!String.IsNullOrEmpty(remote.Ssh.Host))
            {
                deployment.Remotes = new DeploymentInfo[]{
          remote
        };
            }

            return deployment;
        }

        public string GetEnvironmentVariable(string variableName, string branch)
        {
            var fullName = "DEPLOY_" + branch.ToUpper() + "_" + variableName;
            var value = Environment.GetEnvironmentVariable(fullName);

            //if (String.IsNullOrEmpty(value))
            //  throw new ArgumentException("No environment variable found for: " + variableName);

            return value;

        }
    }
}