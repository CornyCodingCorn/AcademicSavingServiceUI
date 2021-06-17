using System;
using System.Collections.ObjectModel;
using System.Windows.Input;
using System.Linq;
using MySql.Data.MySqlClient;
using AcademicSavingService.INPC;
using AcademicSavingService.Containers;
using AcademicSavingService.Commands;

namespace AcademicSavingService.ViewModel
{
	class TermsManagerViewModel : CRUBPanel
	{
		public ObservableCollection<TermTypeINPC> ActiveTerms { get; set; }
		public ObservableCollection<TermTypeINPC> PastTerms { get; set; }
        public TermTypeINPC SelectedTerm
        {
            get => _selectedTerm;
            set
            {
                _selectedTerm = value;
                if (_selectedTerm != null && !IsInsertMode)
                {
                    MaKyHanField = _selectedTerm.MaKyHan;
                    KyHanField = _selectedTerm.KyHan;
                    LaiSuatField = _selectedTerm.LaiSuat;
                    NgayTaoField = _selectedTerm.NgayTao;
                    NgayNgungSuDungField = _selectedTerm.NgayNgungSuDung;
                }
                else if (_selectedTerm == null)
                {
                    MaKyHanField = 0;
                    ClearAllFields();
                }
            }
        }

        public int MaKyHanField { get; set; }
        public int KyHanField { get; set; }
        public float LaiSuatField { get; set; }
        public DateTime NgayTaoField { get; set; }
        public DateTime? NgayNgungSuDungField { get; set; }

        public ICommand DisableTermCommand => _disableTermCommand ?? (_disableTermCommand = new RelayCommand<TermTypeINPC>(param => ExecuteDisableTerm(), param => CanDisableTerm()));

        private TermTypeINPC _selectedTerm;
        private RelayCommand<TermTypeINPC> _disableTermCommand;
        private int _indexBeforeSave = -1;

        public TermsManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
        {
            UpdateCollections();
            SelectedTerm = null;
        }

        // Updates the active terms and past terms collections to latest from TermTypeContainer collection
        private void UpdateCollections()
        {
            ActiveTerms = TermTypeContainer.Instance.GetCurrentlyActiveTerms();
            PastTerms = new ObservableCollection<TermTypeINPC>(TermTypeContainer.Instance.Collection.Except(ActiveTerms));
        }

        private void PrepareForInsert()
        {
            _indexBeforeInsertMode = SelectedIndex;
            SelectedTerm = null;
            MaKyHanField = TermTypeContainer.Instance.GetNextAutoID();
        }

        #region Execute overrides

        protected override void ClearAllFields()
        {
            KyHanField = 0;
            LaiSuatField = 0;
            NgayTaoField = DateTime.Now;
            NgayNgungSuDungField = null;
        }

        private void ExecuteDisableTerm()
        {
            try
            {
                if (KyHanField == 0)
                {
                    ShowMessage("Warning!", "You cannot disable non-period term");
                    return;
                }

                TermTypeContainer.Instance.DisableTerm(new TermTypeINPC() { MaKyHan = MaKyHanField, KyHan = KyHanField },
                    NgayNgungSuDungField ?? DateTime.Now);
                UpdateCollections();
            }
            catch (MySqlException e) { ShowErrorMessage(e); }
        }

        protected override void ExecuteAdd()
        {
            if (SelectedTerm != null
                && MaKyHanField == SelectedTerm.MaKyHan 
                && KyHanField == SelectedTerm.KyHan 
                && LaiSuatField == SelectedTerm.LaiSuat 
                && NgayTaoField == SelectedTerm.NgayTao
                && NgayNgungSuDungField == SelectedTerm.NgayNgungSuDung)
            {
                ShowMessage("Warning!", "You should make changes to term's values before trying to update it");
                return;
            }

            TermTypeINPC term = new()
            {
                MaKyHan = TermTypeContainer.Instance.GetNextAutoID(),
                KyHan = KyHanField,
                LaiSuat = LaiSuatField,
                NgayTao = NgayTaoField,
                NgayNgungSuDung = NgayNgungSuDungField,
            };

            if (!IsInsertMode) _indexBeforeSave = SelectedIndex;

            try
            {
                var currentTerm = ActiveTerms.SingleOrDefault(item => item.KyHan == KyHanField);
                if (currentTerm != null)
                {
                    //TODO: PROMPT USER FOR CONFIRMATION 
                    //

                    TermTypeContainer.Instance.DisableTerm(currentTerm, term.NgayTao);
                }
                TermTypeContainer.Instance.AddToCollection(term);
                UpdateCollections();

                if (IsInsertMode)
                {
                    ClearAllFields();
                    MaKyHanField = TermTypeContainer.Instance.GetNextAutoID();
                }
                else
                {
                    SelectedIndex = _indexBeforeSave;
                }
            }
            catch (MySqlException e) { ShowErrorMessage(e); }
        }

        protected override void ExecuteDelete()
        {
            try
            {
                TermTypeContainer.Instance.DeleteFromCollectionByDefaultKey(MaKyHanField);
            }
            catch (MySqlException e) { ShowErrorMessage(e); }
        }

        protected override void ExecuteInsertMode()
        {
            base.ExecuteInsertMode();
            if (IsInsertMode)
            {
                PrepareForInsert();
            }
            else
            {
                if (SelectedIndex != -1)
                {
                    var indexHolder = SelectedIndex;
                    SelectedIndex = -1;
                    SelectedIndex = indexHolder;
                }
                else SelectedIndex = _indexBeforeInsertMode;
            }
        }

        #endregion


        #region Can execute overrides

        private bool CanDisableTerm()
        {
            return !IsInsertMode && SelectedTerm != null;
        }

        protected override bool CanExecuteAdd()
        {
            return KyHanField >= 0 && LaiSuatField > 0 && (NgayNgungSuDungField == null || NgayNgungSuDungField >= NgayTaoField);
        }

        protected override bool CanExecuteDelete()
        {
            return SelectedTerm != null;
        }

        #endregion

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
