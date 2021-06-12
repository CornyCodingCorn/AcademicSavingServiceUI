using System;
using AcademicSavingService.Model;

namespace AcademicSavingService.InpcContainers
{
    public class SavingAccountViewModel : BaseViewModel, IReturnModel<SavingAccount>
    {
        public SavingAccountViewModel() { }

        public SavingAccountViewModel(int maSo, int maKH, DateTime ngayTao, DateTime? ngayDongSo, int kyHan, float laiSuat,
            decimal soTienBD, decimal soDu, DateTime? capNhatCuoi)
        {
            MaSo = maSo;
            MaKH = maKH;
            NgayTao = ngayTao;
            NgayDongSo = ngayDongSo;
            KyHan = kyHan;
            LaiSuat = laiSuat;
            SoTienBanDau = soTienBD;
            SoDu = soDu;
            LanCapNhatCuoi = capNhatCuoi;
        }

        public SavingAccount Model => new(MaSo, MaKH, NgayTao, NgayDongSo, KyHan, LaiSuat, SoTienBanDau, SoDu, LanCapNhatCuoi);

        public int MaSo { get; set; }
        public int MaKH { get; set; }
        public DateTime NgayTao { get; set; }
        public DateTime? NgayDongSo { get; set; }
        public int KyHan { get; set; }
        public float LaiSuat { get; set; }
        public decimal SoTienBanDau { get; set; }
        public decimal SoDu { get; set; }
        public DateTime? LanCapNhatCuoi { get; set; }
    }
}
