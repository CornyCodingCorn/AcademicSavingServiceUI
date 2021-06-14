using System;

namespace AcademicSavingService.INPC
{
    public class TransactionSlipINPC : BaseINPC
    {
        public TransactionSlipINPC(int maPhieu, DateTime ngayTao, decimal soTien, string ghiChu, int maSo)
        {
            MaPhieu = maPhieu;
            NgayTao = ngayTao;
            SoTien = soTien;
            GhiChu = ghiChu;
            MaSo = maSo;
        }

        public TransactionSlipINPC() { }

        public int MaPhieu { get; set; }
        public DateTime NgayTao { get; set; }
        public decimal SoTien { get; set; }
        public string GhiChu { get; set; }
        public int MaSo { get; set; }
    }
}
