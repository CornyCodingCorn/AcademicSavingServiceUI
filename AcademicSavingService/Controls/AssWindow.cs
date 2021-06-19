using MahApps.Metro.Controls;
using System;
using System.Windows;

namespace AcademicSavingService.Controls
{
	public class AssWindow : MetroWindow, IDisposable
	{
		public static readonly DependencyProperty IsActivatedProperty = 
			DependencyProperty.Register("IsActivated", typeof(bool), typeof(AssWindow));

		public AssWindow()
		{
			AssApp.RegisterWindow(this);
		}

		public void Dispose()
		{
			AssApp.RemoveWindow(this);
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
		}

		protected override void OnDeactivated(EventArgs e)
		{
			base.OnDeactivated(e);
			IsActivated = IsActive;
		}
	}
}
