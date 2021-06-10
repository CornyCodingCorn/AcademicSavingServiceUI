using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AcademicSavingService.ViewModel
{
	class BanksManagerViewModel : MenuItemViewModel
	{
		public BanksManagerViewModel(MainViewModel mainViewModel) : base(mainViewModel)
		{
			TabItems = new System.Collections.ObjectModel.ObservableCollection<TabItemViewModel>()
			{
				new BranchesManagerViewModel(this)
				{
					Header = "Saving accounts",
					Width = _tabsWidth,
					Margin = _tabsMargin
				},
				new EmployeesManagerViewModel(this)
				{
					Header = "Deposits",
					Width = _tabsWidth,
					Margin = _tabsMargin
				}
			};
		}
	}
}
