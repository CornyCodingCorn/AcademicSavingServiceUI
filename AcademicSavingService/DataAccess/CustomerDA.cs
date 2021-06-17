using AcademicSavingService.INPC;
using System.Collections.ObjectModel;
using SqlKata.Compilers;
using SqlKata.Execution;

namespace AcademicSavingService.DataAccess
{
    public class CustomerDA : BaseDataAccess<CustomerINPC, int>
    {
        public ObservableCollection<CustomerINPC> GetCustomerByMaKH(int MaKH)
        {
            var collection = db.Query(_tableName).Where(_MaKH, MaKH).Get<CustomerINPC>();
            return new ObservableCollection<CustomerINPC>(collection);
        }

        public ObservableCollection<CustomerINPC> GetCustomersByHoTen(string HoTen)
        {
            var collection = db.Query(_tableName).Where(_HoTen, HoTen).Get<CustomerINPC>();
            return new ObservableCollection<CustomerINPC>(collection);
        }

        public ObservableCollection<CustomerINPC> GetCustomersByCMND(string CMND)
        {
            var collection = db.Query(_tableName).Where(_CMND, CMND).Get<CustomerINPC>();
            return new ObservableCollection<CustomerINPC>(collection);
        }

        public ObservableCollection<CustomerINPC> GetCustomersBySDT(string SDT)
        {
            var collection = db.Query(_tableName).Where(_SDT, SDT).Get<CustomerINPC>();
            return new ObservableCollection<CustomerINPC>(collection);
        }

        public void UpdateCustomerByMaKH(CustomerINPC updatedCustomer)
        {
            db.Query(_tableName).Where(_MaKH, updatedCustomer.MaKH).Update(updatedCustomer);
        }

        public override void Create(CustomerINPC customer)
        {
            db.Query(_tableName).Insert(customer);
        }

        public override ObservableCollection<CustomerINPC> GetAll()
        {
            var collection = db.Query(_tableName).Get<CustomerINPC>();
            return new ObservableCollection<CustomerINPC>(collection);
        }

        public override void Delete(int MaKH)
        {
            db.Query(_tableName).Where(_MaKH, MaKH).Delete();
        }

        public CustomerDA()
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
