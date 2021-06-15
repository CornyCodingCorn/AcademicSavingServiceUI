using AcademicSavingService.DataAccess;
using AcademicSavingService.INPC;
using System;

namespace AcademicSavingService.Containers
{
	public class WithdrawSlipContainer : TransactionSlipContainer
	{
		private WithdrawSlipContainer()
        {
			_slipDA = new WithdrawSlipDA();
			Collection = _slipDA.GetAll();
		}

		public override void AddToCollection(TransactionSlipINPC slip)
		{
      _slipDA.Create(slip);
			slip.SoTien = -slip.SoTien;
			Collection.Add(slip);
		}

		public void AddWithdrawAllSlipToCollection(TransactionSlipINPC slip)
        {
			((WithdrawSlipDA)_slipDA).WithdrawAllFromAccountByMaSo(slip.MaSo, slip.GhiChu, slip.NgayTao);
			Collection.Add(slip);
        }

		private static readonly WithdrawSlipContainer _instance = new();
		public static WithdrawSlipContainer Instance => _instance;
	}
}
