using System;
using NUnit.Framework;
using System.Threading;
using System.ComponentModel;
namespace GrowSense.Core.Tests.CLI.Docker
{

  [TestFixture(Category = "Fast")]
  public class PostInstallerDockerTestFixture : BaseTestFixture
  {
  // TODO: Reenable once issue with docker is sorted
    //[Test]
    public void Test_Slow()
    {
      MoveToTemporaryDirectory();

      var helper = new PostInstallerDockerTestHelper(ProjectDirectory, TemporaryDirectory);
      helper.Test();
    }

    [Test]
    public void Test_Fast()
    {
      MoveToTemporaryDirectory();

      var helper = new PostInstallerDockerTestHelper(ProjectDirectory, TemporaryDirectory);
      helper.DockerImage = "ubuntu-loaded";
      helper.Test();
    }
  }
}