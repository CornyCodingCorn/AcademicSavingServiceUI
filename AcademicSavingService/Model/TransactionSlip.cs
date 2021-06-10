using System;

namespace AcademicSavingService.Model
{
    public class TransactionSlip
    {
        public TransactionSlip(int maPhieu, DateTime ngayTao, decimal soTien, string ghiChu, int maSo, int maKH, int maNV, int maUQ)
        {
            MaPhieu = maPhieu;
            NgayTao = ngayTao;
            SoTien = soTien;
            GhiChu = ghiChu;
            MaSo = maSo;
            MaKH = maKH;
            MaNV = maNV;
            MaUQ = maUQ;
        }

        public TransactionSlip() { }


        public int MaPhieu { get; set; }

        public DateTime NgayTao { get; set; }

        public decimal SoTien { get; set; }

        public string GhiChu { get; set; }

        public int MaSo { get; set; }

        public int MaKH { get; set; }

        public int MaNV { get; set; }

        public int MaUQ { get; set; }
    }
}
