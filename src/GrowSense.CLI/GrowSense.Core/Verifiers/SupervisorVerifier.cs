using System;
using System.IO;
using System.Xml.Linq;
using System.Xml;
using System.Linq;
using System.Xml.Serialization;
using GrowSense.Core.Model;

namespace GrowSense.Core.Verifiers
{
  public class SupervisorVerifier : BaseVerifier
  {
    public SupervisorVerifier(CLIContext context) : base(context)
    {
    }
    
    
    public void Verify()
    {
      Console.WriteLine("Verifying supervisor service is installed and running...");
      
      EnsureSystemctlServiceIsRunning("growsense-supervisor");
    }
  }
}
