using AcademicSavingService.DataAccess;
using AcademicSavingService.INPC;

namespace AcademicSavingService.Containers
{
	class DepositSlipContainer : TransactionSlipContainer
	{
        private DepositSlipContainer()
        {
            _slipDA = new DepositSlipDA();
            Collection = _slipDA.GetAll();
        }

		public override void AddToCollection(TransactionSlipINPC item)
		{
            _slipDA.Create(item);
            Collection.Add(item);
        }

		private static readonly DepositSlipContainer _instance = new();
        public static DepositSlipContainer Instance => _instance;
    }
}
