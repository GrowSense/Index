using System;
using System.IO;
using System.Xml.Linq;
using System.Xml;
using System.Linq;
using System.Xml.Serialization;
using GrowSense.Core.Model;

namespace GrowSense.Core.Verifiers
{
  public class WwwVerifier : BaseVerifier
  {
    public WwwVerifier(CLIContext context) : base(context)
    {
    }
    
    
    public void Verify()
    {
      Console.WriteLine("Verifying www service is installed and running...");
      
      AssertSystemctlService("growsense-www");
    }
  }
}
