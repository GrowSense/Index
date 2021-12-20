using System;
namespace GrowSense.Core.Tools
{
  public class SshHelper
  {
    public SshTarget Target;

    public bool UseSshPass = true;

    public string StartDirectory;

    public SshHelper(SshTarget target)
    {
      Target = target;
    }

    public string Execute(string command)
    {
      Console.WriteLine("Executing command via SSH...");
      
      var starter = new ProcessStarter();
      
      if (!String.IsNullOrEmpty(StartDirectory))
        command = "cd " + StartDirectory + " && " + command;

      command += " || exit 1";

      var fullCommand = String.Format("ssh {0}@{1} \"{2}\"", Target.Username, Target.Host, EscapeCommand(command));
      if (UseSshPass)
        fullCommand = String.Format("sshpass -p {0} {1}", Target.Password, fullCommand);

      
      
      
      Console.WriteLine("  " + fullCommand);

      starter.Start(fullCommand);

      if (starter.IsError)
        throw new Exception("An error occurred.");

      return starter.Output;
    }

    public string EscapeCommand(string command)
    {
      return command.Replace("\"", "\"\"");
    }

    public bool DirectoryExists(string directory)
    {
      var cmd = "[ -d \"" + directory + "\" ] && echo true || echo false";
      var output = Execute(cmd);
      var result = Convert.ToBoolean(output.Trim());
      return result;
    }
  }
}
