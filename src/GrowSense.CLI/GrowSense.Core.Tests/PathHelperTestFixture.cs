using System;
using NUnit.Framework;
using System.IO;
namespace GrowSense.Core.Tests
{
[TestFixture]
  public class PathHelperTestFixture : BaseTestFixture
  {
    [Test]
    public void Test_Initialize_IndexPath()
    {
      MoveToTemporaryDirectory();
      
      var startingDirectory = Environment.CurrentDirectory;

      var settings = new CLISettings();
      
      var context = new CLIContext(startingDirectory, settings);
      var paths = new PathHelper(context);

      paths.Initialize(startingDirectory);

      var expectedParentPath = Path.GetFullPath(Environment.CurrentDirectory + "/../../").TrimEnd('/');

      Assert.AreEqual(expectedParentPath, context.ParentDirectory, "Parent path is not set correctly.");
      
      var expectedIndexDirectory = Environment.CurrentDirectory;

      Assert.AreEqual(expectedIndexDirectory, context.IndexDirectory, "Index directory is not set correctly.");
    }
    
    [Test]
    public void Test_Initialize_ParentPath()
    {
      MoveToTemporaryDirectory();
      
      var startingDirectory = Path.GetFullPath(Environment.CurrentDirectory + "/../../");

      var settings = new CLISettings();
      
      var context = new CLIContext(startingDirectory, settings);
      var paths = new PathHelper(context);

      paths.Initialize(startingDirectory);

      var expectedParentPath = Path.GetFullPath(Environment.CurrentDirectory + "/../../").TrimEnd('/');

      Assert.AreEqual(expectedParentPath, context.ParentDirectory, "Parent path is not set correctly.");
      
      var expectedIndexDirectory = Environment.CurrentDirectory;

      Assert.AreEqual(expectedIndexDirectory, context.IndexDirectory, "Index directory is not set correctly.");
    }
    
    [Test]
    public void Test_Initialize_GrowSensePath()
    {
      MoveToTemporaryDirectory();
      
      var startingDirectory = Path.GetFullPath(Environment.CurrentDirectory + "/../");

      var settings = new CLISettings();
      
      var context = new CLIContext(startingDirectory, settings);
      var paths = new PathHelper(context);

      paths.Initialize(startingDirectory);

      var expectedParentPath = Path.GetFullPath(Environment.CurrentDirectory + "/../../").TrimEnd('/');

      Assert.AreEqual(expectedParentPath, context.ParentDirectory, "Parent path is not set correctly.");
      
      var expectedIndexDirectory = Environment.CurrentDirectory;

      Assert.AreEqual(expectedIndexDirectory, context.IndexDirectory, "Index directory is not set correctly.");
    }
  }
}
