using System;

namespace AcademicSavingService.INPC
{
    public class RuleINPC : BaseINPC
    {
        public int MaQD { get; set; }
        public decimal SoTienNapNhoNhat { get; set; }
        public decimal SoTienMoTaiKhoanNhoNhat { get; set; }
        public int SoNgayToiThieu { get; set; }
        public DateTime NgayTao { get; set; }

        public RuleINPC() { }
        public RuleINPC(int maQD, decimal soTienNapMin, decimal soTienMoTaiKhoanMin, int soNgayMin, DateTime ngayTao)
        {
            MaQD = maQD;
            SoTienNapNhoNhat = soTienNapMin;
            SoTienMoTaiKhoanNhoNhat = soTienMoTaiKhoanMin;
            SoNgayToiThieu = soNgayMin;
            NgayTao = ngayTao;
        }
    }
}
