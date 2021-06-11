using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using AcademicSavingService.Controls;
namespace AcademicSavingService.ViewModel
{
	class WithdrawsManagerViewModel : TabItemViewModel
	{
		public ObservableCollection<Test> Tests { get; set; }

		public WithdrawsManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
		{
			Tests = new ObservableCollection<Test>();
			Tests.Add(new Test());
			Tests.Add(new Test());
			Tests.Add(new Test());
			Tests.Add(new Test());
		}
	}
}
