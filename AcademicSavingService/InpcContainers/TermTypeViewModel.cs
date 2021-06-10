using System;
using AcademicSavingService.Model;

namespace AcademicSavingService.InpcContainers
{
    public class TermTypeViewModel : BaseINPC
    {
        private TermType _term;

        public int MaKyHan
        {
            get => _term.MaKyHan;
            set
            {
                _term.MaKyHan = value;
                RaisePropertyChanged(nameof(MaKyHan));
            }
        }

        public int KyHan
        {
            get => _term.KyHan;
            set
            {
                _term.KyHan = value;
                RaisePropertyChanged(nameof(KyHan));
            }
        }

        public float LaiSuat
        {
            get => _term.LaiSuat;
            set
            {
                _term.LaiSuat = value;
                RaisePropertyChanged(nameof(LaiSuat));
            }
        }

        public DateTime NgayTao
        {
            get => _term.NgayTao;
            set
            {
                _term.NgayTao = value;
                RaisePropertyChanged(nameof(NgayTao));
            }
        }

        public DateTime NgayNgungSuDung
        {
            get => _term.NgayNgungSuDung;
            set
            {
                _term.NgayNgungSuDung = value;
                RaisePropertyChanged(nameof(NgayNgungSuDung));
            }
        }

        public TermTypeViewModel()
        {
            _term = new();
        }
    }
}
