using MahApps.Metro.Controls;
using MahApps.Metro.Controls.Dialogs;
using System.Windows;

namespace AcademicSavingService.Controls
{
	public class MessageBox
	{
		public static void ShowMessage(string title, string message)
		{
			var metroWindow = (Application.Current.MainWindow as MetroWindow);
			metroWindow.ShowMessageAsync(title, message);
		}
	}
}
