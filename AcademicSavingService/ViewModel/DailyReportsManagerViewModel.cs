using System;
using System.Linq;
using System.Windows.Input;
using MySql.Data.MySqlClient;
using Microsoft.Win32;
using System.Collections.ObjectModel;
using AcademicSavingService.Containers;
using AcademicSavingService.INPC;
using AcademicSavingService.Commands;
using AcademicSavingService.Helpers;

namespace AcademicSavingService.ViewModel
{
    class DailyReportsManagerViewModel : CRUBPanel
    {
        public ObservableCollection<DailyReportINPC> Reports { get; set; }
        public ObservableCollection<int> Terms { get; set; }
        public DailyReportINPC SelectedReport
        {
            get => _selectedReport;
            set
            {
                _selectedReport = value;
                if (_selectedReport != null && !IsInsertMode)
                {
                    Ngay = _selectedReport.Ngay;
                    TongThu = _selectedReport.TongThu;
                    TongChi = _selectedReport.TongChi;
                    ChenhLechAbs = _selectedReport.ChenhLechAbs;

                    for (int i = 0; i < Terms.Count; i++)
                    {
                        if (Terms[i] == _selectedReport.KyHan)
                        {
                            SelectedTermIndex = i;
                            break;
                        }
                    }
                }
                else if (_selectedReport == null)
                {
                    Ngay = DateTime.Now;
                    ResetReadOnlyFields();
                }
            }
        }

        public DateTime Ngay
        {
            get => _selectedDate;
            set
            {
                _selectedDate = value;
                var collection = TermTypeContainer.Instance.GetClosestTermAndInterestToDate(_selectedDate)
                                                            .Select(item => item.Key);
                Terms = new ObservableCollection<int>(collection);
            }
        }

        public decimal TongThu { get; set; }
        public decimal TongChi { get; set; }
        public decimal ChenhLechAbs { get; set; }
        public int SelectedTermIndex { get; set; }
        public ICommand ExportCommand => _exportCommand ??= new RelayCommand<DailyReportINPC>(param => ExportReportsToCSVFile(), param => true);

        private DailyReportINPC _selectedReport;
        private DateTime _selectedDate;
        private RelayCommand<DailyReportINPC> _exportCommand;

        public DailyReportsManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
        {
            Reports = DailyReportContainer.Instance.Collection;
        }

        #region Private functions

        private void ResetReadOnlyFields()
        {
            TongThu = 0;
            TongChi = 0;
            ChenhLechAbs = 0;
        }

        private void ExportReportsToCSVFile()
        {
            SaveFileDialog saveDialog = new();
            saveDialog.Title = "Export to CSV file";
            saveDialog.FileName = $"daily-reports-generated-{DateTime.Now.Day.ToString("0#") + DateTime.Now.Month.ToString("0#") + DateTime.Now.Year}";
            saveDialog.DefaultExt = ".csv";
            saveDialog.Filter = "CSV file (.csv)|*.csv";

            bool? result = saveDialog.ShowDialog();

            if (result == true)
            {
                ExportToCSVHelper.GenerateCSVFileForDailyReports(Reports, saveDialog.FileName);
            }
        }

        #endregion

        #region Execute

        protected override void ExecuteInsertMode()
        {
            base.ExecuteInsertMode();
            if (IsInsertMode)
            {
                Ngay = DateTime.Now;
                SelectedTermIndex = -1;
                ResetReadOnlyFields();
            }
            else
            {
                if (SelectedIndex != -1)
                {
                    var indexHolder = SelectedIndex;
                    SelectedIndex = -1;
                    SelectedIndex = indexHolder;
                }
                else SelectedIndex = Reports.Count - 1;
            }
        }

        protected override void ExecuteAdd()
        {
            var newReport = new DailyReportINPC()
            {
                Ngay = Ngay,
                KyHan = Terms[SelectedTermIndex],
            };

            try
            {
                DailyReportContainer.Instance.AddToCollection(newReport);
                Reports = DailyReportContainer.Instance.Collection;
            }
            catch (MySqlException e) { ShowErrorMessage(e); }
        }

        protected override void ExecuteDelete()
        {
            try
            {
                DailyReportContainer.Instance.DeleteByCompositeKey(Ngay, Terms[SelectedTermIndex]);
            }
            catch (MySqlException e) { ShowErrorMessage(e); }
        }

        #endregion

        #region Can Execute

        protected override bool CanExecuteAdd()
        {
            return IsInsertMode && SelectedTermIndex != -1 && SelectedTermIndex < Terms.Count;
        }

        protected override bool CanExecuteDelete()
        {
            return !IsInsertMode && SelectedReport != null && SelectedTermIndex != -1 && SelectedTermIndex < Terms.Count;
        }

        #endregion
    }
}
