using AcademicSavingService.Controls;
using MySql.Data.MySqlClient;

namespace AcademicSavingService.ViewModel
{
    class ErrorDisplayer : TabItemViewModel
    {
		protected const int codeLength = 5;
		protected const int UserDefinedErrorNumber = 1644;
		protected const int CantUpdateOrDeleteCauseOfConstraintErrorNumber = 1451;

		protected virtual void ShowErrorMessage(MySqlException exception)
		{
			ShowMessage("Warning!", exception.Message);
		}

		protected void ShowMessage(string title, string message)
		{
			MessageBox.ShowMessage(title, message);
		}

		protected string TranslateImplementedMessage(string message)
		{
			string trueMessage = "";
			switch (message.Substring(0, codeLength))
			{
				case ("TK000"): trueMessage = "Interaction with the saving account has failed!"; break;
				case ("TK001"): trueMessage = "The initial balance is lesser than the minimum requirement!"; break;
				case ("TK002"): trueMessage = "The selected term is not valid!"; break;
				case ("TK003"): trueMessage = "You're not allowed to change the saving account!"; break;
				case ("TK004"): trueMessage = "You're calling to update the saving account the pass or the future"; break;
				case ("PG000"): trueMessage = "Deposit complete"; break;
				case ("PG001"): trueMessage = "The amount of money you're trying deposit is lesser than the minimum requirement"; break;
				case ("PG002"): trueMessage = "Transaction complete"; break;
				case ("PG003"): trueMessage = "You can't complete transaction on the saving account before due date"; break;
				case ("PR000"): trueMessage = "Withdraw complete"; break;
				case ("PR001"): trueMessage = "You can't withdraw before due date or before the minimum days"; break;
				case ("PR002"): trueMessage = "You can only withdraw all the money of an term deposit"; break;
				case ("PR003"): trueMessage = "Not enough money to withdraw"; break;
				case ("PR004"): trueMessage = "Can't complete the withdraw"; break;
				case ("PH001"): trueMessage = "This account is closed or not exists"; break;
				case ("PH002"): trueMessage = "You have to delete the slips in orders"; break;
				case ("PH003"): trueMessage = "You can only withdraw after you created the account"; break;
				case ("PH005"): trueMessage = "You aren't allow to update slips other than Note"; break;
				case ("QD000"): trueMessage = "Add/Delete rules successfully"; break;
				case ("QD001"): trueMessage = "You are not allow to update rules"; break;
				case ("QD002"): trueMessage = "There is more than one saving account or slip that use this rule"; break;
				case ("QD003"): trueMessage = "You can't add rule to the past"; break;
				case ("KY000"): trueMessage = "Add/Delete term successfully"; break;
				case ("KY001"): trueMessage = "Demand interest rate is incorrect"; break;
				case ("KY002"): trueMessage = "You have to stop using the previous interest rate of this term"; break;
				case ("KY003"): trueMessage = "Can't delete cause there is an account exists after this term"; break;
				case ("KY004"): trueMessage = "Can't update terms"; break;
				case ("BC001"): trueMessage = "Can't update report"; break;
			}
			return trueMessage;
		}

		public ErrorDisplayer(MenuItemViewModel menuItem) : base(menuItem) { }
	}
}
