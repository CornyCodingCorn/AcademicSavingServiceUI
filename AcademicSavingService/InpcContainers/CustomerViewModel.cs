using System;
using AcademicSavingService.Model;

namespace AcademicSavingService.InpcContainers
{
    public class CustomerViewModel : BaseViewModel, IReturnModel<Customer>
    {
        public CustomerViewModel() { }

        public CustomerViewModel(int maKH, string hoTen, string cmnd, string sdt, string diaChi, int noiDangKy, DateTime ngayDangKy)
        {
            MaKH = maKH;
            HoTen = hoTen;
            CMND = cmnd;
            SDT = sdt;
            DiaChi = diaChi;
            NoiDangKy = noiDangKy;
            NgayDangKy = ngayDangKy;
        }

        public Customer Model => new(MaKH, HoTen, CMND, SDT, DiaChi, NoiDangKy, NgayDangKy);

        public int MaKH { get; set; }
        public string HoTen { get; set; }
        public string CMND { get; set; }
        public string SDT { get; set; }
        public string DiaChi { get; set; }
        public int NoiDangKy { get; set; }
        public DateTime NgayDangKy { get; set; }
    }
}
