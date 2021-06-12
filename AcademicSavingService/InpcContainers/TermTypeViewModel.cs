using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using AcademicSavingService.DataAccess;
using AcademicSavingService.Model;

namespace AcademicSavingService.InpcContainers
{
    public class TermTypeViewModel : BaseViewModel, IReturnModel<TermType>
    {
        public TermTypeViewModel() { }

        public TermTypeViewModel(int maKyhan, int kyHan, float laiSuat, DateTime ngayTao, DateTime? ngayNgungSuDung)
        {
            MaKyHan = maKyhan;
            KyHan = kyHan;
            LaiSuat = laiSuat;
            NgayTao = ngayTao;
            NgayNgungSuDung = ngayNgungSuDung;
        }

        public static ObservableCollection<KeyValuePair<int, float>> GetTermWithDate(DateTime date)
		{
            return _dataAccess.GetClosetTermAndInterestToDate(date);
		}

        public TermType Model => new(MaKyHan, KyHan, LaiSuat, NgayTao, NgayNgungSuDung);

        public int MaKyHan { get; set; }
        public int KyHan { get; set; }
        public float LaiSuat { get; set; }
        public DateTime NgayTao { get; set; }
        public DateTime? NgayNgungSuDung { get; set; }

        protected static readonly TermTypeDA _dataAccess = new TermTypeDA();
        protected static volatile bool _needUpdate = true;
        protected static readonly object _containerLock = new object();
        protected static Stopwatch _stopwatch = new Stopwatch();
        protected static ObservableCollection<SavingAccountViewModel> _container = new ObservableCollection<SavingAccountViewModel>();
        public static ObservableCollection<SavingAccountViewModel> Container
        {
            get
            {
                lock (_containerLock)
                {
                    if (_stopwatch.ElapsedTicks == GlobalVars.UpdateSec * 1000)
                    {

                    }
                    return _container;
                }
            }
        }
    }
}
