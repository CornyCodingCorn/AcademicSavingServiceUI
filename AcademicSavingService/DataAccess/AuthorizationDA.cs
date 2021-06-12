using System;
using System.Collections.ObjectModel;
using AcademicSavingService.Model;
using SqlKata.Compilers;
using SqlKata.Execution;

namespace AcademicSavingService.DataAccess
{
    public class AuthorizationDA : BaseDataAccess
    {
        public ObservableCollection<Authorization> GetAllAuths()
        {
            var collection = db.Query(_tableName).Get<Authorization>();
            return new ObservableCollection<Authorization>(collection);
        }

        public ObservableCollection<Authorization> GetAuthByMaUQ(int MaUQ)
        {
            var collection = db.Query(_tableName).Where(_MaUQ, MaUQ).Get<Authorization>();
            return new ObservableCollection<Authorization>(collection);
        }

        public ObservableCollection<Authorization> GetAuthsByMaSo(int MaSo)
        {
            var collection = db.Query(_tableName).Where(_MaSo, MaSo).Get<Authorization>();
            return new ObservableCollection<Authorization>(collection);
        }

        public ObservableCollection<Authorization> GetAuthsByMaKH(int MaKH)
        {
            var collection = db.Query(_tableName).Where(_MaKH, MaKH).Get<Authorization>();
            return new ObservableCollection<Authorization>(collection);
        }

        public bool CreateAuth(Authorization auth)
        {
            try
            {
                db.Query(_tableName).Insert(auth);
                return true;
            }
            catch { return false; }
        }

        public bool SetAuthUnused(Authorization auth)
        {
            try
            {
                string q = $"CALL NgungSuDungUyQuyen({_MaKHVar}, {_MaSoVar}, {_NgayNgungSuDungVar})";
                cmd.CommandText = q;
                cmd.Parameters.Clear();
                cmd.Parameters.AddWithValue(_MaKHVar, auth.MaKH);
                cmd.Parameters.AddWithValue(_MaSoVar, auth.MaSo);
                cmd.Parameters.AddWithValue(_NgayNgungSuDungVar, auth.NgayNgungSuDung);
                cmd.Prepare();

                cmd.ExecuteNonQuery();
                return true;
            }
            catch { return false; }
        }

        public AuthorizationDA()
        {
            db = new QueryFactory(BaseDBConnection.Connection, new MySqlCompiler());
        }

        private readonly QueryFactory db;

        private readonly string _MaUQ = "MaUQ";
        private readonly string _MaSo = "MaSo";
        private readonly string _MaKH = "MaKH";

        private readonly string _MaSoVar = "@MaSo";
        private readonly string _MaKHVar = "@MaKH";
        private readonly string _NgayNgungSuDungVar = "@NgayNgungSuDung";

        protected override string _tableName => "UyQuyen";
    }
}
