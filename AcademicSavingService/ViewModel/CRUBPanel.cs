using AcademicSavingService.Commands;
using AcademicSavingService.Containers;
using AcademicSavingService.Controls;
using MySql.Data.MySqlClient;
using System.Windows.Input;

namespace AcademicSavingService.ViewModel
{
	class CRUBPanel : TabItemViewModel
	{
		public bool IsInsertMode { get; set; }
		public bool IsReadOnly
		{
			get { return !IsInsertMode; }
		}

		public double VerticleSplit { get; set; }
		public double HorizontalSplit { get; set; }

		public int SelectedIndex { get; set; }

		public const int UserDefinedErrorNumber = 1644;
		public const int CantUpdateOrDeleteCauseOfConstraintErrorNumber = 1451;

		public CRUBPanel(MenuItemViewModel menuItem) : base(menuItem)
		{}

		protected RelayCommand<SavingAccountsManagerViewModel> _startInsertCommand;
		protected RelayCommand<SavingAccountsManagerViewModel> _clearCommand;
		protected RelayCommand<SavingAccountsManagerViewModel> _addCommand;
		protected RelayCommand<SavingAccountsManagerViewModel> _deleteCommand;

		protected int _indexBeforeInsertMode = -1;

		public ICommand DeleteCommand => _deleteCommand ?? (_deleteCommand = new RelayCommand<SavingAccountsManagerViewModel>(param => ExecuteDelete(), param => CanExecuteDelete()));
		public ICommand ClearCommand => _clearCommand ?? (_clearCommand = new RelayCommand<SavingAccountsManagerViewModel>(param => ClearAllFields(), param => CanExecuteClear()));
		public ICommand StartInsertCommand => _startInsertCommand ?? (_startInsertCommand = new RelayCommand<SavingAccountsManagerViewModel>(param => ExecuteInsertMode(), param => CanExecuteInsertMode()));
		public ICommand CreateCommand => _addCommand ?? (_addCommand = new RelayCommand<SavingAccountsManagerViewModel>(param => ExecuteAdd(), param => CanExecuteAdd()));

		protected virtual void ExecuteDelete()
		{ }
		protected virtual bool CanExecuteDelete()
		{
			return true;
		}

		protected virtual void ExecuteAdd()
		{}
		protected virtual bool CanExecuteAdd()
		{
			return IsInsertMode;
		}

		protected virtual void ExecuteInsertMode()
		{
			if (!IsInsertMode)
			{
				ClearAllFields();
			}
			IsInsertMode = !IsInsertMode;
		}
		protected virtual bool CanExecuteInsertMode()
		{
			return true;
		}

		protected virtual void ExecuteClear()
		{
			ClearAllFields();
		}
		protected virtual bool CanExecuteClear()
		{
			return IsInsertMode;
		}

		protected virtual void ClearAllFields()
		{}

		protected virtual void ShowErrorMessage(MySqlException exception)
		{
			ShowMessage("Warning!", exception.Message);
		}

		protected void ShowMessage(string title, string message)
		{
			MessageBox.ShowMessage(title, message);
		}

		protected int codeLength = 5;
		protected string TranslateImplementedMessage(string message)
		{
			string trueMessage = "";
			switch (message.Substring(0, codeLength))
			{
				case ("KH001"): trueMessage = "You can't update the register date to after the creation of a saving account!"; break;
				case ("TK000"): trueMessage = "Interaction with the saving account has failed!"; break;
				case ("TK001"): trueMessage = "The initial balance is lesser than the minimum requirement!"; break;
				case ("TK002"): trueMessage = "The selected term is not valid!"; break;
				case ("TK003"): trueMessage = "You're not allowed to change the saving account!"; break;
				case ("TK004"): trueMessage = "You're calling to update the saving account the pass or the future!"; break;
				case ("TK005"): trueMessage = "You can only update the saving account when you haven't withdraw from this yet!"; break;
				case ("TK006"): trueMessage = "There are transaction exists before this account is created!"; break;
				case ("TK007"): trueMessage = "There are no rules that exists before create date!"; break;
				case ("TK008"): trueMessage = "You can only create saving account after a you have registered!"; break;
				case ("PG000"): trueMessage = "Deposit complete"; break;
				case ("PG001"): trueMessage = "The amount of money you're trying deposit is lesser than the minimum requirement"; break;
				case ("PG002"): trueMessage = "Transaction complete"; break;
				case ("PG003"): trueMessage = "You can't complete transaction on the saving account before due date or before minimum day required!"; break;
				case ("PG004"): trueMessage = "You can't deposit the date before you withdraw!"; break;
				case ("PR000"): trueMessage = "Withdraw complete"; break;
				case ("PR001"): trueMessage = "You can't withdraw before due date or before the minimum days"; break;
				case ("PR002"): trueMessage = "You can only withdraw all the money of an term deposit"; break;
				case ("PR003"): trueMessage = "Not enough money to withdraw"; break;
				case ("PR004"): trueMessage = "Can't complete the withdraw"; break;
				case ("PR005"): trueMessage = "You can't insert a withdraw slip before the closest withdraw slip!"; break;
				case ("PR006"): trueMessage = "You can't insert this because if you do the saving account will close and there is at least one deposit slip after this"; break;
				case ("PR007"): trueMessage = "You can't update withdraw slip that exists before another withdraw slip"; break;
				case ("PH001"): trueMessage = "This account is closed or not exists"; break;
				case ("PH002"): trueMessage = "You have to delete the slips in orders"; break;
				case ("PH003"): trueMessage = "You can only withdraw or deposit after you created the account"; break;
				case ("PH005"): trueMessage = "You aren't allow to update slips other than Note"; break;
				case ("QD000"): trueMessage = "Add/Delete rules successfully"; break;
				case ("QD001"): trueMessage = "You are not allow to update rules"; break;
				case ("QD002"): trueMessage = "There is more than one saving account or slip that use this rule"; break;
				case ("QD003"): trueMessage = "You can't add rule to the past"; break;
				case ("QD004"): trueMessage = "You are asking for a rule which not exists"; break;
				case ("KY000"): trueMessage = "Add/Delete term successfully"; break;
				case ("KY001"): trueMessage = "Demand interest rate is incorrect"; break;
				case ("KY002"): trueMessage = "You have to stop using the previous interest rate of this term"; break;
				case ("KY003"): trueMessage = "Can't delete cause there is an account exists after this term"; break;
				case ("KY004"): trueMessage = "Can't update terms"; break;
				case ("KY005"): trueMessage = "Can't update a term if there is at least one saving account saving that term"; break;
				case ("KY006"): trueMessage = "Can't update terms"; break;
				case ("BC001"): trueMessage = "Can't update report"; break;
			}
			return trueMessage;
		}
	}
}
