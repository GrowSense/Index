using System;
namespace GrowSense.Core
{
    public class StatusChecker
    {
        public CLIContext Context { get; set; }

        public StatusChecker(CLIContext context)
        {
            Context = context;
        }

        public void WriteStatusToConsole()
        {
            Console.WriteLine("GrowSense Status");

            Console.WriteLine("  Version: " + Context.Settings.Version);
        }
    }
}
