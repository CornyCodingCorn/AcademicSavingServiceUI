using System.Collections.ObjectModel;
using AcademicSavingService.INPC;
using SqlKata.Execution;
using SqlKata.Compilers;

namespace AcademicSavingService.DataAccess
{
    public abstract class TransactionSlipDA : BaseDataAccess<TransactionSlipINPC, int>
    {
        public ObservableCollection<TransactionSlipINPC> GetSlipsByMaPhieu(int MaPhieu)
        {
            var collection = db.Query(_tableName).Where(_MaPhieu, MaPhieu).Get<TransactionSlipINPC>();
            return new ObservableCollection<TransactionSlipINPC>(collection);
        }

        public ObservableCollection<TransactionSlipINPC> GetSlipsByMaSo(int MaSo)
        {
            var collection = db.Query(_tableName).Where(_MaSo, MaSo).Get<TransactionSlipINPC>();
            return new ObservableCollection<TransactionSlipINPC>(collection);
        }

        public override void Create(TransactionSlipINPC slip)
        {
            string q = $"CALL ThemPhieu({_MaSoVar}, {_SoTienVar}, {_GhiChuVar}, {_NgayTaoVar})";
            cmd.CommandText = q;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue(_MaSoVar, slip.MaSo);
            cmd.Parameters.AddWithValue(_SoTienVar, slip.SoTien);
            cmd.Parameters.AddWithValue(_GhiChuVar, slip.GhiChu);
            cmd.Parameters.AddWithValue(_NgayTaoVar, slip.NgayTao);

            BaseDBConnection.OpenConnection();
            cmd.ExecuteNonQuery();
            BaseDBConnection.CloseConnection();
        }

        public override ObservableCollection<TransactionSlipINPC> GetAll()
        {
            var collection = db.Query(_tableName).Get<TransactionSlipINPC>();
            return new ObservableCollection<TransactionSlipINPC>(collection);
        }

        public override void Delete(int MaPhieu)
        {
            db.Query(_tableName).Where(_MaPhieu, MaPhieu).Delete();
        }

        public void DeleteSlipByMaSo(int MaSo)
        {
            db.Query(_tableName).Where(_MaSo, MaSo).Delete();
        }

        public TransactionSlipDA()
        {
            MySqlCompiler compiler = new();
            db = new QueryFactory(BaseDBConnection.Connection, compiler);
        }

        protected readonly QueryFactory db;

        protected readonly string _MaPhieu = "MaPhieu";
        protected readonly string _MaSo = "MaSo";
        protected readonly string _SoTien = "SoTien";
        protected readonly string _NgayTao = "NgayTao";

        protected readonly string _MaSoVar = "@MaSo";
        protected readonly string _SoTienVar = "@SoTien";
        protected readonly string _GhiChuVar = "@GhiChu";
        protected readonly string _NgayTaoVar = "@NgayTao";
    }
}
