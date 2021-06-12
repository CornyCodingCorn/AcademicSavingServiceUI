using System.Collections.ObjectModel;
using System.Windows.Input;
using AcademicSavingService.InpcContainers;
using AcademicSavingService.DataAccess;
using AcademicSavingService.Commands;
using AcademicSavingService.Model;
using PropertyChanged;
using MahApps.Metro.Controls;
using MahApps.Metro.Controls.Dialogs;
using System.Windows;
using System;
using System.ComponentModel;

namespace AcademicSavingService.ViewModel
{
	[AddINotifyPropertyChangedInterface]
	class SavingAccountsManagerViewModel : TabItemViewModel
	{
		public ObservableCollection<SavingAccountViewModel> SavingAccounts { get; set; }
		public ObservableCollection<CustomerViewModel> Customers { get; set; }
		protected SavingAccountViewModel _selectedAccount;
		public object SelectedAccount 
		{ 
			get { return _selectedAccount; }
			set
			{
				_selectedAccount = (SavingAccountViewModel)value;
				ID = _selectedAccount.MaSo;
				CreateDate = _selectedAccount.NgayTao;
				CloseDate = _selectedAccount.NgayDongSo;
				LastUpdateDate = _selectedAccount.LanCapNhatCuoi;
				Balance = _selectedAccount.SoDu;
				InitialBalance = _selectedAccount.SoTienBanDau;

				foreach (var account in Customers)
				{
					if (account.MaKH == _selectedAccount.MaKH)
					{
						SelectedCustomer = account;
						break;
					}
				}
			}
		}
		protected CustomerViewModel _selectedCustomer;
		public object SelectedCustomer 
		{ 
			get { return _selectedCustomer; }
			set
			{
				_selectedCustomer = (CustomerViewModel)value;
				OwnerID = _selectedCustomer.MaKH;
			}
		}

		public ObservableCollection<int> PeriodList { get; set; }
		public int Period { get; set; }
		public int ID { get; set; }
		public int OwnerID { get; set; }
		public DateTime CreateDate { get; set; }
		public DateTime? LastUpdateDate { get; set; }
		public DateTime? CloseDate { get; set; }
		public decimal Balance { get; set; }
		public decimal InitialBalance { get; set; }
		public int CustomerID { get; set; }


		public SavingAccountsManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
		{
            SavingAccounts = SavingAccountViewModel.Container;
			Customers = CustomerViewModel.Container;
		}
    }
}
