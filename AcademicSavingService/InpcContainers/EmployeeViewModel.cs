using System;
using AcademicSavingService.Model;

namespace AcademicSavingService.InpcContainers
{
    public class EmployeeViewModel : BaseViewModel, IReturnModel<Employee>
    {
        public int MaNV { get; set; }
        public string HoTen { get; set; }
        public string CMND { get; set; }
        public string SDT { get; set; }
        public string DiaChi { get; set; }
        public int NoiLamViec { get; set; }
        public DateTime NgayVaoLam { get; set; }

        public Employee Model => new(MaNV, HoTen, CMND, SDT, DiaChi, NoiLamViec, NgayVaoLam);

        public EmployeeViewModel() { }

        public EmployeeViewModel(int maNV, string hoTen, string cmnd, string sdt, string diaChi, int noiLamViec, DateTime ngayVaoLam)
        {
            MaNV = maNV;
            HoTen = hoTen;
            CMND = cmnd;
            SDT = sdt;
            DiaChi = diaChi;
            NoiLamViec = noiLamViec;
            NgayVaoLam = ngayVaoLam;
        }
    }
}
