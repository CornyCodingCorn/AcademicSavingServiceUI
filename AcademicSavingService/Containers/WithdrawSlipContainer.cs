using AcademicSavingService.DataAccess;
using AcademicSavingService.INPC;

namespace AcademicSavingService.Containers
{
	public class WithdrawSlipContainer : TransactionSlipContainer
	{
		private WithdrawSlipContainer()
        {
			_slipDA = new WithdrawSlipDA();
			Collection = _slipDA.GetAll();
		}

		public override void AddToCollection(TransactionSlipINPC item)
		{
			_slipDA.Create(item);
			item.SoTien = -item.SoTien;
			Collection.Add(item);
		}

		private static readonly WithdrawSlipContainer _instance = new();
		public static WithdrawSlipContainer Instance => _instance;
	}
}
