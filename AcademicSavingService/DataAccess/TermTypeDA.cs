using System.Collections.Generic;
using System.Collections.ObjectModel;
using System;
using AcademicSavingService.INPC;
using SqlKata.Compilers;
using SqlKata.Execution;

namespace AcademicSavingService.DataAccess
{
    public class TermTypeDA : BaseDataAccess<TermTypeINPC, int>
    {
        public ObservableCollection<TermTypeINPC> GetTermTypeByMaKyHan(int MaKyHan)
        {
            var collection = db.Query(_tableName).Where(_MaKyHan, MaKyHan).Get<TermTypeINPC>();
            return new ObservableCollection<TermTypeINPC>(collection);
        }

        public ObservableCollection<KeyValuePair<int, float>> GetClosestTermAndInterestToDate(DateTime NgayKiemTra)
        {
            var container = new ObservableCollection<KeyValuePair<int, float>>();
            string q = $"CALL LayKyHanVaLaiSuat({_NgayTaoVar})";
            cmd.CommandText = q;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue(_NgayTaoVar, NgayKiemTra);

            BaseDBConnection.OpenConnection();
            try
            {
                var result = cmd.ExecuteReader();
                while(result.Read())
                    container.Add(new KeyValuePair<int, float>(result.GetInt32(_KyHan), result.GetFloat(_LaiSuat)));
                return container;
            }
            catch { throw; }
            finally { BaseDBConnection.CloseConnection(); }
        }

        public bool SetKyHanUnused(TermTypeINPC term, DateTime stopDate)
        {
            string q = $"CALL NgungSuDungKyHan({_KyHanVar}, {_NgayNgungSuDungMoiVar})";
            cmd.CommandText = q;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue(_KyHanVar, term.KyHan);
            cmd.Parameters.AddWithValue(_NgayNgungSuDungMoiVar, stopDate);
            

            BaseDBConnection.OpenConnection();
            try
            {
                cmd.ExecuteNonQuery();
                return true;
            }
            catch { return false; }
            finally { BaseDBConnection.CloseConnection(); }
        }

        public override void Create(TermTypeINPC term)
        {
            string q = $"CALL ThemKyHan({_KyHanVar}, {_LaiSuatVar}, {_NgayTaoVar}, {_NgayNgungSuDungVar})";
            cmd.CommandText = q;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue(_KyHanVar, term.KyHan);
            cmd.Parameters.AddWithValue(_LaiSuatVar, term.LaiSuat);
            cmd.Parameters.AddWithValue(_NgayTaoVar, term.NgayTao);
            cmd.Parameters.AddWithValue(_NgayNgungSuDungVar, term.NgayNgungSuDung);

            BaseDBConnection.OpenConnection();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch { throw; }
            finally { BaseDBConnection.CloseConnection(); }
        }

        public override ObservableCollection<TermTypeINPC> GetAll()
        {
            var collection = db.Query(_tableName).Get<TermTypeINPC>();
            return new ObservableCollection<TermTypeINPC>(collection);
        }

        public override void Delete(int MaKyHan)
        {
            db.Query(_tableName).Where(_MaKyHan, MaKyHan).Delete();
        }

        public TermTypeDA()
        {
            MySqlCompiler compiler = new();
            db = new QueryFactory(BaseDBConnection.Connection, compiler);
        }

        private readonly QueryFactory db;

        private readonly string _MaKyHan = "MaKyHan";
        private readonly string _KyHan = "KyHan";
        private readonly string _LaiSuat = "LaiSuat";
        
        private readonly string _KyHanVar = "@KyHan";
        private readonly string _LaiSuatVar = "@LaiSuat";
        private readonly string _NgayTaoVar = "@NgayTao";
        private readonly string _NgayNgungSuDungVar = "@NgayNgungSuDung";
        private readonly string _NgayNgungSuDungMoiVar = "@NgayNgungSuDungMoi";

        protected override string _tableName => "LoaiKyHan";
    }
}
