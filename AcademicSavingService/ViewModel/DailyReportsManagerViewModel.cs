using System;
using System.Linq;
using System.Collections.ObjectModel;
using AcademicSavingService.Containers;
using AcademicSavingService.INPC;
using MySql.Data.MySqlClient;

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
                    ChenhLech = _selectedReport.ChenhLech;

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
        public decimal ChenhLech { get; set; }

        public int SelectedTermIndex { get; set; }

        private DailyReportINPC _selectedReport;
        private DateTime _selectedDate;

        public DailyReportsManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
        {
            Reports = DailyReportContainer.Instance.Collection;
        }

        #region Private functions

        private void ResetReadOnlyFields()
        {
            TongThu = 0;
            TongChi = 0;
            ChenhLech = 0;
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
