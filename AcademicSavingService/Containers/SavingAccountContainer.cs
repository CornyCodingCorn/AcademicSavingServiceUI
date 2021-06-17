using System.Linq;
using AcademicSavingService.INPC;
using AcademicSavingService.DataAccess;
using System.Collections.ObjectModel;
using System;

namespace AcademicSavingService.Containers
{
    public class SavingAccountContainer : BaseContainer<SavingAccountINPC, int>
    {
        public ObservableCollection<SavingAccountINPC> GetFromCollectionByMaKH(int MaKH)
        {
            return _accountDA.GetSavingAccountsByMaKH(MaKH);
        }

        public bool UpdateSavingAccount(int MaSo)
        {
            var result = _accountDA.GetSavingAccountByMaSo(MaSo);
            if (result.Count == 0)
                return false;

            for (int i = 0; i < Collection.Count; i++)
			{
                if (Collection[i].MaSo == MaSo)
                {
                    Collection[i] = result[0];
                    return true;
                }
            }
            return false;
        }

        public override void AddToCollection(SavingAccountINPC savingAccount)
        {
            _accountDA.Create(savingAccount);
            Collection.Add(savingAccount);
        }

        public override void DeleteFromCollectionByDefaultKey(int MaSo)
        {
            _accountDA.Delete(MaSo);
            Collection.Remove(Collection.Single(item => item.MaSo == MaSo));
        }

        public override ObservableCollection<SavingAccountINPC> GetFromCollectionByDefaultKey(int MaSo)
        {
            ObservableCollection<SavingAccountINPC> collection = new();
            var account = Collection.SingleOrDefault(item => item.MaSo == MaSo);
            if (account != null) collection.Add(account);

            return collection;
        }

        public override int GetNextAutoID()
        {
            return _accountDA.GetNextAutoID();
        }

        private SavingAccountContainer()
        {
            Collection = _accountDA.GetAll();
        }

        private SavingAccountDA _accountDA = new();
        private static readonly SavingAccountContainer _instance = new();
        public static SavingAccountContainer Instance => _instance;
    }
}
