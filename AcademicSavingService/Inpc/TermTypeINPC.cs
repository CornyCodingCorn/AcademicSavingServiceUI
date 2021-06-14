using System;

namespace AcademicSavingService.INPC
{
    public class TermTypeINPC : BaseINPC
    {
        public int MaKyHan { get; set; }
        public int KyHan { get; set; }
        public float LaiSuat { get; set; }
        public DateTime NgayTao { get; set; }
        public DateTime? NgayNgungSuDung { get; set; }

        public TermTypeINPC(int maKyHan, int kyHan, float laiSuat, DateTime ngayTao, DateTime? ngayNgungSuDung)
        {
            MaKyHan = maKyHan;
            KyHan = kyHan;
            LaiSuat = laiSuat;
            NgayTao = ngayTao;
            NgayNgungSuDung = ngayNgungSuDung;
        }

        public TermTypeINPC() { }
    }
}
