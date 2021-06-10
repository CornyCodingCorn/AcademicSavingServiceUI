using System;
using AcademicSavingService.Model;

namespace AcademicSavingService.InpcContainers
{
    public class TransactionSlipViewModel : BaseINPC
    {
        private TransactionSlip _slip;

        public TransactionSlipViewModel() { }

        public TransactionSlipViewModel(TransactionSlip slip)
        {
            _slip = slip;
        }

        public int MaPhieu
        {
            get => _slip.MaPhieu;
            set
            {
                _slip.MaPhieu = value;
                RaisePropertyChanged(nameof(MaPhieu));
            }
        }

        public DateTime NgayTao
        {
            get => _slip.NgayTao;
            set
            {
                _slip.NgayTao = value;
                RaisePropertyChanged(nameof(NgayTao));
            }
        }

        public decimal SoTien
        {
            get => _slip.SoTien;
            set
            {
                _slip.SoTien = value;
                RaisePropertyChanged(nameof(SoTien));
            }
        }

        public string GhiChu
        {
            get => _slip.GhiChu;
            set
            {
                _slip.GhiChu = value;
                RaisePropertyChanged(nameof(GhiChu));
            }
        }

        public int MaSo
        {
            get => _slip.MaSo;
            set
            {
                _slip.MaSo = value;
                RaisePropertyChanged(nameof(MaSo));
            }
        }

        public int MaKH
        {
            get => _slip.MaKH;
            set
            {
                _slip.MaKH = value;
                RaisePropertyChanged(nameof(MaKH));
            }
        }

        public int MaNV
        {
            get => _slip.MaNV;
            set
            {
                _slip.MaNV = value;
                RaisePropertyChanged(nameof(MaNV));
            }
        }

        public int MaUQ
        {
            get => _slip.MaUQ;
            set
            {
                _slip.MaUQ = value;
                RaisePropertyChanged(nameof(MaUQ));
            }
        }
    }
}
