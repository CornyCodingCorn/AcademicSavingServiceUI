using System;

namespace AcademicSavingService.Model
{
    public class SavingAccount
    {
        public int MaSo { get; set; }
        public int MaKH { get; set; }
        public DateTime NgayTao { get; set; }
        public DateTime? NgayDongSo { get; set; }
        public int MaKyHan { get; set; }
        public decimal SoTienBanDau { get; set; }
        public decimal SoDu { get; set; }
        public DateTime? LanCapNhatCuoi { get; set; }

        public SavingAccount(int maSo, int maKH, DateTime ngayTao, DateTime? ngayDong, 
            int maKyHan, decimal soTienBanDau, decimal soDu, DateTime? capNhatCuoi)
        {
            MaSo = maSo;
            MaKH = maKH;
            NgayTao = ngayTao;
            NgayDongSo = ngayDong;
            MaKyHan = maKyHan;
            SoTienBanDau = soTienBanDau;
            SoDu = soDu;
            LanCapNhatCuoi = capNhatCuoi;
        }

        public SavingAccount() { }
    }
}
