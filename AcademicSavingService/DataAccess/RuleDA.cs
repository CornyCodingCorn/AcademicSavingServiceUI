using System;
using System.Collections.ObjectModel;
using System.Linq;
using AcademicSavingService.INPC;
using SqlKata.Compilers;
using SqlKata.Execution;


namespace AcademicSavingService.DataAccess
{
    public class RuleDA : BaseDataAccess<RuleINPC, int>
    {
        public ObservableCollection<RuleINPC> GetRuleByMaQD(int MaQD)
        {
            var collection = db.Query(_tableName).Where(_MaQD, MaQD).Get<RuleINPC>();
            return new ObservableCollection<RuleINPC>(collection);
        }

        public RuleINPC GetLatestRule()
        {
            var collection = db.Query(_tableName).OrderByDesc(_MaQD).Limit(1).Get<RuleINPC>();
            return collection.FirstOrDefault();
        }

        public override void Create(RuleINPC rule)
        {
            db.Query(_tableName).Insert(rule);
        }

        public override void Delete(int key)
        {
            throw new NotImplementedException();
        }

        public override ObservableCollection<RuleINPC> GetAll()
        {
            var collection = db.Query(_tableName).Get<RuleINPC>();
            return new ObservableCollection<RuleINPC>(collection);
        }

        public RuleDA()
        {
            db = new QueryFactory(BaseDBConnection.Connection, new MySqlCompiler());
        }

        private const string _MaQD = "MaQD";

        protected override string _tableName => "QUYDINH";
    }
}
