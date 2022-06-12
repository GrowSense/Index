using System;
using System.IO;
namespace GrowSense.Core.Tools
{
    public class SystemCtlHelper
    {
        public CLIContext Context;
        public ProcessStarter Starter;

        public SystemCtlHelper(CLIContext context)
        {
            Context = context;
            Starter = new ProcessStarter(Context.IndexDirectory);
        }

        public virtual string StatusReport(string serviceName)
        {
            return Run("status " + serviceName);
        }

        public virtual bool Exists(string serviceName)
        {
            //var isMockSystemCtl = IsMockSystemCtl();

            var servicePath = GetServiceFilePath(serviceName);

            //if (File.Exists(mockSystemctlFile))
            //  servicePath = Context.IndexDirectory + "/mock/services/" + serviceName.Replace(".service", "") + ".service";

            return File.Exists(servicePath);
        }

        public virtual string Run(string command)
        {
            if (Context.Settings.IsMockSystemCtl)
            {
                var output = "[mock] systemctl " + command;
                Console.WriteLine(output);
                return output;
            }
            else
            {
                Starter.StartBash("sudo systemctl " + command);
                return Starter.Output;
            }
        }

        public virtual string GetServiceFilePath(string serviceName)
        {
            var serviceFileName = serviceName.Replace(".service", "") + ".service";
            var serviceFilePath = "";
            if (Context.Settings.IsMockSystemCtl)
                serviceFilePath = Context.IndexDirectory + "/mock/services/" + serviceFileName;
            else
                serviceFilePath = "/lib/systemd/system/" + serviceFileName;

            if (!Directory.Exists(Path.GetDirectoryName(serviceFilePath)))
                Directory.CreateDirectory(Path.GetDirectoryName(serviceFilePath));

            return serviceFilePath;
        }

        public SystemCtlServiceStatus Status(string serviceName)
        {
            if (Context.Settings.IsMockSystemCtl)
                return SystemCtlServiceStatus.Active;
            else
            {
                var statusReport = StatusReport(serviceName);

                if (statusReport.IndexOf("active (running)") > -1)
                    return SystemCtlServiceStatus.Active;
                else if (statusReport.IndexOf("failed") > -1)
                    return SystemCtlServiceStatus.Failed;
                else if (statusReport.IndexOf("not-found") > -1)
                    return SystemCtlServiceStatus.NotFound;
                else if (statusReport.IndexOf("dead") > -1)
                    return SystemCtlServiceStatus.Dead;
                else
                {
                    Console.WriteLine("----- Start Status Report -----");
                    Console.WriteLine(statusReport);
                    Console.WriteLine("----- End Status Report");

                    throw new Exception("Failed to detect systemctl service status.");
                }
            }
        }

        public void Reload()
        {
            Console.WriteLine("Reloading systemctl service...");
            Run("daemon-reload");
        }

        public void Start(string serviceName)
        {
            Console.WriteLine("Starting systemctl service...");
            Console.WriteLine("  Name: " + serviceName);

            Run("start " + serviceName);
        }

        public void Restart(string serviceName)
        {
            Console.WriteLine("Restarting systemctl service...");
            Console.WriteLine("  Name: " + serviceName);

            Run("restart " + serviceName);
        }

        public void Enable(string serviceName)
        {
            Console.WriteLine("Enabling systemctl service...");
            Console.WriteLine("  Name: " + serviceName);

            Run("enable " + serviceName);
        }

        public void Stop(string serviceName)
        {
            Console.WriteLine("Stopping systemctl service...");
            Console.WriteLine("  Name: " + serviceName);
            Run("stop " + serviceName);
        }

        public void Disable(string serviceName)
        {
            Run("disable " + serviceName);
        }

        public void CreateAndInstallService(string name, string title, string command, bool startService)
        {
            Console.WriteLine("Creating systemctl service: " + name);
            Console.WriteLine("  Title: " + title);
            Console.WriteLine("  Command: " + command);

            var serviceContent = CreateSystemCtlFileContent(title, command);

            var serviceFilePath = GetServiceFilePath(name);

            Console.WriteLine("  Path: " + serviceFilePath);

            if (!Directory.Exists(Path.GetDirectoryName(serviceFilePath)))
                Directory.CreateDirectory(Path.GetDirectoryName(serviceFilePath));

            File.WriteAllText(serviceFilePath, serviceContent);

            if (startService)
            {
                Start(name);
            }
        }

        public string CreateSystemCtlFileContent(string title, string command)
        {
            var template = @"
 [Unit]
 Description={Title}
 After=multi-user.target

 [Service]
 Type = idle
 ExecStart=/bin/bash -c ""{Command}""

 [Install]
 WantedBy=multi-user.target";

            var content = template;

            content = content.Replace("{Title}", title);
            content = content.Replace("{Command}", command);

            return content;
        }
    }
}