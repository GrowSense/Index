using System;
using System.IO;
namespace GrowSense.Core.Tools
{
  public class SshHelper
  {
    public SshTarget Target;

    public bool UseSshPass = true;
    public bool NoHostKeyChecking = true;    

    public string StartDirectory;
    public bool MoveToStartDirectory;

    public SshHelper(SshTarget target)
    {
      Target = target;
    }

    public string Execute(string command)
    {
      Console.WriteLine("Executing command via SSH...");
      
      var starter = new ProcessStarter();
      
      if (!String.IsNullOrEmpty(StartDirectory) && MoveToStartDirectory)
        command = "cd " + StartDirectory + " && " + command;

      command += " || exit 1";

      var options = "";
      if (NoHostKeyChecking)
      options = " -o \"StrictHostKeyChecking no\" ";

      var fullCommand = String.Format("ssh {3} {0}@{1} \"{2}\"", Target.Username, Target.Host, EscapeCommand(command), options);
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

    public void CopyFileTo(string sourceFile, string destinationFile)
    {
      Console.WriteLine("Copying file via SSH to target host...");
      Console.WriteLine("  Source: " + sourceFile);
      Console.WriteLine("  Destination: " + destinationFile);
      
      var homeFile = "~/" + Path.GetFileName(destinationFile);

      var starter = new ProcessStarter();

      Console.WriteLine("");
      Console.WriteLine("  Pushing file via scp to home directory...");

      var options = "";
      if (NoHostKeyChecking)
       options = " -o StrictHostKeyChecking=no ";
      
      var cmd = "sshpass -p " + Target.Password + " scp " + options + " " + sourceFile + " " + Target.Username + "@" + Target.Host + ":" + homeFile;
      //Console.WriteLine("  Command: " + cmd);     
      starter.StartBash(cmd);

      starter.OutputBuilder.Clear();

      Console.WriteLine("");
      Console.WriteLine("  Moving file into correct folder...");

      Execute("sudo mv " + homeFile + " " + destinationFile);

      Console.WriteLine("Finished pushing file to host target.");
    }

    public void DeleteDirectory(string directory)
    {
      Execute("sudo rm -R " + directory);
    }
  }
}
