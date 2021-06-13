using System;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using AcademicSavingService.DataAccess;
using AcademicSavingService.Model;
using AcademicSavingService.Controls;
using System.Diagnostics;
using MySql.Data.MySqlClient;

namespace AcademicSavingService.InpcContainers
{
    public class SavingAccountViewModel : BaseViewModel, IReturnModel<SavingAccount>
    {
        public SavingAccountViewModel() { }

        public SavingAccountViewModel(int maSo, int maKH, DateTime ngayTao, DateTime? ngayDongSo, int kyHan, float laiSuat,
            decimal soTienBD, decimal soDu, DateTime? capNhatCuoi)
        {
            MaSo = maSo;
            MaKH = maKH;
            NgayTao = ngayTao;
            NgayDongSo = ngayDongSo;
            KyHan = kyHan;
            LaiSuat = laiSuat;
            SoTienBanDau = soTienBD;
            SoDu = soDu;
            LanCapNhatCuoi = capNhatCuoi;
        }

        public static void CallUpdateOneAccount(int maSo, DateTime ngayUpdate)
		{
            try
			{
                var result = _dataAccess.UpdateSavingAccountStateToNgayCanUpdate(maSo, ngayUpdate);
                for (int i = 0; i < Container.Count; i++)
				{
                    if (Container[i].MaSo == maSo)
					{
                        Container[i].SoDu = result.SoDu;
                        Container[i].LanCapNhatCuoi = result.LanCapNhatCuoi;
					}
				}
			}
            catch (MySqlException e)
			{
                ShowErrorMessage(e.Message);
                return;
			}
        }

        public static void CallUpdateAllAccounts(DateTime ngayUpdate)
		{
            foreach (var account in Container)
			{
                var result = _dataAccess.UpdateSavingAccountStateToNgayCanUpdate(account.MaSo, ngayUpdate);
                account.SoDu = result.SoDu;
                account.LanCapNhatCuoi = result.LanCapNhatCuoi;
            }
        }

        public static void CallLoadSavingAccount()
		{
            _needUpdate = false;
            _stopwatch.Restart();
            var contents = _dataAccess.GetAllSavingAccounts();
            _container.Clear();
            foreach (var row in contents)
            {
                if (!Container.Contains(row))
                    Container.Add(row);
            }
        }

        public static void CreateAccount(SavingAccountViewModel account)
		{
            try
            {
                var result = _dataAccess.CreateSavingAccount(account.Model);
                account.MaSo = result.MaSo;
                account.SoTienBanDau = result.SoTienBanDau;
                account.SoDu = result.SoDu;
                account.LanCapNhatCuoi = result.LanCapNhatCuoi;
                account.NgayTao = result.NgayTao;
            }
            catch (MySqlException e)
            {
                ShowErrorMessage(e.Message);
                return;
            }

            Container.Add(account);
        }

        public static void DeleteAccount(int maSo)
		{
            try
			{
                _dataAccess.DeleteSavingAccount(maSo);
                for (int i = 0; i < Container.Count; i++)
                {
                    if (Container[i].MaSo == maSo)
                    {
                        Container.RemoveAt(i);
                        break;
                    }
                }
            }
            catch (MySqlException e)
            {
                ShowErrorMessage(e.Message);
                return;
            }
		}

        public SavingAccount Model => new(MaSo, MaKH, NgayTao, NgayDongSo, KyHan, LaiSuat, SoTienBanDau, SoDu, LanCapNhatCuoi);

        public int MaSo { get; set; }
        public int MaKH { get; set; }
        public DateTime NgayTao { get; set; }
        public DateTime? NgayDongSo { get; set; }
        public int KyHan { get; set; }
        public float LaiSuat { get; set; }
        public decimal SoTienBanDau { get; set; }
        public decimal SoDu { get; set; }
        public DateTime? LanCapNhatCuoi { get; set; }

        protected static readonly SavingAccountDA _dataAccess = new SavingAccountDA();
        protected static volatile bool _needUpdate = true;
        protected static readonly object _containerLock = new object();
        protected static Stopwatch _stopwatch = new Stopwatch();
        protected static ObservableCollection<SavingAccountViewModel> _container = new ObservableCollection<SavingAccountViewModel>();
        public static ObservableCollection<SavingAccountViewModel> Container
		{
            get 
            {
                lock(_containerLock)
				{
                    if (_stopwatch.ElapsedTicks == GlobalVars.UpdateSec * 1000)
                    {
                        CallLoadSavingAccount();
                    }
                    return _container;
                }
            }
        }
        
        static SavingAccountViewModel()
		{
            _stopwatch.Start();
            CallLoadSavingAccount();
        }
    }
}
