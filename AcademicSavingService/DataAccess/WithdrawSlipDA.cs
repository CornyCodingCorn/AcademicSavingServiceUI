using AcademicSavingService.INPC;
using System;

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

        public void WithdrawAllFromAccountByMaSo(int MaSo, string GhiChu, DateTime NgayTao)
        {
            string q = $"CALL RutHetTien({_MaSoVar}, {_GhiChuVar}, {_NgayTaoVar})";
            cmd.CommandText = q;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue(_MaSoVar, MaSo);
            cmd.Parameters.AddWithValue(_GhiChuVar, GhiChu);
            cmd.Parameters.AddWithValue(_NgayTaoVar, NgayTao);

            try
            {
                BaseDBConnection.OpenConnection();
                cmd.ExecuteNonQuery();
            }
            catch { throw; }
            finally { BaseDBConnection.CloseConnection(); }
        }
    }
}
