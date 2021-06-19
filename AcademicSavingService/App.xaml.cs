using AcademicSavingService.Controls;
using AcademicSavingService.ViewModel;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;

namespace AcademicSavingService
{
	/// <summary>
	/// Interaction logic for App.xaml
	/// </summary>
	public partial class App : Application
	{
		private void Application_Exit(object sender, ExitEventArgs e)
		{
			MainViewModel.Instance.Dispose();
		}

		private void Application_Startup(object sender, StartupEventArgs e)
		{
			AssApp.App = this;
			MainWindow window = new MainWindow();
			window.Show();
		}
	}
}
