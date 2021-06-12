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
                _dataAccess.UpdateSavingAccountStateToNgayCanUpdate(maSo, ngayUpdate);
			}
            catch (MySqlException e)
			{
                ShowErrorMessage(e.Message);
			}
		}

        public static void UpdateAllAccount(DateTime ngayUpdate)
		{
            foreach (var account in Container)
                _dataAccess.UpdateSavingAccountStateToNgayCanUpdate(account.MaSo, ngayUpdate);
            CallLoadSavingAccount();
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
                _dataAccess.CreateSavingAccount(account.Model);
            }
            catch (MySqlException e)
            {
                ShowErrorMessage(e.Message);
                return;
            }
            finally
            {
                Container.Add(account);
            }
        }

        public static void DeleteAccount(int maSo)
		{
            try
			{
                _dataAccess.DeleteSavingAccount(maSo);
            }
            catch (MySqlException e)
            {
                ShowErrorMessage(e.Message);
                return;
            }
            finally
			{
                for (int i = 0; i < Container.Count; i ++)
				{
                    if (Container[i].MaSo == maSo)
					{
                        Container.RemoveAt(i);
                        break;
                    }
				}
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
