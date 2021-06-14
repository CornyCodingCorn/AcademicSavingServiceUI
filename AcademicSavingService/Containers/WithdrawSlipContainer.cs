using AcademicSavingService.DataAccess;

namespace AcademicSavingService.Containers
{
	public class WithdrawSlipContainer : TransactionSlipContainer
	{
		private WithdrawSlipContainer()
        {
			_slipDA = new WithdrawSlipDA();
        }

		private readonly WithdrawSlipContainer _instance = new();

		public WithdrawSlipContainer Instance => _instance;
	}
}
