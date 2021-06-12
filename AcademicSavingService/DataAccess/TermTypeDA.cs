using System.Collections.Generic;
using System.Collections.ObjectModel;
using System;
using AcademicSavingService.InpcContainers;
using AcademicSavingService.Model;
using SqlKata.Compilers;
using SqlKata.Execution;

namespace AcademicSavingService.DataAccess
{
    public class TermTypeDA : BaseDataAccess
    {
        public ObservableCollection<TermTypeViewModel> GetAllTermTypes()
        {
            var collection = db.Query(_tableName).Get<TermTypeViewModel>();
            return new ObservableCollection<TermTypeViewModel>(collection);
        }

        public ObservableCollection<TermTypeViewModel> GetTermTypeByMaKyHan(int MaKyHan)
        {
            var collection = db.Query(_tableName).Where(_MaKyHan, MaKyHan).Get<TermTypeViewModel>();
            return new ObservableCollection<TermTypeViewModel>(collection);
        }

        public bool CreateLoaiKyHan(TermType term)
        {
            string q = $"CALL ThemKyHan({_KyHanVar}, {_LaiSuatVar}, {_NgayTaoVar}, {_NgayNgungSuDungVar})";
            cmd.CommandText = q;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue(_KyHanVar, term.KyHan);
            cmd.Parameters.AddWithValue(_LaiSuatVar, term.LaiSuat);
            cmd.Parameters.AddWithValue(_NgayTaoVar, term.NgayTao);
            cmd.Parameters.AddWithValue(_NgayNgungSuDungVar, term.NgayNgungSuDung);
            cmd.Prepare();

            BaseDBConnection.OpenConnection();
            try
            {
                cmd.ExecuteNonQuery();
                return true;
            }
            catch { return false; }
            finally { BaseDBConnection.CloseConnection(); }
        }

        public bool SetKyHanUnused(TermType term, DateTime stopDate)
        {
            string q = $"CALL NgungSuDungKyHan({_KyHanVar}, {_NgayNgungSuDungMoiVar})";
            cmd.CommandText = q;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue(_KyHanVar, term.KyHan);
            cmd.Parameters.AddWithValue(_NgayNgungSuDungMoiVar, stopDate);
            cmd.Prepare();

            BaseDBConnection.OpenConnection();
            try
            {
                cmd.ExecuteNonQuery();
                return true;
            }
            catch { return false; }
            finally { BaseDBConnection.CloseConnection(); }
        }

        public TermTypeDA()
        {
            MySqlCompiler compiler = new();
            db = new QueryFactory(BaseDBConnection.Connection, compiler);
        }

        private readonly QueryFactory db;

        private readonly string _MaKyHan = "MaKyHan";
        
        private readonly string _KyHanVar = "@KyHan";
        private readonly string _LaiSuatVar = "@LaiSuat";
        private readonly string _NgayTaoVar = "@NgayTao";
        private readonly string _NgayNgungSuDungVar = "@NgayNgungSuDung";
        private readonly string _NgayNgungSuDungMoiVar = "@NgayNgungSuDungMoi";

        protected override string _tableName => "LoaiKyHan";
    }
}
