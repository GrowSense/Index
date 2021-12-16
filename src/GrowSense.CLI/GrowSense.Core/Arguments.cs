// Credit to http://www.codeproject.com/Articles/3111/C-NET-Command-Line-Arguments-Parser

using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text.RegularExpressions;
using System.Text;
using System.Collections.Specialized;
using System.Collections;

namespace GrowSense.Core
{
	public class Arguments
	{
		private StringDictionary Parameters;

		public string[] KeylessArguments = new string[]{};

		public int Count
		{
			get { return Parameters.Count; }
		}

		public Arguments(params string[] args)
		{
			Parameters = new StringDictionary();
			Regex splitter = new Regex(@"^-{1,2}|^/|=|:",
				RegexOptions.IgnoreCase|RegexOptions.Compiled);

			Regex remover = new Regex(@"^['""]?(.*?)['""]?$",
				RegexOptions.IgnoreCase|RegexOptions.Compiled);

			string parameter = null;
			string[] parts;

			var keyless = new List<string>();

			// Valid parameters forms:
			// {-,/,--}param{ ,=,:}((",')value(",'))
			// Examples: 
			// -param1 value1 --param2 /param3:"Test-:-work" 
			//   /param4=happy -param5 '--=nice=--'
			foreach(string arg in args)
			{
				if (!arg.Contains(":")
					&& !arg.Contains("=")
					&& !arg.StartsWith("-"))
					keyless.Add(arg);

				// Look for new parameters (-,/ or --) and a
				// possible enclosed value (=,:)
				parts = splitter.Split(arg,3);

				switch(parts.Length){
				// Found a value (for the last parameter 
				// found (space separator))
				case 1:
					if(parameter != null)
					{
						if(!Parameters.ContainsKey(parameter)) 
						{
							parts[0] = 
								remover.Replace(parts[0], "$1");

							Parameters.Add(parameter, parts[0]);
						}
						parameter=null;
					}
					// else Error: no parameter waiting for a value (skipped)
					break;

					// Found just a parameter
				case 2:
					// The last parameter is still waiting. 
					// With no value, set it to true.
					if(parameter!=null)
					{
						if(!Parameters.ContainsKey(parameter)) 
							Parameters.Add(parameter, "true");
					}
					parameter=parts[1];
					break;

					// Parameter with enclosed value
				case 3:
					// The last parameter is still waiting. 
					// With no value, set it to true.
					if(parameter != null)
					{
						if(!Parameters.ContainsKey(parameter)) 
							Parameters.Add(parameter, "true");
					}

					parameter = parts[1];

					// Remove possible enclosing characters (",')
					if(!Parameters.ContainsKey(parameter))
					{
						parts[2] = remover.Replace(parts[2], "$1");
						Parameters.Add(parameter, parts[2]);
					}

					parameter=null;
					break;
				}
			}
			// In case a parameter is still waiting
			if(parameter != null)
			{
				if(!Parameters.ContainsKey(parameter)) 
					Parameters.Add(parameter, "true");
			}

			KeylessArguments = keyless.ToArray();
		}

		// Retrieve a parameter value if it exists 
		// (overriding C# indexer property)
		public string this [string param]
		{
			get
			{
				return(Parameters[param]);
			}
		}

		public string this [params string[] parameters]
		{
			get
			{
				foreach (var p in parameters)
					if (Contains(p))
						return this[p];

				return String.Empty;
			}
		}

		public bool Contains(string param)
		{
			return Parameters.ContainsKey(param);
		}

		public override string ToString ()
		{
			var builder = new StringBuilder();

			foreach (var value in KeylessArguments)
			{
				builder.Append (value);
				builder.Append (" ");
			}

			foreach (DictionaryEntry entry in Parameters)
			{
				builder.Append (entry.Value);
				builder.Append (" ");
			}

			return builder.ToString().Trim();
		}

		public bool ContainsAny(params string[] queryParameters)
		{
			bool doesContain = false;

			foreach (var p in queryParameters)
			{
				if (Contains(p))
					doesContain = true;
			}

			return doesContain;
		}

		public int GetInt(string key)
		{
			return Convert.ToInt32(this[key]);
		}
	}
}
	