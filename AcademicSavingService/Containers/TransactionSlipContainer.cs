﻿using System;
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

        public override void AddToCollection(TransactionSlipINPC slip)
        {
            _slipDA.Create(slip);
            Collection.Add(slip);
        }

        public override void DeleteFromCollectionByDefaultKey(int MaPhieu)
        {
            _slipDA.Delete(MaPhieu);
            Collection.Remove(Collection.SingleOrDefault(item => item.MaPhieu == MaPhieu));
        }

        public override ObservableCollection<TransactionSlipINPC> GetFromCollectionByDefaultKey(int MaPhieu)
        {
            ObservableCollection<TransactionSlipINPC> collection = new();
            collection.Add(Collection.SingleOrDefault(item => item.MaPhieu == MaPhieu));

            return collection;
        }

        protected TransactionSlipDA _slipDA;
    }
}