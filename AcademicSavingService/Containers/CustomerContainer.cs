using System.Collections.ObjectModel;
using System.Linq;
using AcademicSavingService.DataAccess;
using AcademicSavingService.INPC;

namespace AcademicSavingService.Containers
{
    public class CustomerContainer : BaseContainer<CustomerINPC, int>
    {
        public override void AddToCollection(CustomerINPC customer)
        {
            _customerDA.Create(customer);
            Collection.Add(customer);
        }

        public override void DeleteFromCollectionByDefaultKey(int MaKH)
        {
            _customerDA.Delete(MaKH);
            Collection.Remove(Collection.SingleOrDefault(item => item.MaKH == MaKH));
        }

        public override void UpdateOnCollection(CustomerINPC updatedCustomer)
        {
            _customerDA.UpdateCustomerByMaKH(updatedCustomer);
            foreach (var item in Collection)
            {
                if (item.MaKH == updatedCustomer.MaKH)
                {
                    item.HoTen = updatedCustomer.HoTen;
                    item.CMND = updatedCustomer.CMND;
                    item.SDT = updatedCustomer.SDT;
                    item.DiaChi = updatedCustomer.DiaChi;
                    item.NgayDangKy = updatedCustomer.NgayDangKy;
                }
                break;
            }
        }

        public override ObservableCollection<CustomerINPC> GetFromCollectionByDefaultKey(int MaKH)
        {
            ObservableCollection<CustomerINPC> collection = new();
            collection.Add(Collection.SingleOrDefault(item => item.MaKH == MaKH));
            return collection;
        }

        public override int GetNextAutoID()
        {
            return _customerDA.GetNextAutoID();
        }

        public ObservableCollection<CustomerINPC> GetFromCollectionByHoTen(string HoTen)
        {
            return new ObservableCollection<CustomerINPC>(Collection.Where(item => item.HoTen == HoTen));
        }

        public ObservableCollection<CustomerINPC> GetFromCollectionByCMND(string CMND)
        {
            return new ObservableCollection<CustomerINPC>(Collection.Where(item => item.CMND == CMND));
        }

        public ObservableCollection<CustomerINPC> GetFromCollectionBySDT(string SDT)
        {
            return new ObservableCollection<CustomerINPC>(Collection.Where(item => item.SDT == SDT));
        }

        private CustomerContainer()
        {
            Collection = _customerDA.GetAll();
        }

        private CustomerDA _customerDA = new();
        private static readonly CustomerContainer _instance = new();
        public static CustomerContainer Instance => _instance;
    }
}
