using System;
using System.Linq;
using System.Collections.ObjectModel;
using AcademicSavingService.Containers;
using AcademicSavingService.INPC;
using MySql.Data.MySqlClient;

namespace AcademicSavingService.ViewModel
{
    class MonthlyReportsManagerViewModel : CRUBPanel
    {
        public ObservableCollection<MonthlyReportINPC> Reports { get; set; }
        public ObservableCollection<int> Terms { get; set; }
        public MonthlyReportINPC SelectedReport
        {
            get => _selectedReport;
            set
            {
                _selectedReport = value;
                if (_selectedReport != null && !IsInsertMode)
                {
                    SelectedDate = new DateTime(_selectedReport.Nam, _selectedReport.Thang, 30);
                    SoMo = _selectedReport.SoMo;
                    SoDong = _selectedReport.SoDong;
                    ChenhLech = SoMo - SoDong;

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
                    SelectedDate = DateTime.Now;
                    ResetReadOnlyFields();
                }
            }
        }

        public DateTime SelectedDate
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
        public int SelectedTermIndex { get; set; }
        public int SoMo { get; set; }
        public int SoDong { get; set; }
        public int ChenhLech { get; set; }

        private MonthlyReportINPC _selectedReport;
        private DateTime _selectedDate;

        public MonthlyReportsManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
        {
            Reports = MonthlyReportContainer.Instance.Collection;
            SelectedDate = DateTime.Now;
        }

        private void ResetReadOnlyFields()
        {
            SoMo = 0;
            SoDong = 0;
            ChenhLech = 0;
        }

        protected override void ExecuteInsertMode()
        {
            base.ExecuteInsertMode();

            if (IsInsertMode)
            {
                SelectedDate = DateTime.Now;
                ResetReadOnlyFields();
                SelectedTermIndex = -1;
            }
            else
            {
                if (SelectedIndex != -1)
                {
                    var indexHolder = SelectedIndex;
                    SelectedIndex = -1;
                    SelectedIndex = indexHolder;
                }
                else SelectedIndex = 0;

                if (Reports.Count == 0) ResetReadOnlyFields();
            }
        }

        protected override void ExecuteAdd()
        {
            MonthlyReportINPC report = new()
            {
                Thang = SelectedDate.Month,
                Nam = SelectedDate.Year,
                KyHan = Terms[SelectedTermIndex],
            };

            try
            {
                MonthlyReportContainer.Instance.AddToCollection(report);
                Reports = MonthlyReportContainer.Instance.Collection;
            }
            catch (MySqlException e) { ShowErrorMessage(e); }
        }

        protected override void ExecuteDelete()
        {
            try
            {
                MonthlyReportContainer.Instance.DeleteByCompositeKey(SelectedDate.Month, SelectedDate.Year, Terms[SelectedTermIndex]);
            }
            catch (MySqlException e) { ShowErrorMessage(e); }
        }

        protected override bool CanExecuteAdd()
        {
            return IsInsertMode && SelectedTermIndex != -1 && SelectedTermIndex < Terms.Count;
        }

        protected override bool CanExecuteDelete()
        {
            return !IsInsertMode && SelectedReport != null && SelectedTermIndex != -1 && SelectedTermIndex < Terms.Count;
        }
    }
}
