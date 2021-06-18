using System;
using System.Windows.Input;
using System.Collections.ObjectModel;
using MySql.Data.MySqlClient;
using AcademicSavingService.INPC;
using AcademicSavingService.Commands;
using AcademicSavingService.Containers;

namespace AcademicSavingService.ViewModel
{
    class RuleManagerViewModel : ErrorDisplayer
    {
        public RuleINPC CurrentRule { get; set; }
        public ObservableCollection<RuleINPC> History { get; set; }

        public string SoTienNapToiThieuText { get; set; }
        public string SoTienMoTaiKhoanToiThieuText { get; set; }
        public string SoNgayToiThieuText { get; set; }
        public DateTime NgayCapNhat { get; set; }

        public ICommand UpdateCommand => _updateCommand ??= new RelayCommand<RuleINPC>(param => UpdateRule(), param => CanUpdateRule());

        private RelayCommand<RuleINPC> _updateCommand;

        public RuleManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
        {
            CurrentRule = RuleContainer.Instance.GetLatestRule();
            History = RuleContainer.Instance.Collection;
            UpdateFields();
        }

        private void UpdateRule()
        {
            if (!decimal.TryParse(SoTienNapToiThieuText, out decimal soTienNap)
                    || !decimal.TryParse(SoTienMoTaiKhoanToiThieuText, out decimal soTienMoTaiKhoan)
                    || !int.TryParse(SoNgayToiThieuText, out int soNgay))
            {
                ShowMessage("WARNING", "Minimum deposit amount and minimum initial balance to open account must be decimal values. " +
                    "Minimum days to withdraw must be an integer value");
                return;
            }
            else if (soTienNap < 0 || soTienMoTaiKhoan < 0 || soNgay < 0)
            {
                ShowMessage("WARNING", "All values must be greater than 0");
                return;
            }
            else if (soTienNap == CurrentRule.SoTienNapNhoNhat 
                && soTienMoTaiKhoan == CurrentRule.SoTienMoTaiKhoanNhoNhat 
                && soNgay == CurrentRule.SoNgayToiThieu)
            {
                ShowMessage("WARNING", "You should make changes to the current rules before trying to update them");
                return;
            }

            RuleINPC newRule = new()
            {
                SoTienNapNhoNhat = decimal.Parse(SoTienNapToiThieuText),
                SoTienMoTaiKhoanNhoNhat = decimal.Parse(SoTienMoTaiKhoanToiThieuText),
                SoNgayToiThieu = int.Parse(SoNgayToiThieuText),
                NgayTao = DateTime.Now,
            };

            try
            {
                RuleContainer.Instance.AddToCollection(newRule);
                CurrentRule = newRule;
                UpdateFields();
            }
            catch (MySqlException e) { ShowErrorMessage(e); }
        }

        private bool CanUpdateRule()
        {
            return !(string.IsNullOrWhiteSpace(SoTienNapToiThieuText)
                || string.IsNullOrWhiteSpace(SoTienMoTaiKhoanToiThieuText)
                || string.IsNullOrWhiteSpace(SoNgayToiThieuText));
        }

        private void UpdateFields()
        {
            SoTienNapToiThieuText = CurrentRule.SoTienNapNhoNhat.ToString();
            SoTienMoTaiKhoanToiThieuText = CurrentRule.SoTienMoTaiKhoanNhoNhat.ToString();
            SoNgayToiThieuText = CurrentRule.SoNgayToiThieu.ToString();
            NgayCapNhat = CurrentRule.NgayTao;
        }

        protected override void ShowErrorMessage(MySqlException exception)
        {
            string endMessage;
            switch (exception.Number)
            {
                case UserDefinedErrorNumber:
                    endMessage = TranslateImplementedMessage(exception.Message);
                    break;
                default:
                    endMessage = exception.Message;
                    break;
            }

            ShowMessage("WARNING", endMessage);
        }
    }
}
