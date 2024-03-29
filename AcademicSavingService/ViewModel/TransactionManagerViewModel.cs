﻿using AcademicSavingService.Commands;
using AcademicSavingService.Containers;
using AcademicSavingService.INPC;
using MySql.Data.MySqlClient;
using PropertyChanged;
using System;
using System.Collections.ObjectModel;
using System.Windows.Input;
using MahApps.Metro.Controls.Dialogs;
using System.Threading.Tasks;
using AcademicSavingService.Controls;

namespace AcademicSavingService.ViewModel
{
	[AddINotifyPropertyChangedInterface]
	abstract class TransactionManagerViewModel : CRUBPanel
	{
		protected TransactionSlipContainer _containerInstance;
		public TransactionManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
		{
			SavingAccounts = SavingAccountContainer.Instance.Collection;
			CreateDate = DateTime.Now;
		}

		#region Insert fields
		public int ID { get; set; }
		public int CustomerID { get; set; }
		public DateTime CreateDate { get; set; }
		public decimal Amount { get; set; }
		public string Note { get; set; }

		public int AccountID { get; set; }
		public int OwnerID { get; set; }
		public decimal Balance { get; set; }
		public DateTime? LastUpdate { get; set; }
		#endregion

		#region Accounts
		public ObservableCollection<SavingAccountINPC> SavingAccounts { get; set; }

		protected SavingAccountINPC _selectedAccount;
		public SavingAccountINPC SelectedAccount
		{
			get
			{
				return _selectedAccount;
			}
			set
			{
				_selectedAccount = value;
				if (_selectedAccount == null)
                {
					AccountID = 0;
					OwnerID = 0;
					Balance = 0;
					LastUpdate = null;
				}
				else
                {
					AccountID = _selectedAccount.MaSo;
					OwnerID = _selectedAccount.MaKH;
					Balance = _selectedAccount.SoDu;
					LastUpdate = _selectedAccount.LanCapNhatCuoi;
				}
			}
		}
		#endregion

		#region Slips
		public ObservableCollection<TransactionSlipINPC> Slips { get; set; }

		protected TransactionSlipINPC _selectedSlip;
		public TransactionSlipINPC SelectedSlip
		{
			get { return _selectedSlip; }
			set
			{
				_selectedSlip = value;
				if (_selectedSlip is null)
                {
					ID = 0;
					CreateDate = DateTime.Now;
					Amount = 0;
					Note = null;
					SelectedAccount = null;
				}
				else if (!IsInsertMode)
                {
					ID = _selectedSlip.MaPhieu;
					CreateDate = _selectedSlip.NgayTao;
					Amount = _selectedSlip.SoTien;
					Note = _selectedSlip.GhiChu;

					for (int i = 0; i < SavingAccounts.Count; i++)
					{
						if (SavingAccounts[i].MaSo == _selectedSlip.MaSo)
						{
							SelectedAccount = SavingAccounts[i];
							break;
						}
					}
				}
			}
		}
		#endregion

		public int SelectedAccountIndex { get; set; }

		#region Execution
		protected RelayCommand<TransactionManagerViewModel> _updateCommand;
		public ICommand UpdateCommand => _updateCommand ?? (_updateCommand = new RelayCommand<TransactionManagerViewModel>(param => ExecuteUpdate(), param => CanExecuteUpdate()));

		protected override void ExecuteInsertMode()
		{
			base.ExecuteInsertMode();
			if (IsInsertMode)
			{
				_indexBeforeInsertMode = SelectedIndex;
				SelectedSlip = null;
				ClearAllFields();
				ID = _containerInstance.GetNextAutoID();
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

		protected async override void ExecuteAdd()
		{
			try
			{
				var slip = new TransactionSlipINPC(ID, CreateDate, Amount, Note, AccountID);
				if (IsInsertMode)
				{
					_containerInstance.AddToCollection(slip);
					ID = _containerInstance.GetNextAutoID();
					SavingAccountContainer.Instance.UpdateSavingAccount(AccountID);
				}
				else
				{
					if (AssApp.AskBeforeUpdate && !await AssApp.ShowConfirmDialogMessage("CONFIRMATION!", "Are you sure you want to update this slip?"))
						return;
					var accountIndex = SelectedAccountIndex;
					_containerInstance.UpdateOnCollection(slip);
					SavingAccountContainer.Instance.UpdateSavingAccount(AccountID);
					SelectedAccountIndex = accountIndex;
				}
			}
			catch(MySqlException e)
			{ ShowErrorMessage(e); }
		}

		protected virtual void ExecuteUpdate()
		{
			try
			{
				_containerInstance.UpdateOnCollection(new TransactionSlipINPC(ID, CreateDate, Amount, Note, AccountID));
				SavingAccountContainer.Instance.UpdateSavingAccount(AccountID);
			}
			catch(MySqlException e)
			{ ShowErrorMessage(e); }
		}

		protected async override void ExecuteDelete()
		{
			try
			{
				if (AssApp.AskBeforeDelete && !await AssApp.ShowConfirmDialogMessage($"WARNING!", "Are you sure you want to delete this slip?"))
					return;

				var accountID = AccountID;
				var index = SelectedIndex;
				_containerInstance.DeleteFromCollectionByDefaultKey(ID);
				SavingAccountContainer.Instance.UpdateSavingAccount(accountID);
				if (_containerInstance.Collection.Count == index)
					SelectedIndex = index - 1;
				else
					SelectedIndex = index;
			}
			catch(MySqlException e)
			{ ShowErrorMessage(e); }
		}
		#endregion

		#region Can Execute
		protected override bool CanExecuteAdd()
		{
			return SelectedAccount != null && Amount > 0;
		}
		protected override bool CanExecuteClear()
		{
			return IsInsertMode;
		}
		protected override bool CanExecuteDelete()
		{
			return IsReadOnly && SelectedSlip != null;
		}
		protected bool CanExecuteUpdate()
		{
			return IsReadOnly && SelectedSlip != null;
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

			ShowMessage("WARNING", endMessage);
		}

		protected override void ClearAllFields()
		{
			Amount = 0;
			CreateDate = DateTime.Now;
		}
	}
}
