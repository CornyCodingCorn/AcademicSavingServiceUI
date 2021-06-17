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

        public ObservableCollection<TermTypeINPC> GetCurrentlyActiveTerms()
        {
            return new ObservableCollection<TermTypeINPC>(Collection.Where(item => item.NgayNgungSuDung == null));
        }

        public bool DisableTerm(TermTypeINPC term, DateTime stopDate)
        {
            if (_termDA.SetTermUnused(term, stopDate))
            {
                foreach (var item in Collection)
                {
                    if (item.MaKyHan == term.MaKyHan)
                    {
                        item.NgayNgungSuDung = stopDate;
                        break;
                    }
                }
                return true;
            }
            return false;
        }

        public bool CheckIfTermIsReferenced(int MaKyHan)
        {
            return _termDA.CheckIfTermIsReferencedByMaKyHan(MaKyHan);
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
            var term = Collection.SingleOrDefault(item => item.MaKyHan == MaKyHan);
            if (term != null) collection.Add(term);

            return collection;
        }

        public override int GetNextAutoID()
        {
            return _termDA.GetNextAutoID();
        }

        private TermTypeContainer()
        {
            Collection = _termDA.GetAll();
        }

        private readonly TermTypeDA _termDA = new();
        private static readonly TermTypeContainer _instance = new();
        public static TermTypeContainer Instance => _instance;
    }
}
