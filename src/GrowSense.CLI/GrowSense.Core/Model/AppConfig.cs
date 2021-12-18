using System;
using System.Xml.Serialization;
using System.Collections.Generic;
namespace GrowSense.Core.Model
{
[XmlRoot(ElementName="add")]
  public class Entry {
    [XmlAttribute(AttributeName="key")]
    public string Key { get; set; }
    [XmlAttribute(AttributeName="value")]
    public string Value { get; set; }
  }

  [XmlRoot(ElementName="appSettings")]
  public class AppSettings {
    [XmlElement(ElementName="add")]
    public List<Entry> Add { get; set; }
  }

  [XmlRoot(ElementName = "configuration")]
  public class AppConfig
  {
    [XmlElement(ElementName = "appSettings")]
    public AppSettings AppSettings { get; set; }

    [XmlIgnore]
    public string FilePath;
  }
}
