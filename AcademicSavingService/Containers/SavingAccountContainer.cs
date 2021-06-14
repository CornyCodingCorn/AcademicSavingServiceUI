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
            var result = _accountDA.UpdateSavingAccountStateToNgayCanUpdate(MaSo, NgayCanUpdate);
            for (int i = 0; i < Collection.Count; i++)
                if (Collection[i].MaSo == MaSo)
				{
                    Collection[i].LanCapNhatCuoi = NgayCanUpdate;
                    Collection[i].SoDu = result.SoDu;
				}
        }

        public void UpdateALLSavingAccountStateToNgayCanUpdate(DateTime NgayCanUpdate)
        {
            foreach (var row in Collection)
			{
                var result = _accountDA.UpdateSavingAccountStateToNgayCanUpdate(row.MaSo, NgayCanUpdate);
                row.LanCapNhatCuoi = NgayCanUpdate;
                row.SoDu = result.SoDu;
            }
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
