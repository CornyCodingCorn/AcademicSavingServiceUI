using AcademicSavingService.InpcContainers;
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

		public ObservableCollection<CustomerViewModel> Customers { get; set; } = new ObservableCollection<CustomerViewModel>();

		#region Insert fields
		public int ID { get; set; }
		public int CustomerID { get; set; }
		public 
		#endregion

		#region Accounts
		public ObservableCollection<SavingAccountViewModel> SavingAccounts { get; set; }

		protected SavingAccountViewModel _selectedAccount;
		public SavingAccountViewModel SelectedAccount
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
		public ObservableCollection<TransactionSlipViewModel> Slips { get; set; }

		protected TransactionSlipViewModel _selectedSlip;
		public TransactionSlipViewModel SelectedSlip
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
