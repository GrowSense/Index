using System;
using System.IO;

namespace GrowSense.Core
{
    public class VersionReader
    {
        public CLIContext Context; 

        public VersionReader(CLIContext context)
        {
            Context = context;
        }

        public string ReadVersionInSettings()
        {
            return Context.Settings.Version;
        }

        public string ReadVersionInFiles()
        {
            var filesVersion = File.ReadAllText(Context.IndexDirectory + "/full-version.txt");

            return filesVersion.Trim();
        }

        public void WriteVersionsToConsole()
        {
            Console.WriteLine("Checking GrowSense version...");

            Console.WriteLine("  Files: " + ReadVersionInFiles());

            Console.WriteLine("  Settings: " + ReadVersionInSettings());
        }
    }
}
