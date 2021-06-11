using System.Collections.ObjectModel;
using AcademicSavingService.InpcContainers;
using AcademicSavingService.Model;
using SqlKata.Compilers;
using SqlKata.Execution;

namespace AcademicSavingService.DataAccess
{
    public class EmployeeDA : BaseDataAccess
    {
        public ObservableCollection<EmployeeViewModel> GetAllEmployee()
        {
            var collection = db.Query(_tableName).Get<EmployeeViewModel>();
            return new ObservableCollection<EmployeeViewModel>(collection);
        }

        public ObservableCollection<EmployeeViewModel> GetEmployeeByMaNV(int MaNV)
        {
            var collection = db.Query(_tableName).Where(_MaNV, MaNV).Get<EmployeeViewModel>();
            return new ObservableCollection<EmployeeViewModel>(collection);
        }

        public ObservableCollection<EmployeeViewModel> GetEmployeeByHoTen(string HoTen)
        {
            var collection = db.Query(_tableName).Where(_HoTen, HoTen).Get<EmployeeViewModel>();
            return new ObservableCollection<EmployeeViewModel>(collection);
        }

        public ObservableCollection<EmployeeViewModel> GetEmployeeByCMND(string CMND)
        {
            var collection = db.Query(_tableName).Where(_CMND, CMND).Get<EmployeeViewModel>();
            return new ObservableCollection<EmployeeViewModel>(collection);
        }

        public ObservableCollection<EmployeeViewModel> GetEmployeeBySDT(string SDT)
        {
            var collection = db.Query(_tableName).Where(_SDT, SDT).Get<EmployeeViewModel>();
            return new ObservableCollection<EmployeeViewModel>(collection);
        }

        public bool CreateEmployee(Employee employee)
        {
            try
            {
                db.Query(_tableName).Insert(employee);
                return true;
            }
            catch { return false; }
        }

        public bool UpdateEmployeeByMaNV(Employee updatedEmployee)
        {
            try
            {
                db.Query(_tableName).Where(_MaNV, updatedEmployee.MaNV).Update(updatedEmployee);
                return true;
            }
            catch { return false; }
        }

        public bool DeleteEmployeeByMaNV(int MaNV)
        {
            var collection = db.Query(_phieuTableName).Where(_MaNV, MaNV).First<TransactionSlipViewModel>();
            
            if (collection != null)
            {
                try
                {
                    db.Query(_tableName).Where(_MaNV, MaNV).Delete();
                }
                catch { return false; }

                return true;
            }
            return false;
        }

        public EmployeeDA()
        {
            db = new QueryFactory(BaseDBConnection.Connection, new MySqlCompiler());
        }

        private readonly QueryFactory db;

        private readonly string _MaNV = "MaNV";
        private readonly string _HoTen = "HoTen";
        private readonly string _CMND = "CMND";
        private readonly string _SDT = "SDT";

        private readonly string _phieuTableName = "Phieu";

        protected override string _tableName => "NhanVien";
    }
}
