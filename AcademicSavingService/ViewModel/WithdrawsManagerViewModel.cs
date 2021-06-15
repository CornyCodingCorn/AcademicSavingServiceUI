using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using AcademicSavingService.Commands;
using AcademicSavingService.Containers;
using AcademicSavingService.Controls;
using MySql.Data.MySqlClient;

namespace AcademicSavingService.ViewModel
{
	class WithdrawsManagerViewModel : TransactionManagerViewModel
	{
		public WithdrawsManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
		{
			_containerInstance = WithdrawSlipContainer.Instance;
			Slips = _containerInstance.Collection;
		}

		protected RelayCommand<TransactionManagerViewModel> _withdrawAllCommand;
		public ICommand WithDrawAllCommand => _withdrawAllCommand ?? (_withdrawAllCommand = new RelayCommand<TransactionManagerViewModel>(param => ExecuteUpdate(), param => CanExecuteUpdate()));


		protected void ExecuteWithdrawAll()
		{
			try
			{

			}
			catch(MySqlException e)
			{ ShowErrorMessage(e); }
		}

		protected bool CanExecuteWithdrawAll()
		{
			return IsReadOnly && SelectedAccount != null && SelectedAccount.SoDu > 0;
		}

		protected override bool CanExecuteAdd()
		{
			return base.CanExecuteAdd() && SelectedAccount.SoDu >= Amount;
		}
	}
}
