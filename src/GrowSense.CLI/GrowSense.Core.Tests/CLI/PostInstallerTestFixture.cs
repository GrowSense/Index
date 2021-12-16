using System;
using NUnit.Framework;
using System.Threading;
namespace GrowSense.Core.Tests.CLI
{
[TestFixture]
  public class PostInstallerTestFixture : BaseTestFixture
  {
  [Test]
    public void Test_Slow()
    {
      MoveToTemporaryDirectory();

      var helper = new PostInstallerTestHelper(ProjectDirectory, TemporaryDirectory);
      helper.Test();
    }
    
[Test]
    public void Test_Fast()
    {
      MoveToTemporaryDirectory();

      var helper = new PostInstallerTestHelper(ProjectDirectory, TemporaryDirectory);
      helper.DockerImage = "ubuntu-loaded";
      helper.Test();
    }
  }
}
