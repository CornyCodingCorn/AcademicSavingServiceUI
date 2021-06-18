using AcademicSavingService.Commands;
using System.Diagnostics;
using System.Windows.Input;

namespace AcademicSavingService.ViewModel
{
	class ContactAndHelpViewModel : MenuItemViewModel
	{
		public ContactAndHelpViewModel(MainViewModel mainViewModel) : base(mainViewModel) { }

		protected RelayCommand<ContactAndHelpViewModel> _openGithubCommand;
		public ICommand OpenGithubCommand => _openGithubCommand ?? (_openGithubCommand = new RelayCommand<ContactAndHelpViewModel>(param => ExecuteOpenGithub(), param => CanExecuteOpenGithub()));

		protected void ExecuteOpenGithub()
		{
			Process.Start("https://github.com/CodingC1402/AcademicSavingServiceUI");
		}

		protected bool CanExecuteOpenGithub()
		{
			return true;
		}
	}
}
