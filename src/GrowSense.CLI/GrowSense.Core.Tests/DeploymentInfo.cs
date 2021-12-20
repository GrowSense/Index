using System;
using GrowSense.Core.Tools;
namespace GrowSense.Core.Tests
{
  public class DeploymentInfo
  {
    public SshTarget Ssh = new SshTarget();
    public MqttTarget Mqtt = new MqttTarget();
  
    public DeploymentInfo()
    {
    }

    public string Branch { get; set; }
    public string Name { get; set; }
    
    public void Update()
    {
    
    }
  }
}
