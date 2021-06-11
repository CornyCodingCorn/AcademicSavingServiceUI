using System;

namespace AcademicSavingService.Model
{
    public class Authorization
    {
        public int MaUQ { get; set; }
        public int MaKH { get; set; }
        public int MaSo { get; set; }
        public DateTime NgayTao { get; set; }
        public DateTime? NgayNgungSuDung { get; set; }

        public Authorization() { }

        public Authorization(int maUQ, int maKH, int maSo, DateTime ngayTao, DateTime? ngayNgungSuDung)
        {
            MaUQ = maUQ;
            MaKH = maKH;
            MaSo = maSo;
            NgayTao = ngayTao;
            NgayNgungSuDung = ngayNgungSuDung;
        }
    }
}
