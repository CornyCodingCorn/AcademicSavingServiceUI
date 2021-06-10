using System;
using AcademicSavingService.Model;

namespace AcademicSavingService.InpcContainers
{
    public class CustomerViewModel : BaseINPC
    {
        private Customer _customer;

        public int MaKH
        {
            get => _customer.MaKH;
            set
            {
                _customer.MaKH = value;
                RaisePropertyChanged(nameof(MaKH));
            }
        }

        public string HoTen
        {
            get => _customer.HoTen;
            set
            {
                _customer.HoTen = value;
                RaisePropertyChanged(nameof(HoTen));
            }
        }

        public string CMND
        {
            get => _customer.CMND;
            set
            {
                _customer.CMND = value;
                RaisePropertyChanged(nameof(CMND));
            }
        }

        public string SDT
        {
            get => _customer.SDT;
            set
            {
                _customer.SDT = value;
                RaisePropertyChanged(nameof(SDT));
            }
        }

        public string DiaChi
        {
            get => _customer.DiaChi;
            set
            {
                _customer.DiaChi = value;
                RaisePropertyChanged(nameof(DiaChi));
            }
        }

        public int NoiDangKy
        {
            get => _customer.NoiDangKy;
            set
            {
                _customer.NoiDangKy = value;
                RaisePropertyChanged(nameof(NoiDangKy));
            }
        }

        public DateTime NgayDangKy
        {
            get => _customer.NgayDangKy;
            set
            {
                _customer.NgayDangKy = value;
                RaisePropertyChanged(nameof(NgayDangKy));
            }
        }

        public CustomerViewModel()
        {
            _customer = new Customer();
        }
    }
}
