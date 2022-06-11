using System;
using GrowSense.Core.Verifiers;
using System.IO;
using System.Linq;
using System.Threading;

namespace GrowSense.Core.Installers
    {
        public class UpgradeServiceInstaller : BaseInstaller
        {
            public CLIContext Context;
            public ProcessStarter Starter;
            public UpgradeServiceVerifier Verifier;

            public UpgradeServiceInstaller(CLIContext context)
            {
                Context = context;
                Starter = new ProcessStarter(context.IndexDirectory);
                Verifier = new UpgradeServiceVerifier(context);
            }

            public void Install()
            {
                Console.WriteLine("Installing GrowSense upgrade service...");

                Starter.StartBash("bash create-upgrade-service.sh");

                Verify();
            }

            public void Verify()
            {
                Verifier.Verify();
            }
        }
    }

