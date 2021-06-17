using System;
using AcademicSavingService.INPC;
using AcademicSavingService.DataAccess;
using System.Collections.ObjectModel;

namespace AcademicSavingService.Containers
{
    public class DailyReportContainer : BaseContainer<DailyReportINPC, int>
    {
        public override void AddToCollection(DailyReportINPC report)
        {
            _reportDA.Create(report);
            Collection = _reportDA.GetAll();
        }

        public override void DeleteFromCollectionByDefaultKey(int field)
        {
            throw new NotImplementedException();
        }

        public override ObservableCollection<DailyReportINPC> GetFromCollectionByDefaultKey(int field)
        {
            throw new NotImplementedException();
        }

        public override int GetNextAutoID()
        {
            throw new NotImplementedException();
        }

        public DailyReportContainer()
        {
            Collection = _reportDA.GetAll();
        }

        private readonly DailyReportDA _reportDA = new();
        private static DailyReportContainer _instance = new();

        public static DailyReportContainer Instance => _instance;
    }
}
