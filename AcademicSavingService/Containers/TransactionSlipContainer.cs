using System;
using System.Linq;
using System.Collections.ObjectModel;
using AcademicSavingService.INPC;
using AcademicSavingService.DataAccess;

namespace AcademicSavingService.Containers
{
    public abstract class TransactionSlipContainer : BaseContainer<TransactionSlipINPC, int>
    {
        public ObservableCollection<TransactionSlipINPC> GetFromCollectionByMaPhieu(int MaPhieu)
        {
            return new ObservableCollection<TransactionSlipINPC>(Collection.Where(item => item.MaPhieu == MaPhieu));
        }

        public void DeleteFromCollectionByMaSo(int MaSo)
        {
            _slipDA.DeleteSlipByMaSo(MaSo);
            Collection.Remove(Collection.SingleOrDefault(item => item.MaSo == MaSo));
        }

		public override void UpdateOnCollection(TransactionSlipINPC item)
		{
			_slipDA.Update(item);
            for (int i = 0; i < Collection.Count; i++)
                if (Collection[i].MaPhieu == item.MaPhieu)
				{
                    Collection[i].GhiChu = item.GhiChu;
                    Collection[i].NgayTao = item.NgayTao;
                    Collection[i].SoTien = item.SoTien;
                }
		}

		public override void DeleteFromCollectionByDefaultKey(int MaPhieu)
        {
            _slipDA.Delete(MaPhieu);
            Collection.Remove(Collection.SingleOrDefault(item => item.MaPhieu == MaPhieu));
        }

        public override ObservableCollection<TransactionSlipINPC> GetFromCollectionByDefaultKey(int MaPhieu)
        {
            ObservableCollection<TransactionSlipINPC> collection = new();
            var slip = Collection.SingleOrDefault(item => item.MaPhieu == MaPhieu);
            if (slip != null) collection.Add(slip);

            return collection;
        }

        public override int GetNextAutoID()
        {
            return _slipDA.GetNextAutoID();
        }

        protected TransactionSlipDA _slipDA;
    }
}
