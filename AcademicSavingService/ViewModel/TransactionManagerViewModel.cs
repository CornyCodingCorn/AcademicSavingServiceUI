using AcademicSavingService.Commands;
using AcademicSavingService.Containers;
using AcademicSavingService.INPC;
using MySql.Data.MySqlClient;
using PropertyChanged;
using System;
using System.Collections.ObjectModel;
using System.Windows.Input;

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

				AccountID = _selectedAccount.MaSo;
				OwnerID = _selectedAccount.MaKH;
				Balance = _selectedAccount.SoDu;
				LastUpdate = _selectedAccount.LanCapNhatCuoi;
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
					return;

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
		#endregion

		public int SelectedAccountIndex { get; set; }
		public int SelectedSlipIndex { get; set; }

		#region Execution
		protected RelayCommand<TransactionManagerViewModel> _updateCommand;
		public ICommand UpdateCommand => _updateCommand ?? (_updateCommand = new RelayCommand<TransactionManagerViewModel>(param => ExecuteUpdate(), param => CanExecuteUpdate()));

		protected override void ExecuteInsertMode()
		{
			base.ExecuteInsertMode();
			if (IsInsertMode)
			{
				_indexBeforeInsertMode = SelectedSlipIndex;
				SelectedSlip = null;
				CreateDate = DateTime.Now;
				ID = _containerInstance.GetNextAutoID();
			}
			else
			{
				SelectedSlipIndex = _indexBeforeInsertMode;
			}
		}
		protected override void ExecuteAdd()
		{
			try
			{
				_containerInstance.AddToCollection(new TransactionSlipINPC(ID, CreateDate, Amount, Note, AccountID));
			}
			catch(MySqlException e)
			{ ShowErrorMessage(e); }
		}
		protected virtual void ExecuteUpdate()
		{
			try
			{
				_containerInstance.UpdateOnCollection(new TransactionSlipINPC(ID, CreateDate, Amount, Note, AccountID));
			}
			catch(MySqlException e)
			{ ShowErrorMessage(e); }
		}
		protected override void ExecuteDelete()
		{
			try
			{
				_containerInstance.DeleteFromCollectionByDefaultKey(ID);
			}
			catch(MySqlException e)
			{ ShowErrorMessage(e); }
		}
		#endregion

		#region Can Execute
		protected override bool CanExecuteAdd()
		{
			return IsInsertMode && SelectedAccount.SoDu > 0 && Amount > 0;
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

			ShowMessage("Warning!", endMessage);
		}

		protected override void ClearAllField()
		{
			Amount = 0;
			CreateDate = DateTime.Now;
		}
	}
}
