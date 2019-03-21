using System;
using NUnit.Framework;

namespace GreenSense.Index.Tests
{
    public class BaseTestHelper : IDisposable
    {
        public string ProjectDirectory { get; set; }

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


        #region IDisposable Support

        private bool disposedValue = false;
        // To detect redundant calls

        protected virtual void Dispose (bool disposing)
        {
            if (!disposedValue) {
                if (disposing) {
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

