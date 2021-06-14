using AcademicSavingService.DataAccess;
using AcademicSavingService.INPC;
using System.Linq;
using System.Collections.ObjectModel;
using System.Collections.Generic;
using System;

namespace AcademicSavingService.Containers
{
    public class TermTypeContainer : BaseContainer<TermTypeINPC, int>
    {
        public ObservableCollection<KeyValuePair<int, float>> GetClosestTermAndInterestToDate(DateTime NgayKiemTra)
        {
            return _termDA.GetClosestTermAndInterestToDate(NgayKiemTra);
        }

        public bool StopUsingKyHan(TermTypeINPC term, DateTime stopDate)
        {
            if (_termDA.SetKyHanUnused(term, stopDate))
            {
                Collection.Remove(Collection.SingleOrDefault(item => item.MaKyHan == term.MaKyHan));
                return true;
            }
            return false;
        }

        public override void AddToCollection(TermTypeINPC term)
        {
            _termDA.Create(term);
            Collection.Add(term);
        }

        public override void DeleteFromCollectionByDefaultKey(int MaKyHan)
        {
            _termDA.Delete(MaKyHan);
            Collection.Remove(Collection.SingleOrDefault(item => item.MaKyHan == MaKyHan));
        }

        public override ObservableCollection<TermTypeINPC> GetFromCollectionByDefaultKey(int MaKyHan)
        {
            ObservableCollection<TermTypeINPC> collection = new();
            collection.Add(Collection.SingleOrDefault(item => item.MaKyHan == MaKyHan));

            return collection;
        }

        private TermTypeContainer()
        {
            Collection = _termDA.GetAll();
        }

        private TermTypeDA _termDA = new();
        private readonly TermTypeContainer _instance = new();

        public TermTypeContainer Instance => _instance;
    }
}
