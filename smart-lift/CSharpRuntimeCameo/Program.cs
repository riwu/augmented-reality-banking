using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace CSharpRuntimeCameo
{
	static class Program
	{
		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main()
		{
			Bosch.VideoSDK.Core core = new Bosch.VideoSDK.Core();
			core.Startup();
			Application.EnableVisualStyles();
			Application.SetCompatibleTextRenderingDefault(false);
			Application.Run(new MainWindow());
			core.Shutdown(false);
		}
	}
}
