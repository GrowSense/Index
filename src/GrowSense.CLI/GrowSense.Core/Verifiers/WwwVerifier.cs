using System;
using System.IO;
using System.Xml.Linq;
using System.Xml;
using System.Linq;
using System.Xml.Serialization;
using GrowSense.Core.Model;
using Newtonsoft.Json;
using GrowSense.Core.Tools;
using System.Threading;

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

            VerifyWebApplicationStatusIsOnline();
        }

        public void VerifyWebApplicationStatusIsOnline()
        {
            Console.WriteLine("Verifying www application is online...");

            var cmd = "curl -s http://localhost/StatusJson.aspx";

            Starter.WriteOutputToConsole = false;
            Starter.ThrowExceptionOnError = false;
            Starter.Start(cmd);

            var needsRestart = false;

            if (Starter.IsError)
                needsRestart = true;

            if (!Starter.IsError)
            {
                var jsonResult = Starter.Output.Trim();

                var result = JsonConvert.DeserializeObject<WwwSystemStatusInfo>(jsonResult);

                Console.WriteLine("  Status code: " + result.StatusCode);
                Console.WriteLine("  Status text: " + result.StatusText);

                needsRestart = result.StatusCode != (int)WwwSystemStatusEnum.Online;
            }

            if (needsRestart)
            {
                Console.WriteLine("  Not online. Restarting service...");
                SystemCtl.Restart("growsense-www");
            }
            else
            {
                Console.WriteLine("  Online.");
            }
        }
    }
}
