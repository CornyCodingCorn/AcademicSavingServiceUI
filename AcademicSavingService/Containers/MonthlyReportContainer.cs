using System;
using AcademicSavingService.INPC;
using AcademicSavingService.DataAccess;
using System.Collections.ObjectModel;

namespace AcademicSavingService.Containers
{
    public class MonthlyReportContainer : BaseContainer<MonthlyReportINPC, int>
    {
        public override void AddToCollection(MonthlyReportINPC report)
        {
            _reportDA.Create(report);
            Collection = _reportDA.GetAll();
        }

        public override void DeleteFromCollectionByDefaultKey(int field)
        {
            throw new NotImplementedException();
        }

        public override ObservableCollection<MonthlyReportINPC> GetFromCollectionByDefaultKey(int field)
        {
            throw new NotImplementedException();
        }

        public override int GetNextAutoID()
        {
            throw new NotImplementedException();
        }

        public MonthlyReportContainer()
        {
            Collection = _reportDA.GetAll();
        }

        private readonly MonthlyReportDA _reportDA = new();
        private static MonthlyReportContainer _instance = new();

        public static MonthlyReportContainer Instance => _instance;
    }
}
