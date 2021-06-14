using AcademicSavingService.DataAccess;

namespace AcademicSavingService.Containers
{
	class DepositSlipContainer : TransactionSlipContainer
	{
        private DepositSlipContainer()
        {
            _slipDA = new DepositSlipDA();
        }

        private readonly DepositSlipContainer _instance = new();

        public DepositSlipContainer Instance => _instance;
    }
}
