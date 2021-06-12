using System;

namespace AcademicSavingService.Model
{
    public class SavingAccount
    {
        public int MaSo { get; set; }
        public int MaKH { get; set; }
        public DateTime NgayTao { get; set; }
        public DateTime? NgayDongSo { get; set; }
        public int KyHan { get; set; }
        public float LaiSuat { get; set; }
        public decimal SoTienBanDau { get; set; }
        public decimal SoDu { get; set; }
        public DateTime? LanCapNhatCuoi { get; set; }

        public SavingAccount(int maSo, int maKH, DateTime ngayTao, DateTime? ngayDong, int kyHan, float laiSuat, 
            decimal soTienBanDau, decimal soDu, DateTime? capNhatCuoi)
        {
            MaSo = maSo;
            MaKH = maKH;
            NgayTao = ngayTao;
            NgayDongSo = ngayDong;
            KyHan = kyHan;
            LaiSuat = laiSuat;
            SoTienBanDau = soTienBanDau;
            SoDu = soDu;
            LanCapNhatCuoi = capNhatCuoi;
        }

        public SavingAccount() { }
    }
}
