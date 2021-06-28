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
				new TermsManagerViewModel(this)
				{
					Header = "Terms",
					Width = _tabsWidth,
					Margin = _tabsMargin
				},
				new RuleManagerViewModel(this)
                {
					Header = "Rules",
					Width = _tabsWidth,
					Margin = _tabsMargin,
                }
			};
		}
	}
}