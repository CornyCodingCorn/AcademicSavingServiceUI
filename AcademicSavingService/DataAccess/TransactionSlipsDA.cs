using System.Collections.Generic;
using System.Collections.ObjectModel;
using AcademicSavingService.Model;
using AcademicSavingService.InpcContainers;
using SqlKata.Execution;
using SqlKata.Compilers;

namespace AcademicSavingService.DataAccess
{
    public class TransactionSlipsDA : BaseDataAccess<TransactionSlipViewModel>
    {
        public ObservableCollection<TransactionSlipViewModel> GetAllSlips()
        {
            var collection = db.Query(_tableName).Get<TransactionSlipViewModel>();
            return new ObservableCollection<TransactionSlipViewModel>(collection);
        }

        public ObservableCollection<TransactionSlipViewModel> GetSlipsByMaPhieu(int MaPhieu)
        {
            var collection = db.Query(_tableName).Where(_MaPhieu, MaPhieu).Get<TransactionSlipViewModel>();
            return new ObservableCollection<TransactionSlipViewModel>(collection);
        }

        public ObservableCollection<TransactionSlipViewModel> GetSlipsByMaSo(int MaSo)
        {
            var collection = db.Query(_tableName).Where(_MaSo, MaSo).Get<TransactionSlipViewModel>();
            return new ObservableCollection<TransactionSlipViewModel>(collection);
        }

        public void CreateSlip(TransactionSlip slip)
        {
            string q = $"CALL ThemPhieu({_MaSoVar}, {_SoTienVar}, {_MaKHVar}, {_MaNVVar}, {_GhiChuVar}, {_NgayTaoVar})";
            cmd.CommandText = q;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue(_MaSoVar, slip.MaSo);
            cmd.Parameters.AddWithValue(_SoTienVar, slip.SoTien);
            cmd.Parameters.AddWithValue(_MaKHVar, slip.MaKH);
            cmd.Parameters.AddWithValue(_MaNVVar, slip.MaNV);
            cmd.Parameters.AddWithValue(_GhiChuVar, slip.GhiChu);
            cmd.Parameters.AddWithValue(_NgayTaoVar, slip.NgayTao);
            cmd.Prepare();

            BaseDBConnection.OpenConnection();
            cmd.ExecuteNonQuery();
            BaseDBConnection.CloseConnection();
        }

        public void UpdateSlipByMaPhieu(TransactionSlip updatedSlip)
        {
            db.Query(_tableName).Where(_MaPhieu, updatedSlip.MaPhieu).Update(updatedSlip);
        }

        public bool DeleteSlipByMaPhieu(int MaPhieu)
        {
            try
            {
                db.Query(_tableName).Where(_MaPhieu, MaPhieu).Delete();
                return true;
            } 
            catch { return false; }
        }

        public bool DeleteSlipByMaSo(int MaSo)
        {
            try
            {
                db.Query(_tableName).Where(_MaSo, MaSo).Delete();
                return true;
            }
            catch { return false; }
        }

        public TransactionSlipsDA()
        {
            MySqlCompiler compiler = new();
            db = new QueryFactory(BaseDBConnection.Connection, compiler);
        }

        private readonly QueryFactory db;

        private readonly string _MaPhieu = "MaPhieu";
        private readonly string _MaSo = "MaSo";

        private readonly string _MaSoVar = "@MaSo";
        private readonly string _SoTienVar = "@SoTien";
        private readonly string _MaKHVar = "@MaKH";
        private readonly string _MaNVVar = "@MaNV";
        private readonly string _GhiChuVar = "@GhiChu";
        private readonly string _NgayTaoVar = "@NgayTao";

        protected override string _tableName => "Phieu";
    }
}
