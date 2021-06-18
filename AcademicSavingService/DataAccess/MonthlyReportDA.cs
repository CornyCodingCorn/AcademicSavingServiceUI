using System;
using System.Collections.ObjectModel;
using AcademicSavingService.INPC;
using SqlKata.Execution;

namespace AcademicSavingService.DataAccess
{
    public class MonthlyReportDA : BaseDataAccess<MonthlyReportINPC, int>
    {
        public void DeleteByCompositeKey(int thang, int nam, int kyHan)
        {
            db.Query(_tableName).Where(_Thang, thang).Where(_Nam, nam).Where(_KyHan, kyHan).Delete();
        }

        public override void Create(MonthlyReportINPC report)
        {
            string q = $"CALL TongHopBaoCaoThang({_NgayBaoCaoVar}, {_KyHanBaoCaoVar})";
            cmd.CommandText = q;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue(_NgayBaoCaoVar, new DateTime(report.Nam, report.Thang, 1));
            cmd.Parameters.AddWithValue(_KyHanBaoCaoVar, report.KyHan);

            BaseDBConnection.OpenConnection();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch { throw; }
            finally { BaseDBConnection.CloseConnection(); }
        }

        public override void Delete(int key)
        {
            throw new NotImplementedException();
        }

        public override ObservableCollection<MonthlyReportINPC> GetAll()
        {
            var collection = db.Query(_tableName).Get<MonthlyReportINPC>();
            return new ObservableCollection<MonthlyReportINPC>(collection);
        }

        private const string _NgayBaoCaoVar = "@NgayBaoCao";
        private const string _KyHanBaoCaoVar = "@KyHanBaoCao";
        private const string _Thang = "Thang";
        private const string _Nam = "Nam";
        private const string _KyHan = "KyHan";

        protected override string _tableName => "BAOCAOTHANG";
    }
}
