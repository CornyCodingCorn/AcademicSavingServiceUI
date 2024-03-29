﻿using System;
using System.Collections.ObjectModel;
using AcademicSavingService.INPC;
using AcademicSavingService.Containers;
using MySql.Data.MySqlClient;
using AcademicSavingService.DataAccess;
using System.Windows.Media;
using Microsoft.Win32;
using AcademicSavingService.Commands;
using System.Windows.Input;
using AcademicSavingService.Controls;
using System.IO;
using System.Collections.Generic;

namespace AcademicSavingService.ViewModel
{
	class CustomersManagerViewModel : CRUBPanel
	{
		readonly ProfileDA _profileDA = new ProfileDA();
		readonly OpenFileDialog _openFileDialog = new OpenFileDialog();

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
					ProfilePic = _profileDA.LoadImage(_selectedCustomer.AnhDaiDien);
					AnhDaiDienField = _selectedCustomer.AnhDaiDien;
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
		public ImageSource ProfilePic { get; set; }
		public string AnhDaiDienField { get; set; }

		private CustomerINPC _selectedCustomer;

		protected RelayCommand<CustomersManagerViewModel> _addImageCommand;
		protected RelayCommand<CustomersManagerViewModel> _removeImageCommand;

		public ICommand AddImageCommand => _addImageCommand ?? (_addImageCommand = new RelayCommand<CustomersManagerViewModel>(param => AddImage(), param => CanAddImage()));
		public ICommand RemoveImageCommand => _removeImageCommand ?? (_removeImageCommand = new RelayCommand<CustomersManagerViewModel>(param => RemoveImage(), param => CanRemoveImage()));

		public CustomersManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
		{
			Customers = CustomerContainer.Instance.Collection;
			SelectedCustomer = null;
			_openFileDialog.Filter = "Bitmaps|*.bmp|PNG files|*.png|JPEG files|*.jpg|GIF files|*.gif|TIFF files|*.tif|Image files|*.bmp;*.jpg;*.gif;*.png;*.tif|All files|*.*";
        }

		protected bool CanAddImage()
		{
			return (SelectedCustomer != null) && IsReadOnly;
		}

		protected void AddImage()
		{
			bool continueWithAddImage = false;
			var result = _openFileDialog.ShowDialog();
			if (result.HasValue)
			{
				continueWithAddImage = result.Value;
			}
			if (continueWithAddImage)
			{
				try
				{
					var rPath = _profileDA.AddImage(_openFileDialog.FileName, SelectedCustomer.MaKH);
					if (rPath != "")
					{
						_selectedCustomer.AnhDaiDien = rPath;
						ProfilePic = _profileDA.LoadImage(rPath);
						CustomerContainer.Instance.UpdateOnCollection(_selectedCustomer);
					}
					else
					{
						MessageBox.ShowMessage("WARNING", "Invalid file!");
					}
				}
				catch
				{
					MessageBox.ShowMessage("WARNING", "To do this you need run the program as administrator!");
				}
			}
		}

		protected bool CanRemoveImage()
		{
			return SelectedCustomer != null && (SelectedCustomer.AnhDaiDien != "") && IsReadOnly;
		}

		protected async void RemoveImage()
		{
			try
			{
				var task = AssApp.ShowConfirmDialogMessage("CONFIRMATION", "Are you sure you want to remove this image?");
				await task;
				if (task.Result)
				{
					_profileDA.RemoveImage(_selectedCustomer.AnhDaiDien);
					_selectedCustomer.AnhDaiDien = "";
					CustomerContainer.Instance.UpdateOnCollection(_selectedCustomer);
					ProfilePic = null;
				}
			}
			catch
			{
				MessageBox.ShowMessage("WARNING", "To do this you need run the program as administrator!");
			}
		}

		protected async override void ExecuteAdd()
        {
			CustomerINPC customer = new()
			{
				MaKH = MaKHField,
				HoTen = HoTenField,
				CMND = CMNDField,
				SDT = SDTField,
				DiaChi = DiaChiField,
				NgayDangKy = NgayDangKyField,
				AnhDaiDien = AnhDaiDienField
			};

			try
			{
				if (IsInsertMode)
                {
					customer.AnhDaiDien = "";
					CustomerContainer.Instance.AddToCollection(customer);
					ClearAllFields();
					MaKHField = CustomerContainer.Instance.GetNextAutoID();
				}
				else
				{
					if (AssApp.AskBeforeUpdate && !await AssApp.ShowConfirmDialogMessage("CONFIRMATION!", "Are you sure you want to update customer account?"))
						return;

					CustomerContainer.Instance.UpdateOnCollection(customer);
				}
			}
			catch (MySqlException e) { ShowErrorMessage(e); }
		}

        protected override bool CanExecuteAdd()
        {
			return IsInsertMode || SelectedCustomer != null;
        }

        protected async override void ExecuteDelete()
        {
			try
            {
				if (AssApp.AskBeforeDelete && !await AssApp.ShowConfirmDialogMessage("WARNING!", "Are you sure you want to delete customer account?"))
					return;

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

			ShowMessage("WARNING", endMessage);
		}
	}
}
