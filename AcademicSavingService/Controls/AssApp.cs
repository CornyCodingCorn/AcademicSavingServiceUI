using ControlzEx.Theming;
using System.Collections.Generic;
using MahApps.Metro.Controls.Dialogs;
using System.Threading.Tasks;

namespace AcademicSavingService.Controls
{
	static class AssApp
	{
		static private List<AssWindow> _windows = new List<AssWindow>();
		static private int _activeWindowCount = 0;
		static public AssWindow ActiveWindow { get; private set; }
		static public int ActiveWindowsCount
		{
			get { return _activeWindowCount; }
			private set
			{
				if (_activeWindowCount > 0 && value == 0)
					ProgramDeactivated();
				else if (_activeWindowCount == 0 && value > 0)
					ProgramActivated();
				_activeWindowCount = value;	
			}
		}

		static public Theme ActiveTheme { get; private set; }
		static public string ActiveThemeColor { get; private set; } = "Cyan";

		static public bool IsActive
		{
			get { return _activeWindowCount > 0; }
		}

		static public App App { get; set; }
		static public bool AskBeforeDelete { get; set; } = true;
		static public bool AskBeforeUpdate { get; set; } = true;
		
		static public async Task<bool> ShowConfirmDialogMessage(string title, string message)
		{
			if (ActiveWindow is null)
				return false;

			Task<MessageDialogResult> task = ActiveWindow.ShowMessageAsync(title, message, MessageDialogStyle.AffirmativeAndNegative);
			await task;
			if (task.Result == MessageDialogResult.Affirmative)
				return true;
			return false;
		}

		static private void WindowDeactivated(object sender, System.EventArgs e)
		{
			ActiveWindowsCount--;
			if (ActiveWindow == sender)
			{
				ActiveWindow = null;
				foreach (var window in _windows)
					if (window != sender && ((AssWindow)sender).IsActive)
					{
						ActiveWindow = window;
						break;
					}
			}
		}
		static private void WindowActivated(object sender,System.EventArgs e)
		{
			ActiveWindowsCount++;
			if (ActiveWindow == null)
				ActiveWindow = (AssWindow)sender;
		}

		static private void ProgramDeactivated()
		{
			Deactivated?.Invoke();
		}
		static private void ProgramActivated()
		{
			Activated?.Invoke();
		}

		public delegate void GenericEvent();
		static public event GenericEvent Deactivated;
		static public event GenericEvent Activated;

		static public void ChangeTheme(string theme)
		{
			if (theme == ActiveThemeColor)
				return;

			ActiveThemeColor = theme;
			ActiveTheme = ThemeManager.Current.GetTheme("Light." + theme);
			ThemeManager.Current.ChangeTheme(App, ActiveTheme);
		}

		static public void RegisterWindow(AssWindow window)
		{
			if (_windows.Count == 0)
				ActiveTheme = ThemeManager.Current.DetectTheme();
			else
				ThemeManager.Current.ChangeTheme(window, ActiveTheme);
			_windows.Add(window);
			window.Activated += WindowActivated;
			window.Deactivated += WindowDeactivated;
			if (window.IsActive)
				_activeWindowCount++;
		}
		static public void RemoveWindow(AssWindow window)
		{
			_windows.Remove(window);
			window.Activated -= WindowActivated;
			window.Deactivated -= WindowDeactivated;
			if (window.IsActive)
				_activeWindowCount--;
		}
	}
}
