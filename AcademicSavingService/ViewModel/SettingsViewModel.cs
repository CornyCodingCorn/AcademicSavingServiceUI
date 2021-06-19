using AcademicSavingService.Commands;
using AcademicSavingService.Controls;
using PropertyChanged;
using System.Windows.Input;

namespace AcademicSavingService.ViewModel
{
	[AddINotifyPropertyChangedInterface]
	class SettingsViewModel : MenuItemViewModel
	{
		public bool AskBeforeDelete 
		{ 
			get { return AssApp.AskBeforeDelete; }
			set { AssApp.AskBeforeDelete = value; }
		}
		public bool AskBeforeUpdate 
		{ 
			get { return AssApp.AskBeforeUpdate; }
			set { AssApp.AskBeforeUpdate = value; }
		}

		protected RelayCommand<string> _greenThemeCommand;
		public ICommand ChangeThemeCommand => _greenThemeCommand ?? (_greenThemeCommand = new RelayCommand<string>(param => ExecuteChangeTheme(param), param => CanExecuteChangeTheme()));

		public SettingsViewModel(MainViewModel mainViewModel) : base(mainViewModel)
		{
		}

		protected void ExecuteChangeTheme(string theme)
		{
			AssApp.ChangeTheme(theme);
		}
		protected bool CanExecuteChangeTheme()
		{ 
			return true;
		}
	}
}
