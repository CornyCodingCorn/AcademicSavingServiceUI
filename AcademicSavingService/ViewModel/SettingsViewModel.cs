using AcademicSavingService.Commands;
using AcademicSavingService.Controls;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace AcademicSavingService.ViewModel
{
	class SettingsViewModel : MenuItemViewModel
	{
		public SettingsViewModel(MainViewModel mainViewModel) : base(mainViewModel)
		{
		}



		protected RelayCommand<string> _greenThemeCommand;
		public ICommand ChangeThemeCommand => _greenThemeCommand ?? (_greenThemeCommand = new RelayCommand<string>(param => ExecuteChangeTheme(param), param => CanExecuteChangeTheme()));

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
