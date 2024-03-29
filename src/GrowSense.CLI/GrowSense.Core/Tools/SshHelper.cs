﻿using System;
using System.IO;
namespace GrowSense.Core.Tools
{
    public class SshHelper
    {
        public SshTarget Target;

        public bool UseSshPass = true;
        public bool NoHostKeyChecking = true;

        public string StartDirectory;
        public bool MoveToStartDirectory = true;
        public bool FailOnError = true;

        public ProcessStarter Starter;

        public SshHelper(SshTarget target)
        {
            Target = target;
            Starter = new ProcessStarter();
        }

        public string Execute(string command)
        {
            return Execute(command, MoveToStartDirectory, FailOnError);
        }

        public string Execute(string command, bool moveToStartDirectory, bool failOnError)
        {
            Console.WriteLine("Executing command via SSH...");

            if (!String.IsNullOrEmpty(StartDirectory) && moveToStartDirectory)
                command = "cd " + StartDirectory + " && " + command;

            if (failOnError)
                command += " || exit 1";

            var options = "";
            if (NoHostKeyChecking)
                options = " -o \"StrictHostKeyChecking no\" ";

            var fullCommand = String.Format("ssh {3} {0}@{1} \"{2}\"", Target.Username, Target.Host, EscapeCommand(command), options);

            if (UseSshPass)
                fullCommand = String.Format("sshpass -p {0} {1}", Target.Password, fullCommand);

            Console.WriteLine("  " + fullCommand);

            Starter.Start(fullCommand);

            if (Starter.IsError)
                throw new Exception("An error occurred.");

            var output = Starter.Output;

            Starter.OutputBuilder.Clear();

            return output;
        }

        public bool FileExists(string file)
        {
            var cmd = "[ -f \"" + file + "\" ] && echo true || echo false";
            var output = Execute(cmd);
            var result = Convert.ToBoolean(output.Trim());
            return result;
        }

        public string EscapeCommand(string command)
        {
            return command.Replace("\"", "\"\"");
        }

        public bool DirectoryExists(string directory)
        {
            var cmd = "[ -d \"" + directory + "\" ] && echo $'\n'true || echo $'\n'false"; // Newline before value so it's placed on a new line, and it can be parsed even if the SSH command outputs messages before it
            var output = Execute(cmd);
            try
            {
                var lines = output.Trim().Split('\n');
                var lastLine = lines[lines.Length - 1].Trim();
                Console.WriteLine("Last line: " + lastLine);
                var result = Convert.ToBoolean(lastLine);
                return result;
            }
            catch (FormatException ex)
            {
                Console.WriteLine("Error parsing output...");
                Console.WriteLine("----- Start Output ----");
                Console.WriteLine(output.Trim());
                Console.WriteLine("----- Finish Output -----");
                throw ex;
            }
        }

        public void CopyFileTo(string sourceFile, string destinationFile)
        {
            Console.WriteLine("Copying file via SSH to target host...");
            Console.WriteLine("  Source: " + sourceFile);
            Console.WriteLine("  Destination: " + destinationFile);

            var homeFile = "~/" + Path.GetFileName(destinationFile);

            Console.WriteLine("  Temporary location in home (copied to here first): " + homeFile);

            var starter = new ProcessStarter();

            Console.WriteLine("");
            Console.WriteLine("  Pushing file via scp to home directory...");

            var options = "";
            if (NoHostKeyChecking)
                options = " -o StrictHostKeyChecking=no ";

            var cmd = "sshpass -p '" + Target.Password + "' scp " + options + " " + sourceFile + " " + Target.Username + "@" + Target.Host + ":" + homeFile;
            //Console.WriteLine("  Command: " + cmd);     
            starter.StartBash(cmd);

            starter.OutputBuilder.Clear();

            Console.WriteLine("");
            Console.WriteLine("  Making destination directory...");
            Console.WriteLine("    " + Path.GetDirectoryName(destinationFile));

            Execute("sudo mkdir -p " + Path.GetDirectoryName(destinationFile));

            Console.WriteLine("");
            Console.WriteLine("  Moving file into correct folder...");

            Execute("sudo mv " + homeFile + " " + destinationFile);

            Console.WriteLine("Finished pushing file to host target.");
        }

        public void CreateDirectory(string directory)
        {
            Execute("sudo mkdir -p " + directory, false, false);
        }

        public void DeleteDirectory(string directory)
        {
            Execute("sudo rm -R " + directory);
        }
    }
}