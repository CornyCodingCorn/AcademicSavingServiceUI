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

        public bool DisableTerm(TermTypeINPC term, DateTime stopDate)
        {
            if (_termDA.SetTermUnused(term, stopDate))
            {
                Collection.Remove(Collection.SingleOrDefault(item => item.MaKyHan == term.MaKyHan));
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
            collection.Add(Collection.SingleOrDefault(item => item.MaKyHan == MaKyHan));

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

        private TermTypeDA _termDA = new();
        private static readonly TermTypeContainer _instance = new();
        public static TermTypeContainer Instance => _instance;
    }
}
