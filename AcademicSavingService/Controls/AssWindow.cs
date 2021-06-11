using ControlzEx.Theming;
using MahApps.Metro.Controls;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace AcademicSavingService.Controls
{
	public class AssWindow : MetroWindow
	{
		public static readonly DependencyProperty IsActivatedProperty = 
			DependencyProperty.Register("IsActivated", typeof(bool), typeof(AssWindow));

		Theme theme;

		public AssWindow()
		{
			theme = ThemeManager.Current.DetectTheme();
		}

		public bool IsActivated
		{ 
			get { return (bool)GetValue(IsActivatedProperty); }
			set { SetValue(IsActivatedProperty, value); }
		}

		protected override void OnActivated(EventArgs e)
		{
			base.OnActivated(e);
			IsActivated = IsActive;
			ThemeManager.Current.ChangeTheme(this, theme);
		}

		protected override void OnDeactivated(EventArgs e)
		{
			base.OnDeactivated(e);
			IsActivated = IsActive;
			ThemeManager.Current.ChangeTheme(this, "Light.Steel");
		}
	}
}
