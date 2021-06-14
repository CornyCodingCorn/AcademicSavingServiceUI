﻿using AcademicSavingService.InpcContainers;
using AcademicSavingService.Model;
using System.Collections.ObjectModel;
using System;
using SqlKata.Execution;
using SqlKata.Compilers;

namespace AcademicSavingService.DataAccess
{
    public class SavingAccountDA : BaseDataAccess
    {
        public ObservableCollection<SavingAccountViewModel> GetAllSavingAccounts()
        {
            var collection = db.Query(_tableName).Join(_termTypeTableName, _stkTermTypeID, _loaiKyHanTermTypeID).Get<SavingAccountViewModel>();
            return new ObservableCollection<SavingAccountViewModel>(collection);
        }

        public ObservableCollection<SavingAccountViewModel> GetSavingAccountByMaSo(int MaSo)
        {
            var collection = db.Query(_tableName).Where(_MaSo, MaSo).Get<SavingAccountViewModel>();
            return new ObservableCollection<SavingAccountViewModel>(collection);
        }

        public ObservableCollection<SavingAccountViewModel> GetSavingAccountsByMaKH(int MaKH)
        {
            var collection = db.Query(_tableName).Where(_MaKH, MaKH).Get<SavingAccountViewModel>();
            return new ObservableCollection<SavingAccountViewModel>(collection);
        }

        public SavingAccount CreateSavingAccount(SavingAccount account)
        {
            SavingAccount rValue = null;
            string q = $"CALL ThemSoTietKiemVaReturn({_MaKHVar}, {_KyHanVar}, {_SoTienBanDauVar}, {_NgayTaoVar})";
            cmd.CommandText = q;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue(_MaKHVar, account.MaKH);
            cmd.Parameters.AddWithValue(_KyHanVar, account.KyHan);
            cmd.Parameters.AddWithValue(_SoTienBanDauVar, account.SoTienBanDau);
            cmd.Parameters.AddWithValue(_NgayTaoVar, account.NgayTao);


            BaseDBConnection.OpenConnection();
            var result = cmd.ExecuteReader();
            if (result.Read())
            {
                rValue = new SavingAccount
                {
                    MaKH = result.GetInt32(_MaKH),
                    MaSo = result.GetInt32(_MaSo),
                    NgayTao = result.GetDateTime(_NgayTao),
                    SoDu = result.GetDecimal(_SoDu),
                    SoTienBanDau = result.GetDecimal(_SoTienBanDau),
                    LanCapNhatCuoi = result.GetDateTime(_LanCapNhatCuoi)
                };
            }
            BaseDBConnection.CloseConnection();

            return rValue;
        }

        public SavingAccount UpdateSavingAccountStateToNgayCanUpdate(int MaSo, DateTime NgayCanUpdate)
        {
            SavingAccount rValue = null;
            string q = $"CALL UpdateSoTietKiemVaReturn({_MaSoVar}, {_NgayCanUpdateVar})";
            cmd.CommandText = q;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue(_MaSoVar, MaSo);
            cmd.Parameters.AddWithValue(_NgayCanUpdateVar, NgayCanUpdate);

            BaseDBConnection.OpenConnection();
            var result = cmd.ExecuteReader();
            if (result.Read())
            {
                rValue = new SavingAccount
                {
                    SoDu = result.GetDecimal(_SoDu),
                    LanCapNhatCuoi = result.GetDateTime(_LanCapNhatCuoi)
                };
            }
            BaseDBConnection.CloseConnection();

            return rValue;
        }

        //TODO: Implement UpdateSavingAccountInfo

        public void DeleteSavingAccount(int MaSo)
        {
            db.Query(_tableName).Where(_MaSo, MaSo).Delete();
        }

        public SavingAccountDA()
        {
            MySqlCompiler compiler = new();
            db = new QueryFactory(BaseDBConnection.Connection, compiler);
        }

        private readonly QueryFactory db;

        private readonly string _MaSo = "MaSo";
        private readonly string _MaKH = "MaKH";
        private readonly string _NgayTao = "NgayTao";
        private readonly string _SoDu = "SoDu";
        private readonly string _SoTienBanDau = "SoTienBanDau";
        private readonly string _LanCapNhatCuoi = "LanCapNhatCuoi";

        private readonly string _MaSoVar = "@MaSo";
        private readonly string _MaKHVar = "@MaKH";
        private readonly string _KyHanVar = "@KyHan";
        private readonly string _SoTienBanDauVar = "@SoTienBanDau";
        private readonly string _NgayTaoVar = "@NgayTao";
        private readonly string _NgayCanUpdateVar = "@NgayCanUpdate";

        private readonly string _termTypeTableName = "LoaiKyHan";
        private readonly string _stkTermTypeID = "SoTietKiem.MaKyHan";
        private readonly string _loaiKyHanTermTypeID = "LoaiKyHan.MaKyHan";

        protected override string _tableName => "SoTietKiem";
    }
}