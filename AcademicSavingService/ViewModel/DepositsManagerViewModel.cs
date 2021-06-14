using AcademicSavingService.Containers;

namespace AcademicSavingService.ViewModel
{
	class DepositsManagerViewModel : TransactionManagerViewModel
	{
		public DepositsManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
		{
			Slips = DepositSlipContainer.Instance.Collection;
		}
	}
}
