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

		protected RelayCommand<SettingsViewModel> _greenThemeCommand;
		public ICommand GreenThemeCommand => _greenThemeCommand ?? (_greenThemeCommand = new RelayCommand<SettingsViewModel>(param => ExecuteGreenTheme(), param => CanExecuteGreenTheme()));

		protected void ExecuteGreenTheme()
		{
			AssApp.ChangeTheme("Green");
		}
		protected bool CanExecuteGreenTheme()
		{ 
			return true;
		}	
	}
}
