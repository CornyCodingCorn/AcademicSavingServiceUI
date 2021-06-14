using AcademicSavingService.INPC;

namespace AcademicSavingService.DataAccess
{
	public class WithdrawSlipDA : TransactionSlipDA
	{
		protected override string _tableName => "PHIEURUT";

        public override void Create(TransactionSlipINPC slip)
        {
            slip.SoTien = -slip.SoTien;
            base.Create(slip);
        }
    }
}
