using System;
using GrowSense.Core.Tools;
namespace GrowSense.Core.Tests
{
  public class DeploymentInfo
  {
    public string Branch { get; set; }
    public string Name { get; set; }
    
    public string Username { get; set; }
    public string Password { get; set; }
    
    public SshTarget Ssh = new SshTarget();
    public MqttTarget Mqtt = new MqttTarget();
    public DeploymentInfo[] Remotes = new DeploymentInfo[] { };
  
    public DeploymentInfo()
    {
    }


    public void Update()
    {
    
    }
  }
}
