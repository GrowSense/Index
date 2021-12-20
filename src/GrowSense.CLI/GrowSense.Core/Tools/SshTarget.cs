using System;
namespace GrowSense.Core.Tools
{
  public class SshTarget
  {
    public string Username { get; set; }
    public string Host { get; set; }
    public string Password { get; set; }
    public int Port { get; set; }

    public SshTarget()
    {
    }

  }
}
