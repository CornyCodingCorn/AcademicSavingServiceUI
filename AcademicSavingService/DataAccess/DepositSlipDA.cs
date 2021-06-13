using AcademicSavingService.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AcademicSavingService.DataAccess
{
	class DepositSlipDA : TransactionSlipDA
	{
		protected override string _tableName => "PHIEUGUI";

		public override TransactionSlip CreateSlip(TransactionSlip slip)
		{
			slip.SoTien = -slip.SoTien;
			return base.CreateSlip(slip);
		}
	}
}
