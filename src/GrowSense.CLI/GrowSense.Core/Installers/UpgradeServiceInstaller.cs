using System;
using GrowSense.Core.Verifiers;
using GrowSense.Core.Tools;
using System.IO;
using System.Linq;
using System.Threading;

namespace GrowSense.Core.Installers
{
    public class UpgradeServiceInstaller : BaseInstaller
    {
        public string ServiceTitle = "GrowSense System Upgrade Service";
        public string ServiceCommand = "mkdir -p /usr/local/GrowSense/Index/; cd /usr/local/GrowSense/Index/; bash upgrade.sh";

        public CLIContext Context;
        public UpgradeServiceVerifier Verifier;
        public SystemCtlHelper SystemCtl;

        public UpgradeServiceInstaller(CLIContext context)
        {
            Context = context;
            Verifier = new UpgradeServiceVerifier(context);
            SystemCtl = new SystemCtlHelper(context);
        }

        public void Install()
        {
            Console.WriteLine("Installing GrowSense upgrade service...");

            SystemCtl.CreateAndInstallService("growsense-upgrade", ServiceTitle, ServiceCommand, false);

            Verify();
        }

        public void Verify()
        {
            Verifier.Verify();
        }
    }
}