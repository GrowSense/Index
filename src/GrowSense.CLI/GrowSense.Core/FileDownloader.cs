using System;
using System.Net;
namespace GrowSense.Core
{
  public class FileDownloader
  {
    public FileDownloader()
    {
    }

    public void Download(string url, string destination)
    {
      Console.WriteLine("  Downloading GrowSense...");
      Console.WriteLine("    URL: " + url);
      Console.WriteLine("    Destination: " + destination);
      
      WebClient webClient = new WebClient();
      webClient.DownloadFile(url, destination);
    }
  }
}
