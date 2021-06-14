using AcademicSavingService.Containers;

namespace AcademicSavingService.ViewModel
{
	class DepositsManagerViewModel : TransactionManagerViewModel
	{
		public DepositsManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
		{
			_containerInstance = DepositSlipContainer.Instance;
			Slips = _containerInstance.Collection;
		}
	}
}
