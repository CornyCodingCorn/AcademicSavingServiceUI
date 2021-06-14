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

        public void UpdateSavingAccountStateToNgayCanUpdate(int MaSo, DateTime NgayCanUpdate)
        {
            _accountDA.UpdateSavingAccountStateToNgayCanUpdate(MaSo, NgayCanUpdate);
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
            collection.Add(Collection.Single(item => item.MaSo == MaSo));

            return collection;
        }

        private SavingAccountContainer()
        {
            Collection = _accountDA.GetAll();
        }

        private SavingAccountDA _accountDA = new();
        private readonly SavingAccountContainer _instance = new();

        public SavingAccountContainer Instance => _instance;
    }
}
