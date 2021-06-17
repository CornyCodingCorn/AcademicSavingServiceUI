using AcademicSavingService.INPC;
using System.Collections.ObjectModel;
using System;
using SqlKata.Execution;
using SqlKata.Compilers;
using MySql.Data.MySqlClient;

namespace AcademicSavingService.DataAccess
{
    public class SavingAccountDA : BaseDataAccess<SavingAccountINPC, int>
    {
        public ObservableCollection<SavingAccountINPC> GetSavingAccountByMaSo(int MaSo)
        {
            var collection = db.Query(_tableName).Where(_MaSo, MaSo).Get<SavingAccountINPC>();
            return new ObservableCollection<SavingAccountINPC>(collection);
        }

        public ObservableCollection<SavingAccountINPC> GetSavingAccountsByMaKH(int MaKH)
        {
            var collection = db.Query(_tableName).Where(_MaKH, MaKH).Get<SavingAccountINPC>();
            return new ObservableCollection<SavingAccountINPC>(collection);
        }

        public override void Create(SavingAccountINPC savingAccount)
        {
            string q = $"CALL ThemSoTietKiem({_MaKHVar}, {_KyHanVar}, {_SoTienBanDauVar}, {_NgayTaoVar})";
            cmd.CommandText = q;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue(_MaKHVar, savingAccount.MaKH);
            cmd.Parameters.AddWithValue(_KyHanVar, savingAccount.KyHan);
            cmd.Parameters.AddWithValue(_SoTienBanDauVar, savingAccount.SoTienBanDau);
            cmd.Parameters.AddWithValue(_NgayTaoVar, savingAccount.NgayTao);

            try
            {
                BaseDBConnection.OpenConnection();
                cmd.ExecuteNonQuery();
                BaseDBConnection.CloseConnection();
            }
            catch (MySqlException)
            {
                throw;
            }
            finally
            {
                BaseDBConnection.CloseConnection();
            }
        }

        public override ObservableCollection<SavingAccountINPC> GetAll()
        {
            var collection = db.Query(_tableName).Join(_termTypeTableName, _stkTermTypeID, _loaiKyHanTermTypeID).Get<SavingAccountINPC>();
            return new ObservableCollection<SavingAccountINPC>(collection);
        }

        public override void Delete(int MaSo)
        {
            db.Query(_tableName).Where(_MaSo, MaSo).Delete();
        }

        public override void Update(SavingAccountINPC key)
        {
            db.Query(_tableName).Where(_MaSo, key.MaSo).Update(new
            {
                MaKH = key.MaKH,
                SoTienBanDau = key.SoTienBanDau,
                NgayTao = key.NgayTao
            });
        }

        private readonly string _MaSo = "MaSo";
        private readonly string _MaKH = "MaKH";

        private readonly string _MaKHVar = "@MaKH";
        private readonly string _KyHanVar = "@KyHan";
        private readonly string _SoTienBanDauVar = "@SoTienBanDau";
        private readonly string _NgayTaoVar = "@NgayTao";

        private readonly string _termTypeTableName = "LoaiKyHan";
        private readonly string _stkTermTypeID = "SoTietKiem.MaKyHan";
        private readonly string _loaiKyHanTermTypeID = "LoaiKyHan.MaKyHan";

        protected override string _tableName => "SoTietKiem";
    }
}
