using System;
using System.Collections.ObjectModel;
using System.Diagnostics;
using AcademicSavingService.DataAccess;
using AcademicSavingService.Model;

namespace AcademicSavingService.InpcContainers
{
    public class CustomerViewModel : BaseViewModel, IReturnModel<Customer>
    {
        public CustomerViewModel() { }

        public CustomerViewModel(int maKH, string hoTen, string cmnd, string sdt, string diaChi, DateTime ngayDangKy)
        {
            MaKH = maKH;
            HoTen = hoTen;
            CMND = cmnd;
            SDT = sdt;
            DiaChi = diaChi;
            NgayDangKy = ngayDangKy;
        }


        public static void CallLoadCustomers()
        {
            _needUpdate = false;
            _stopwatch.Restart();
            var contents = _dataAccess.GetAllCustomers();
            _container.Clear();
            foreach (var row in contents)
            {
                if (!Container.Contains(row))
                    Container.Add(row);
            }
        }

        public Customer Model => new(MaKH, HoTen, CMND, SDT, DiaChi, NgayDangKy);

        public int MaKH { get; set; }
        public string HoTen { get; set; }
        public string CMND { get; set; }
        public string SDT { get; set; }
        public string DiaChi { get; set; }
        public DateTime NgayDangKy { get; set; }

        protected static readonly CustomerDA _dataAccess = new CustomerDA();
        protected static volatile bool _needUpdate = true;
        protected static readonly object _containerLock = new object();
        protected static Stopwatch _stopwatch = new Stopwatch();
        protected static ObservableCollection<CustomerViewModel> _container = new ObservableCollection<CustomerViewModel>();
        public static ObservableCollection<CustomerViewModel> Container
        {
            get
            {
                lock (_containerLock)
                {
                    if (_stopwatch.ElapsedTicks == GlobalVars.UpdateSec * 1000)
                    {
                        CallLoadCustomers();
                    }
                    return _container;
                }
            }
        }

        static CustomerViewModel()
        {
            _stopwatch.Start();
            CallLoadCustomers();
        }
    }
}
