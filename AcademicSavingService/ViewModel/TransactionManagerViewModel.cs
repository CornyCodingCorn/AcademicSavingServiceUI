using AcademicSavingService.Containers;
using AcademicSavingService.INPC;
using PropertyChanged;
using System;
using System.Collections.ObjectModel;
using System.Windows.Input;

namespace AcademicSavingService.ViewModel
{
	[AddINotifyPropertyChangedInterface]
	abstract class TransactionManagerViewModel : CRUBPanel
	{
		public TransactionManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
		{
			SavingAccounts = SavingAccountContainer.Instance.Collection;
		}

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

				AccountID = _selectedAccount.MaSo;
				OwnerID = _selectedAccount.MaKH;
				Balance = _selectedAccount.SoDu;
				LastUpdate = _selectedAccount.LanCapNhatCuoi;
			}
		}
		#endregion

		#region Slips
		public ObservableCollection<TransactionSlipINPC> Slips { get; set; }

		protected TransactionSlipINPC _selectedSlip;
		public TransactionSlipINPC SelectedSlip
		{
			get { return _selectedSlip; }
			set
			{
				_selectedSlip = value;

				ID = _selectedSlip.MaPhieu;
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

		public int SelectedAccountIndex { get; set; }
		public int SelectedSlipIndex { get; set; }
	}
}
