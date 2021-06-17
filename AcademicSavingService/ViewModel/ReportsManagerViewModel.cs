using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AcademicSavingService.ViewModel
{
	class ReportsManagerViewModel : MenuItemViewModel
	{
		public ReportsManagerViewModel(MainViewModel mainViewModel) : base(mainViewModel)
		{
			TabItems = new System.Collections.ObjectModel.ObservableCollection<TabItemViewModel>()
			{
				new DailyReportsManagerViewModel(this)
				{
					Header = "Daily reports",
					Width = _tabsWidth,
					Margin = _tabsMargin
				},
			};
		}
	}
}
