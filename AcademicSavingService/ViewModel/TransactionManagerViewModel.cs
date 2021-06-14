using AcademicSavingService.Commands;
using AcademicSavingService.InpcContainers;
using PropertyChanged;
using System;
using System.Collections.ObjectModel;
using System.Windows.Input;

namespace AcademicSavingService.ViewModel
{
	[AddINotifyPropertyChangedInterface]
	class TransactionManagerViewModel : CRUBPanel
	{
		public TransactionManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
		{
				
		}

		#region ICommand

		protected override void ExecuteAdd()
		{
			SavingAccountViewModel.CreateAccount(new SavingAccountViewModel
			{

			});
		}
		protected override bool CanExecuteAdd()
		{
			if (CreateDate.Year < 1800 || SelectedAccountIndex < 0 || IsReadOnly)
			{
				return false;
			}
			else
				return true;
		}

		protected void UpdateAccount()
		{
			SavingAccountViewModel.CallUpdateOneAccount(SelectedAccount.MaSo, DateTime.Now);
		}
		protected bool CanUpdateAccount()
		{
			if (SelectedAccount == null)
				return false;
			else
				return true;
		}

		protected override void ExecuteInsertMode()
		{
			if (IsInsertMode)
				SelectedAccountIndex = 1;
			base.ExecuteInsertMode();
		}

		protected void UpdateAllAccounts()
		{
			SavingAccountViewModel.CallUpdateAllAccounts(DateTime.Now);
		}
		protected bool CanUpdateAllAccounts()
		{
			return IsReadOnly;
		}

		protected void DeleteAccount()
		{
			int index = SelectedAccountIndex;
			SavingAccountViewModel.DeleteAccount(ID);
			SelectedAccountIndex = index;
		}
		protected bool CanDeleteAccount()
		{
			if (SelectedAccount == null)
				return false;
			else
				return true;
		}

		protected override void ExecuteClear()
		{
			ClearAllField();
		}
		protected override bool CanExecuteClear()
		{
			return IsInsertMode;
		}

		protected override void ClearAllField()
		{
			CreateDate = DateTime.Now;
			Balance = 0;

		}

		#endregion

		#region Insert fields
		public int ID { get; set; }
		public int CustomerID { get; set; }
		public DateTime CreateDate { get; set; }
		public decimal Amount { get; set; }
		public string Note { get; set; }


		public int AccountID { get; set; }
		public int OwnerID { get; set; }
		public decimal Balance { get; set; }
		public DateTime? LastUpdate { get; set; }
		#endregion

		#region Accounts
		public ObservableCollection<SavingAccountViewModel> SavingAccounts { get; set; }
		
		public int SelectedAccountIndex { get; set; }
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

				AccountID = _selectedAccount.MaSo;
				OwnerID = _selectedAccount.MaKH;
				Balance = _selectedAccount.SoDu;
				LastUpdate = _selectedAccount.LanCapNhatCuoi;
			}
		}
		#endregion

		#region Slips
		public ObservableCollection<TransactionSlipViewModel> Slips { get; set; }

		public int SelectedSlipIndex { get; set; }
		protected TransactionSlipViewModel _selectedSlip;
		public TransactionSlipViewModel SelectedSlip
		{
			get { return _selectedSlip; }
			set
			{
				_selectedSlip = value;

				ID = _selectedSlip.MaPhieu;
				CustomerID = _selectedSlip.MaKH;
				CreateDate = _selectedSlip.NgayTao;
				Amount = _selectedSlip.SoTien;
				Note = _selectedSlip.GhiChu;

				for (int i = 0; i < SavingAccounts.Count; i++)
				{
					if (SavingAccounts[i].MaSo == _selectedSlip.MaSo)
					{
						SelectedAccountIndex = i;
						break;
					}
				}
			}
		}
		#endregion
	}
}
