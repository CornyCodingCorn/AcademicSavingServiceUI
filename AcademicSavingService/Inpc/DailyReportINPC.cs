using System;

namespace AcademicSavingService.INPC
{
    public class DailyReportINPC : BaseINPC
    {
        public DateTime Ngay { get; set; }
        public int KyHan { get; set; }
        public decimal TongThu { get; set; }
        public decimal TongChi { get; set; }
        public decimal ChenhLech { get; set; }

        public DailyReportINPC() { }

        public DailyReportINPC(DateTime ngay, int kyHan, decimal tongThu, decimal tongChi)
        {
            Ngay = ngay;
            KyHan = kyHan;
            TongThu = tongThu;
            TongChi = tongChi;
            ChenhLech = Math.Abs(TongThu - TongChi);
        }
    }
}
