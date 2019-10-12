using System;
using NUnit.Framework;
using System.IO;

namespace GrowSense.Index.Tests
{
    public class BaseTestHelper : IDisposable
    {
        public string ProjectDirectory { get; set; }

        public TestProcessStarter Starter = new TestProcessStarter ();

        public BaseTestHelper ()
        {
        }

        public BaseTestHelper (string projectDirectory)
        {
            ProjectDirectory = projectDirectory;
        }

        #region Process Starter

        public TestProcessStarter GetTestProcessStarter ()
        {
            return GetTestProcessStarter (true);
        }

        public TestProcessStarter GetTestProcessStarter (bool initializeStarter)
        {
            var starter = new TestProcessStarter ();

            starter.WorkingDirectory = ProjectDirectory;

            if (initializeStarter)
                starter.Initialize ();

            return starter;
        }

        #endregion

        public string GetServicesDirectory ()
        {
            var servicesDirectory = "";
            if (File.Exists (Path.GetFullPath ("is-mock-systemctl.txt"))) {
                servicesDirectory = Path.Combine (ProjectDirectory, "mock/services");
            } else {
                servicesDirectory = "/lib/systemd/system/";
            }
            return servicesDirectory;
        }

        #region Console Write Functions

        public void ConsoleWriteSerialOutput (string output)
        {
            if (!String.IsNullOrEmpty (output)) {
                foreach (var line in output.Trim().Split('\r')) {
                    if (!String.IsNullOrEmpty (line)) {
                        Console.WriteLine ("> " + line);
                    }
                }
            }
        }

        #endregion

        public void CheckForErrors ()
        {
            // TODO: Fix this. It doesn't work yet.
            /*var output = Starter.Starter.Output;
            if (output.Contains ("no tty present and no askpass program specified")) {
                Console.WriteLine ("Error:");
                Console.WriteLine ("Unable to perform a 'sudo' action. Try running clean script first.");
                Assert.Fail ("Error");
            }*/
        }

        #region IDisposable Support

        private bool disposedValue = false;
        // To detect redundant calls

        protected virtual void Dispose (bool disposing)
        {
            if (!disposedValue) {
                if (disposing) {
                    CheckForErrors ();
                    /*if (TestContext.CurrentContext.Result.State == TestState.Error
                        || TestContext.CurrentContext.Result.State == TestState.Failure) {
                        Console.WriteLine ("Complete device serial output...");
                        ConsoleWriteSerialOutput (FullDeviceOutput);
                    }

                    if (DeviceClient != null)
                        DeviceClient.Close ();

                    if (SimulatorClient != null)
                        SimulatorClient.Disconnect ();

                    Thread.Sleep (DelayAfterDisconnectingFromHardware);*/
                }

                disposedValue = true;
            }
        }

        // TODO: override a finalizer only if Dispose(bool disposing) above has code to free unmanaged resources.
        // ~HardwareTestHelper() {
        //   // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
        //   Dispose(false);
        // }

        // This code added to correctly implement the disposable pattern.
        public void Dispose ()
        {
            // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
            Dispose (true);
            // TODO: uncomment the following line if the finalizer is overridden above.
            // GC.SuppressFinalize(this);
        }

        #endregion
    }
}

