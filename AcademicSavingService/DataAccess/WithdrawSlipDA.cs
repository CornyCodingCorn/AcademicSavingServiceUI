using AcademicSavingService.Model;

namespace AcademicSavingService.DataAccess
{
	class WithdrawSlipDA : TransactionSlipDA
	{
		protected override string _tableName => "PHIEURUT";

		public override TransactionSlip CreateSlip(TransactionSlip slip)
		{
			slip.SoTien = -slip.SoTien;
			return base.CreateSlip(slip);
		}
	}
}
