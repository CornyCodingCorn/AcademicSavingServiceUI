using AcademicSavingService.Model;
using AcademicSavingService.InpcContainers;
using System.Collections.ObjectModel;
using SqlKata;
using SqlKata.Compilers;
using SqlKata.Execution;
using System;

namespace AcademicSavingService.DataAccess
{
    public class CustomersDA : BaseDataAccess<CustomerViewModel>
    {
        public ObservableCollection<CustomerViewModel> GetAllCustomers()
        {
            var collection = db.Query(_tableName).Get<CustomerViewModel>();
            return new ObservableCollection<CustomerViewModel>(collection);
        }

        public ObservableCollection<CustomerViewModel> GetCustomerByMaKH(int MaKH)
        {
            var collection = db.Query(_tableName).Where(_MaKH, MaKH).Get<CustomerViewModel>();
            return new ObservableCollection<CustomerViewModel>(collection);
        }

        public ObservableCollection<CustomerViewModel> GetCustomersByHoTen(string HoTen)
        {
            var collection = db.Query(_tableName).Where(_HoTen, HoTen).Get<CustomerViewModel>();
            return new ObservableCollection<CustomerViewModel>(collection);
        }

        public ObservableCollection<CustomerViewModel> GetCustomersByCMND(string CMND)
        {
            var collection = db.Query(_tableName).Where(_CMND, CMND).Get<CustomerViewModel>();
            return new ObservableCollection<CustomerViewModel>(collection);
        }

        public ObservableCollection<CustomerViewModel> GetCustomersBySDT(string SDT)
        {
            var collection = db.Query(_tableName).Where(_SDT, SDT).Get<CustomerViewModel>();
            return new ObservableCollection<CustomerViewModel>(collection);
        }

        public void CreateCustomer(Customer customer)
        {
            db.Query(_tableName).Insert(customer);
        }

        public void UpdateCustomerByMaKH(Customer updatedCustomer)
        {
            db.Query(_tableName).Where(_MaKH, updatedCustomer.MaKH).Update(updatedCustomer);
        }

        public CustomersDA()
        {
            MySqlCompiler compiler = new();
            db = new QueryFactory(BaseDBConnection.Connection, compiler);
        }

        private readonly QueryFactory db;

        private readonly string _MaKH = "MaKH";
        private readonly string _HoTen = "HoTen";
        private readonly string _CMND = "CMND";
        private readonly string _SDT = "SDT";

        protected override string _tableName => "KhachHang";
    }
}
