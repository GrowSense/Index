﻿using System;
using System.Text;
using System.Diagnostics;
using System.Collections.Generic;
using System.IO;

namespace GrowSense.Core
{
    public class ProcessStarter
    {
        public bool IsError { get; set; }

        public bool ThrowExceptionOnError = true;
        public bool WriteOutputToConsole = true;
        public bool IsVerbose = false;
        public string OriginalDirectory = "";
        public string WorkingDirectory = "";

        public string Output
        {
            get { return OutputBuilder.ToString(); }
        }

        public bool EnableErrorCheckingByTextMatching = true;

        public StringBuilder OutputBuilder = new StringBuilder();

        public ProcessStarter() : this(Environment.CurrentDirectory)
        {
        }

        public ProcessStarter(string workingDirectory)
        {
            WorkingDirectory = workingDirectory;
            OriginalDirectory = Environment.CurrentDirectory;
        }

        public Process Start(params string[] commandParts)
        {
            return Start(String.Join(" ", commandParts));
        }

        public Process Start(string command, string argument1, params string[] otherArguments)
        {
            var arguments = new List<string>();
            arguments.Add(argument1);
            arguments.AddRange(otherArguments);

            return Start(command, arguments.ToArray());
        }

        public Process Start(string command, string argument1, string argument2, params string[] otherArguments)
        {
            var arguments = new List<string>();
            arguments.Add(argument1);
            arguments.Add(argument2);
            arguments.AddRange(otherArguments);

            return Start(command, arguments.ToArray());
        }

        public Process Start(string command)
        {
            if (command.Contains(" "))
            {
                var cmd = String.Empty;
                var arguments = new string[] { };
                var list = new List<string>(command.Split(' '));
                cmd = list[0];
                list.RemoveAt(0);
                arguments = list.ToArray();
                return Start(cmd, arguments);
            }
            else
            {
                return Start(command, new string[] { });
            }
        }

        /// <summary>
        /// Starts/executes a process in the current thread.
        /// </summary>
        /// <param name='command'></param>
        /// <param name='arguments'></param>
        public virtual Process Start(string command, params string[] arguments)
        {
            return Start(command, String.Join(" ", arguments));
        }

        /// <summary>
        /// Starts/executes a process in the current thread.
        /// </summary>
        /// <param name='command'></param>
        /// <param name='arguments'></param>
        public virtual Process Start(string command, string arguments)
        {
            if (IsVerbose)
            {
                Console.WriteLine("");
                Console.WriteLine("Starting process:");
                Console.WriteLine(command + " " + arguments);
                Console.WriteLine("");
            }

            // If the command has an extension (and is therefore an actual file)
            if (Path.GetExtension(command) != String.Empty)
            {
                // If the file doesn't exist
                if (!File.Exists(Path.GetFullPath(command)))
                    throw new ArgumentException("Cannot find the file '" + Path.GetFullPath(command) + "'.");
            }

            // Create the process start information
            ProcessStartInfo info = new ProcessStartInfo(
                               command,
                               arguments
                           );

            // Configure the process
            info.UseShellExecute = false;
            info.RedirectStandardInput = true;
            info.RedirectStandardOutput = true;
            info.RedirectStandardError = true;
            info.CreateNoWindow = true;

            // TODO: Remove if not needed
            //info.ErrorDialog = true;

            // Start the process
            Process process = new Process();

            process.StartInfo = info;

            process.EnableRaisingEvents = true;

            var c = Console.Out;

            // Output the errors to the console
            process.ErrorDataReceived += new DataReceivedEventHandler(
                delegate (object sender, DataReceivedEventArgs e)
                {
                    if (WriteOutputToConsole)
                    {
                        Console.SetOut(c);
                        c.WriteLine(e.Data);
                    }
                    OutputBuilder.AppendLine(e.Data);
                }
            );

            // Output the data to the console
            process.OutputDataReceived += new DataReceivedEventHandler(
                delegate (object sender, DataReceivedEventArgs e)
                {
                    if (WriteOutputToConsole)
                    {
                        Console.SetOut(c);
                        c.WriteLine(e.Data);
                    }
                    OutputBuilder.AppendLine(e.Data);
                }
            );

            try
            {
                Directory.SetCurrentDirectory(WorkingDirectory);

                process.Start();

                process.BeginOutputReadLine();
                process.BeginErrorReadLine();

                process.WaitForExit();

                Directory.SetCurrentDirectory(OriginalDirectory);

                // If the exit code is NOT zero then an error must have occurred
                IsError = (process.ExitCode != 0);

                CheckForErrors(command + " " + arguments);
            }
            catch (Exception ex)
            {
                IsError = true;

                Console.WriteLine(Output);

                var title = "\"Error starting process\"" + ": " + command + " " + arguments;

                OutputBuilder.Append(title);
                OutputBuilder.Append(ex.ToString());

                if (ThrowExceptionOnError)
                    throw new Exception(title, ex);
                else
                {
                    Console.WriteLine("");
                    Console.WriteLine(title);
                    Console.WriteLine(ex.ToString());
                    Console.WriteLine("");
                }
            }

            return process;
        }

        public Process StartBash(string command)
        {

            var fullCommand = "/bin/bash -c \"" + command.Replace("\"", "\"\"") + "\"";
            return Start(fullCommand);

        }

        public string[] FixArguments(string[] arguments)
        {
            List<string> argsList = new List<string>();

            if (arguments != null && arguments.Length > 0)
                argsList.AddRange(arguments);

            for (int i = 0; i < argsList.Count; i++)
            {
                if (!String.IsNullOrEmpty(argsList[i]))
                {
                    argsList[i] = FixArgument(argsList[i]);
                }
            }

            return argsList.ToArray();
        }

        public string FixArgument(string argument)
        {
            if (argument.Contains(" ")
            && argument.IndexOf("\"") != 0)
                return @"""" + argument + @"""";
            else
                return argument;
        }

        public void CheckForErrors(string command)
        {
            if (EnableErrorCheckingByTextMatching)
            {
                if (Output.IndexOf("No such file or directory") > -1)
                    throw new Exception("No such file or directory");

                // TODO: Disabled because it throws false positives
                //if (Output.IndexOf("Exception") > -1)
                //  throw new Exception("An exception was thrown.");

                if (IsError && ThrowExceptionOnError)
                    throw new Exception("Detected error running: " + command);
            }
        }

    }
}