using AcademicSavingService.DataAccess;

namespace AcademicSavingService.Containers
{
	class DepositSlipContainer : TransactionSlipContainer
	{
        private DepositSlipContainer()
        {
            _slipDA = new DepositSlipDA();
            Collection = _slipDA.GetAll();
        }

        private static readonly DepositSlipContainer _instance = new();
        public static DepositSlipContainer Instance => _instance;
    }
}
