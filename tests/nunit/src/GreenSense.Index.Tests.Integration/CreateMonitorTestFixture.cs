using System;
using NUnit.Framework;
namespace GreenSense.Index.Tests.Integration
{
	[TestFixture]
	public class CreateMonitorTestFixture : BaseTestFixture
	{
		[Test]
		public void Test_CreateMonitorScript()
		{
			var scriptName = "create-garden-monitor";

			Console.WriteLine("Script:");
			Console.WriteLine(scriptName);

			var starter = GetDockerProcessStarter();
			starter.RunScript(scriptName);
		}
	}
}
