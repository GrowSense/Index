using System;
using System.IO;
using System.Xml.Linq;
using System.Xml;
using System.Linq;
using System.Xml.Serialization;
using GrowSense.Core.Model;

namespace GrowSense.Core.Verifiers
    {
        public class UpgradeServiceVerifier : BaseVerifier
        {
            public UpgradeServiceVerifier(CLIContext context) : base(context)
            {
            }


            public void Verify()
            {
                Console.WriteLine("Verifying upgrade service is installed...");

                AssertSystemctlServiceExists("growsense-upgrade");
            }
        }
    }
