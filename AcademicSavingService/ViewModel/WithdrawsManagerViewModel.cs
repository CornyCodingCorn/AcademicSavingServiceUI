using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AcademicSavingService.Containers;
using AcademicSavingService.Controls;
namespace AcademicSavingService.ViewModel
{
	class WithdrawsManagerViewModel : TransactionManagerViewModel
	{
		public WithdrawsManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
		{
			_containerInstance = WithdrawSlipContainer.Instance;
			Slips = _containerInstance.Collection;
		}
	}
}
