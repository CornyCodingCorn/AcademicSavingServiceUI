using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AcademicSavingService.Model
{
    public class Employee
    {
        public int MaNV { get; set; }
        public string HoTen { get; set; }
        public string CMND { get; set; }
        public string SDT { get; set; }
        public string DiaChi { get; set; }
        public int NoiLamViec { get; set; }
        public DateTime NgayVaoLam { get; set; }

        public Employee() { }

        public Employee(int maNV, string hoTen, string cmnd, string sdt, string diaChi, int noiLamViec, DateTime ngayVaoLam)
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
