using PropertyChanged;
using System.Windows.Input;
using AcademicSavingService.Commands;
using AcademicSavingService.Containers;
using MySql.Data.MySqlClient;

namespace AcademicSavingService.ViewModel
{
	[AddINotifyPropertyChangedInterface]
	class WithdrawsManagerViewModel : TransactionManagerViewModel
	{
		public bool WithDrawAll { get; set; } = false;

		public WithdrawsManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
		{
			_containerInstance = WithdrawSlipContainer.Instance;
			Slips = _containerInstance.Collection;
		}

		protected override void ExecuteAdd()
		{
			if (WithDrawAll)
			{
				ExecuteWithdrawAll();
			}
			else
				base.ExecuteAdd();
		}

		protected override bool CanExecuteAdd()
		{
			return base.CanExecuteAdd() || (WithDrawAll && IsInsertMode && SelectedAccount != null);
		}

		protected void ExecuteWithdrawAll()
		{
			try
			{
				var slip = new INPC.TransactionSlipINPC()
				{
					MaPhieu = ID,
					MaSo = AccountID,
					NgayTao = CreateDate,
					GhiChu = Note,
				};
				((WithdrawSlipContainer)_containerInstance).AddWithdrawAllSlipToCollection(slip);
				SavingAccountContainer.Instance.UpdateSavingAccount(slip.MaSo);
			}
			catch(MySqlException e)
			{ ShowErrorMessage(e); }
		}
	}
}
