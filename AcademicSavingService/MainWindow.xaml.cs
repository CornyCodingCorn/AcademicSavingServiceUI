using System;
using MahApps.Metro.Controls;
using ControlzEx.Theming;

namespace AcademicSavingService
{
	/// <summary>
	/// Interaction logic for MainWindow.xaml
	/// </summary>
	public partial class MainWindow : MetroWindow
	{
		public MainWindow()
		{
			InitializeComponent();
		}

		protected override void OnDeactivated(EventArgs e)
		{
			base.OnDeactivated(e);
			ThemeManager.Current.ChangeTheme(this, "Light.Steel");
		}

		protected override void OnActivated(EventArgs e)
		{
			base.OnActivated(e);
			ThemeManager.Current.ChangeTheme(this, "Light.Blue");
		}
	}
}
