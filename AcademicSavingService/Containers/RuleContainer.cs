using System;
using System.Linq;
using AcademicSavingService.INPC;
using AcademicSavingService.DataAccess;
using System.Collections.ObjectModel;

namespace AcademicSavingService.Containers
{
    public class RuleContainer : BaseContainer<RuleINPC, int>
    {
        public RuleINPC GetLatestRule()
        {
            return _ruleDa.GetLatestRule();
        }

        public override void AddToCollection(RuleINPC rule)
        {
            _ruleDa.Create(rule);
            Collection.Add(rule);
            Collection.OrderBy(item => item.MaQD);
        }

        public override void DeleteFromCollectionByDefaultKey(int field)
        {
            throw new NotImplementedException();
        }

        public override ObservableCollection<RuleINPC> GetFromCollectionByDefaultKey(int MaQD)
        {
            ObservableCollection<RuleINPC> collection = new();
            var rule = Collection.SingleOrDefault(item => item.MaQD == MaQD);
            if (rule != null) collection.Add(rule);

            return collection;
        }

        public override int GetNextAutoID()
        {
            return _ruleDa.GetNextAutoID();
        }

        public RuleContainer()
        {
            Collection = _ruleDa.GetAll();
            Collection.OrderBy(item => item.MaQD);
        }

        private readonly RuleDA _ruleDa = new();
        private static readonly RuleContainer _instance = new();

        public static RuleContainer Instance => _instance;
    }
}
