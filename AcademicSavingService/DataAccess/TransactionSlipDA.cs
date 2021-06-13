using System.Collections.Generic;
using System.Collections.ObjectModel;
using AcademicSavingService.Model;
using AcademicSavingService.InpcContainers;
using SqlKata.Execution;
using SqlKata.Compilers;

namespace AcademicSavingService.DataAccess
{
    public abstract class TransactionSlipDA : BaseDataAccess
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

        public virtual TransactionSlip CreateSlip(TransactionSlip slip)
        {
            TransactionSlip rValue = null;
            string q = $"CALL ThemPhieu({_MaSoVar}, {_SoTienVar}, {_GhiChuVar}, {_NgayTaoVar})";
            cmd.CommandText = q;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue(_MaSoVar, slip.MaSo);
            cmd.Parameters.AddWithValue(_SoTienVar, slip.SoTien);
            cmd.Parameters.AddWithValue(_GhiChuVar, slip.GhiChu);
            cmd.Parameters.AddWithValue(_NgayTaoVar, slip.NgayTao);

            BaseDBConnection.OpenConnection();
            var result = cmd.ExecuteReader();
            if (result.Read())
            {
                rValue = new TransactionSlip
                {
                    NgayTao = result.GetDateTime(_NgayTao),
                    SoTien = result.GetDecimal(_SoTien),
                    MaPhieu = result.GetInt32(_MaPhieu)
                };
            }
            BaseDBConnection.CloseConnection();
            return rValue;
        }

        public virtual bool UpdateSlipByMaPhieu(TransactionSlip updatedSlip)
        {
            try
            {
                db.Query(_tableName).Where(_MaPhieu, updatedSlip.MaPhieu).Update(updatedSlip);
                return true;
            }
            catch { return false; }
        }

        public virtual bool DeleteSlipByMaPhieu(int MaPhieu)
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
