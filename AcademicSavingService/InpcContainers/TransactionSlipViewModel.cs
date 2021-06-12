using System;
using AcademicSavingService.Model;

namespace AcademicSavingService.InpcContainers
{
    public class TransactionSlipViewModel : BaseViewModel, IReturnModel<TransactionSlip>
    {
        public TransactionSlipViewModel() { }

        public TransactionSlipViewModel(int maPhieu, DateTime ngayTao, decimal soTien, string ghiChu, int maSo, int maKH, int maNV)
        {
            MaPhieu = maPhieu;
            NgayTao = ngayTao;
            SoTien = soTien;
            GhiChu = ghiChu;
            MaSo = maSo;
            MaKH = maKH;
            MaNV = maNV;
        }

        public TransactionSlip Model => new(MaPhieu, NgayTao, SoTien, GhiChu, MaSo, MaKH, MaNV);

        public int MaPhieu { get; set; }
        public DateTime NgayTao { get; set; }
        public decimal SoTien { get; set; }
        public string GhiChu { get; set; }
        public int MaSo { get; set; }
        public int MaKH { get; set; }
        public int MaNV { get; set; }


    }
}
