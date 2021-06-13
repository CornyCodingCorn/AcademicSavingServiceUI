using AcademicSavingService.DataAccess;
using AcademicSavingService.Model;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AcademicSavingService.InpcContainers
{
	class DepositSlipViewModel : TransactionSlipViewModel
	{
        public static void CallLoadSlips()
        {
            _needUpdate = false;
            _stopwatch.Restart();
            var contents = _dataAccess.GetAllSlips();
            _container.Clear();
            foreach (var row in contents)
            {
                if (!Container.Contains(row))
                    Container.Add(row);
            }
        }

        public static void CreateSlips(TransactionSlipViewModel slip)
        {
            try
            {
                var result = _dataAccess.CreateSlip(slip.Model);
                slip.MaPhieu = result.MaPhieu;
                slip.NgayTao = result.NgayTao;
                slip.SoTien = result.SoTien;
            }
            catch (MySqlException e)
            {
                ShowErrorMessage(e.Message);
                return;
            }

            Container.Add(slip);
        }

        public static void DeleteSlips(int maPhieu)
        {
            try
            {
                _dataAccess.DeleteSlipByMaPhieu(maPhieu);
                for (int i = 0; i < Container.Count; i++)
                {
                    if (Container[i].MaPhieu == maPhieu)
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

        protected static readonly DepositSlipDA _dataAccess = new DepositSlipDA();
        protected static volatile bool _needUpdate = true;
        protected static readonly object _containerLock = new object();
        protected static Stopwatch _stopwatch = new Stopwatch();
        protected static ObservableCollection<TransactionSlipViewModel> _container = new ObservableCollection<TransactionSlipViewModel>();
        public static ObservableCollection<TransactionSlipViewModel> Container
        {
            get
            {
                lock (_containerLock)
                {
                    if (_stopwatch.ElapsedTicks == GlobalVars.UpdateSec * 1000)
                    {
                        CallLoadSlips();
                    }
                    return _container;
                }
            }
        }

        static DepositSlipViewModel()
        {
            _stopwatch.Start();
            CallLoadSlips();
        }
    }
}
