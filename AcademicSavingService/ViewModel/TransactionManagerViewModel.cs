using AcademicSavingService.Containers;
using AcademicSavingService.INPC;
using PropertyChanged;
using System.Collections.ObjectModel;

namespace AcademicSavingService.ViewModel
{
	[AddINotifyPropertyChangedInterface]
	class TransactionManagerViewModel : TabItemViewModel
	{
		public TransactionManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
		{
				
		}

		#region Insert fields
		public int ID { get; set; }
		public int CustomerID { get; set; }
		#endregion

		#region Accounts
		public ObservableCollection<SavingAccountINPC> SavingAccounts { get; set; }

		protected SavingAccountINPC _selectedAccount;
		public SavingAccountINPC SelectedAccount
		{
			get
			{
				return _selectedAccount;
			}
			set
			{
				_selectedAccount = value;

			}
		}
		#endregion

		#region Slips
		public ObservableCollection<TransactionSlipINPC> Slips { get; set; }

		protected TransactionSlipINPC _selectedSlip;
		public TransactionSlipINPC SelectedSlip
		{
			get
			{
				return _selectedSlip;
			}
			set
			{
				_selectedSlip = value;

			}
		}
		#endregion

		public int SelectedAccountIndex { get; set; }
		public int SelectedSlipIndex { get; set; }
	}
}
