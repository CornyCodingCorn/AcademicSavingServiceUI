using System;
using AcademicSavingService.Model;

namespace AcademicSavingService.InpcContainers
{
    public class SavingAccountViewModel : BaseINPC
    {
        private SavingAccount _account;

        public SavingAccountViewModel() { _account = new(); }

        public SavingAccountViewModel(SavingAccount account)
        {
            this._account = account;
        }

        public int MaSo
        {
            get => _account.MaSo;
            set
            {
                _account.MaSo = value;
                RaisePropertyChanged(nameof(MaSo));
            }
        }

        public int MaKH
        {
            get => _account.MaKH;
            set
            {
                _account.MaKH = value;
                RaisePropertyChanged(nameof(MaKH));
            }
        }

        public DateTime NgayTao
        {
            get => _account.NgayTao;
            set
            {
                _account.NgayTao = value;
                RaisePropertyChanged(nameof(NgayTao));
            }
        }

        public DateTime? NgayDongSo
        {
            get => _account.NgayDongSo;
            set
            {
                _account.NgayDongSo = value;
                RaisePropertyChanged(nameof(NgayDongSo));
            }
        }

        public int MaKyHan
        {
            get => _account.MaKyHan;
            set
            {
                _account.MaKyHan = value;
                RaisePropertyChanged(nameof(MaKyHan));
            }
        }

        public decimal SoTienBanDau
        {
            get => _account.SoTienBanDau;
            set
            {
                _account.SoTienBanDau = value;
                RaisePropertyChanged(nameof(SoTienBanDau));
            }
        }

        public decimal SoDu
        {
            get => _account.SoDu;
            set
            {
                _account.SoDu = value;
                RaisePropertyChanged(nameof(SoDu));
            }
        }

        public DateTime? LanCapNhatCuoi
        {
            get => _account.LanCapNhatCuoi;
            set
            {
                _account.LanCapNhatCuoi = value;
                RaisePropertyChanged(nameof(LanCapNhatCuoi));
            }
        }
    }
}
