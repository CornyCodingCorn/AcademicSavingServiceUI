using System;
using System.Collections.ObjectModel;
using AcademicSavingService.Commands;
using AcademicSavingService.INPC;
using AcademicSavingService.Containers;
using MySql.Data.MySqlClient;

namespace AcademicSavingService.ViewModel
{
	class CustomersManagerViewModel : CRUBPanel
	{
		public ObservableCollection<CustomerINPC> Customers { get; set; }
		public CustomerINPC SelectedCustomer
        {
			get => _selectedCustomer;
			set
            {
				_selectedCustomer = value;
				if (_selectedCustomer != null && !IsInsertMode)
				{
					MaKHField = _selectedCustomer.MaKH;
					HoTenField = _selectedCustomer.HoTen;
					CMNDField = _selectedCustomer.CMND;
					SDTField = _selectedCustomer.SDT;
					DiaChiField = _selectedCustomer.DiaChi;
					NgayDangKyField = _selectedCustomer.NgayDangKy;
				}
				else if (_selectedCustomer == null)
				{
					MaKHField = 0;
					ClearAllFields();
				}
			}
        }

		public int MaKHField { get; set; }
		public string HoTenField { get; set; }
		public string CMNDField { get; set; }
		public string SDTField { get; set; }
		public string DiaChiField { get; set; }
		public DateTime NgayDangKyField { get; set; }

		private CustomerINPC _selectedCustomer;

		public CustomersManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
		{
			Customers = CustomerContainer.Instance.Collection;
			SelectedCustomer = null;
        }

        protected override void ExecuteAdd()
        {
			CustomerINPC customer = new()
			{
				MaKH = MaKHField,
				HoTen = HoTenField,
				CMND = CMNDField,
				SDT = SDTField,
				DiaChi = DiaChiField,
				NgayDangKy = NgayDangKyField,
			};

			try
			{
				if (IsInsertMode)
                {
					CustomerContainer.Instance.AddToCollection(customer);
					ClearAllFields();
					MaKHField = CustomerContainer.Instance.GetNextAutoID();
				}
				else
					CustomerContainer.Instance.UpdateOnCollection(customer);
			}
			catch (MySqlException e) { ShowErrorMessage(e); }
		}

        protected override bool CanExecuteAdd()
        {
			return IsInsertMode || SelectedCustomer != null;
        }

        protected override void ExecuteDelete()
        {
			try
            {
				CustomerContainer.Instance.DeleteFromCollectionByDefaultKey(MaKHField);
			}
			catch (MySqlException e) { ShowErrorMessage(e); }
		}

        protected override bool CanExecuteDelete()
        {
			return !IsInsertMode && _selectedCustomer != null;
        }

        protected override void ClearAllFields()
        {
			HoTenField = null;
			CMNDField = null;
			SDTField = null;
			DiaChiField = null;
			NgayDangKyField = DateTime.Now;
        }

        protected override void ExecuteInsertMode()
        {
            base.ExecuteInsertMode();
			if (IsInsertMode)
            {
				_indexBeforeInsertMode = SelectedIndex;
				SelectedCustomer = null;
				MaKHField = CustomerContainer.Instance.GetNextAutoID();
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

		protected override void ShowErrorMessage(MySqlException exception)
		{
			string endMessage;
			switch (exception.Number)
			{
				case UserDefinedErrorNumber:
					endMessage = TranslateImplementedMessage(exception.Message);
					break;
				case CantUpdateOrDeleteCauseOfConstraintErrorNumber:
					endMessage = "One or more accounts are owned by this customer";
					break;
				default:
					endMessage = exception.Message;
					break;
			}

			ShowMessage("Warning!", endMessage);
		}
	}
}
