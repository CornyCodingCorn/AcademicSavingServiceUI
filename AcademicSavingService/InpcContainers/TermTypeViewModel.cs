using System;
using AcademicSavingService.Model;

namespace AcademicSavingService.InpcContainers
{
    public class TermTypeViewModel : BaseViewModel, IReturnModel<TermType>
    {
        public TermTypeViewModel() { }

        public TermTypeViewModel(int maKyhan, int kyHan, float laiSuat, DateTime ngayTao, DateTime? ngayNgungSuDung)
        {
            MaKyHan = maKyhan;
            KyHan = kyHan;
            LaiSuat = laiSuat;
            NgayTao = ngayTao;
            NgayNgungSuDung = ngayNgungSuDung;
        }

        public TermType Model => new(MaKyHan, KyHan, LaiSuat, NgayTao, NgayNgungSuDung);

        public int MaKyHan { get; set; }
        public int KyHan { get; set; }
        public float LaiSuat { get; set; }
        public DateTime NgayTao { get; set; }
        public DateTime? NgayNgungSuDung { get; set; }
    }
}
