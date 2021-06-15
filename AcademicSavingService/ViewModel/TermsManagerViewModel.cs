using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using AcademicSavingService.INPC;
using AcademicSavingService.Containers;
using MySql.Data.MySqlClient;

namespace AcademicSavingService.ViewModel
{
	class TermsManagerViewModel : CRUBPanel
	{
		public ObservableCollection<TermTypeINPC> Terms { get; set; }
        public TermTypeINPC SelectedTerm
        {
            get => _selectedTerm;
            set
            {
                _selectedTerm = value;
                if (_selectedTerm != null)
                {
                    MaKyHanField = _selectedTerm.MaKyHan;
                    KyHanField = _selectedTerm.KyHan;
                    LaiSuatField = _selectedTerm.LaiSuat;
                    NgayTaoField = _selectedTerm.NgayTao;
                    NgayNgungSuDungField = _selectedTerm.NgayNgungSuDung;
                }
                else
                {
                    MaKyHanField = 0;
                    ClearAllField();
                }
            }
        }

        public int MaKyHanField { get; set; }
        public int KyHanField { get; set; }
        public float LaiSuatField { get; set; }
        public DateTime NgayTaoField { get; set; }
        public DateTime? NgayNgungSuDungField { get; set; }

        public int SelectedIndex { get; set; }

        private TermTypeINPC _selectedTerm;

        public TermsManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
        {
            Terms = TermTypeContainer.Instance.Collection;
        }

        protected override void ClearAllField()
        {
            KyHanField = 0;
            LaiSuatField = 0;
            NgayTaoField = DateTime.Now;
            NgayNgungSuDungField = null;
        }

        protected override void ExecuteAdd()
        {
            TermTypeINPC term = new()
            {
                MaKyHan = MaKyHanField,
                KyHan = KyHanField,
                LaiSuat = LaiSuatField,
                NgayTao = NgayTaoField,
                NgayNgungSuDung = NgayNgungSuDungField,
            };
            try
            {
                TermTypeContainer.Instance.AddToCollection(term);
            } 
            catch (MySqlException e) { ShowErrorMessage(e); }
        }

        protected override bool CanExecuteAdd()
        {
            return KyHanField > 0 && LaiSuatField > 0 && NgayTaoField.Date == DateTime.Now.Date
                && (NgayNgungSuDungField == null || NgayNgungSuDungField >= NgayTaoField);
        }

        protected override void ExecuteDelete()
        {
            try
            {
                TermTypeContainer.Instance.DeleteFromCollectionByDefaultKey(MaKyHanField);
            }
            catch (MySqlException e) { ShowErrorMessage(e); }
        }

        protected override bool CanExecuteDelete()
        {
            return SelectedTerm != null;
        }

        protected override void ExecuteInsertMode()
        {
            base.ExecuteInsertMode();
            if (IsInsertMode)
            {
                _indexBeforeInsertMode = SelectedIndex;
                SelectedTerm = null;
                MaKyHanField = TermTypeContainer.Instance.GetNextAutoID();
            }
            else
            {
                SelectedIndex = _indexBeforeInsertMode;
            }
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

            ShowMessage("Warning!", endMessage);
        }
    }
}
