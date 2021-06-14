using AcademicSavingService.Commands;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace AcademicSavingService.ViewModel
{
	class CRUBPanel : TabItemViewModel
	{
		public bool IsInsertMode { get; set; }
		public bool IsReadOnly
		{
			get { return !IsInsertMode; }
		}

		public CRUBPanel(MenuItemViewModel menuItem) : base(menuItem)
		{}

		protected RelayCommand<SavingAccountsManagerViewModel> _startInsertCommand;
		protected RelayCommand<SavingAccountsManagerViewModel> _clearCommand;
		protected RelayCommand<SavingAccountsManagerViewModel> _addCommand;
		protected RelayCommand<SavingAccountsManagerViewModel> _deleteCommand;

		public ICommand DeleteCommand => _deleteCommand ?? (_deleteCommand = new RelayCommand<SavingAccountsManagerViewModel>(param => ExecuteDelete(), param => CanExecuteDelete()));
		public ICommand ClearCommand => _clearCommand ?? (_clearCommand = new RelayCommand<SavingAccountsManagerViewModel>(param => ClearAllField(), param => CanExecuteClear()));
		public ICommand StartInsertCommand => _startInsertCommand ?? (_startInsertCommand = new RelayCommand<SavingAccountsManagerViewModel>(param => ExecuteInsertMode(), param => CanExecuteInsertMode()));
		public ICommand CreateCommand => _addCommand ?? (_addCommand = new RelayCommand<SavingAccountsManagerViewModel>(param => ExecuteAdd(), param => CanExecuteAdd()));

		protected virtual void ExecuteDelete()
		{ }
		protected virtual bool CanExecuteDelete()
		{
			return true;
		}

		protected virtual void ExecuteAdd()
		{}
		protected virtual bool CanExecuteAdd()
		{
			return true;
		}

		protected virtual void ExecuteInsertMode()
		{
			if (!IsInsertMode)
			{
				ClearAllField();
			}
			IsInsertMode = !IsInsertMode;
		}
		protected virtual bool CanExecuteInsertMode()
		{
			return true;
		}

		protected virtual void ExecuteClear()
		{}
		protected virtual bool CanExecuteClear()
		{
			return true;
		}

		protected virtual void ClearAllField()
		{}
	}
}
