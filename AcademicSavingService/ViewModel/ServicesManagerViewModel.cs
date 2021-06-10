using System;
using PropertyChanged;
using System.ComponentModel;
using System.Threading.Tasks;
using System.Collections.ObjectModel;
using System.Windows;
using MahApps.Metro.Controls;

namespace AcademicSavingService.ViewModel
{
	[AddINotifyPropertyChangedInterface]
	class ServicesManagerViewModel : MenuItemViewModel
	{
		public ServicesManagerViewModel(MainViewModel mainViewModel) : base(mainViewModel)
		{
			TabItems = new ObservableCollection<TabItemViewModel>()
			{
				new SavingAccountsManagerViewModel(this)
				{
					Header = "Saving accounts",
					Width = _tabsWidth,
					Margin = _tabsMargin
				},
				new DepositsManagerViewModel(this)
				{
					Header = "Deposits",
					Width = _tabsWidth,
					Margin = _tabsMargin
				},
				new WithdrawsManagerViewModel(this)
				{
					Header = "Withdraws",
					Width = _tabsWidth,
					Margin = _tabsMargin
				},
				new CustomersManagerViewModel(this)
				{
					Header = "Customers",
					Width = _tabsWidth,
					Margin = _tabsMargin
				}
			};
		}
	}
}
