using System.Collections.ObjectModel;
using System.Windows.Input;
using AcademicSavingService.InpcContainers;
using AcademicSavingService.DataAccess;
using AcademicSavingService.Commands;
using AcademicSavingService.Model;

namespace AcademicSavingService.ViewModel
{
	class SavingAccountsManagerViewModel : TabItemViewModel
	{
		private ObservableCollection<SavingAccountViewModel> _accounts;
		private SavingAccountDA _accountDA;

		public ObservableCollection<SavingAccountViewModel> SavingAccounts => _accounts;

		public SavingAccountsManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
		{
			_accountDA = new SavingAccountDA();
			_testCustomersDA = new CustomersDA();
			_testCommand = new RelayCommand(TestFunction, (obj) => true);

            _accounts = _accountDA.GetAllSavingAccounts();
		}

		#region TESTING

		// only for TESTING
		private CustomersDA _testCustomersDA;
        private RelayCommand _testCommand;

		public ICommand TestCommand => _testCommand;

		private void TestFunction()
        {
			Customer customer = new()
            {
				MaKH = 5,
				HoTen = "Pinkguy",
			};
			_testCustomersDA.UpdateCustomerByMaKH(customer);
        }

        #endregion
    }
}
