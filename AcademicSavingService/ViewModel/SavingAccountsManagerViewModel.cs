using System.Collections.ObjectModel;
using AcademicSavingService.InpcContainers;
using AcademicSavingService.Commands;
using PropertyChanged;
using System;
using AcademicSavingService.Controls;
using System.Windows.Input;

namespace AcademicSavingService.ViewModel
{
	[AddINotifyPropertyChangedInterface]
	class SavingAccountsManagerViewModel : TabItemViewModel
	{
		public ObservableCollection<SavingAccountViewModel> SavingAccounts { get; set; }
		public ObservableCollection<CustomerViewModel> Customers { get; set; }

		public int SelectedAccountIndex { get; set; }
		protected SavingAccountViewModel _selectedAccount;
		public SavingAccountViewModel SelectedAccount 
		{ 
			get { return _selectedAccount; }
			set
			{
				_selectedAccount = (SavingAccountViewModel)value;
				ID = _selectedAccount.MaSo;
				CreateDate = _selectedAccount.NgayTao;
				CloseDate = _selectedAccount.NgayDongSo;
				LastUpdateDate = _selectedAccount.LanCapNhatCuoi;
				Balance = _selectedAccount.SoDu;
				InitialBalance = _selectedAccount.SoTienBanDau;

				for (int i = 0; i < TermsList.Count; i++)
				{
					if (TermsList[i] == _selectedAccount.KyHan)
					{
						SelectedTermIndex = i;
						break;
					}
				}

				foreach (var account in Customers)
				{
					if (account.MaKH == _selectedAccount.MaKH)
					{
						SelectedCustomer = account;
						break;
					}
				}
			}
		}
		protected CustomerViewModel _selectedCustomer;
		public CustomerViewModel SelectedCustomer 
		{ 
			get { return _selectedCustomer; }
			set
			{
				_selectedCustomer = (CustomerViewModel)value;
				CustomerID = _selectedCustomer.MaKH;
			}
		}

		public ObservableCollection<int> TermsList { get; set; } = new ObservableCollection<int>();
		public ObservableCollection<float> InterestRateList { get; set; } = new ObservableCollection<float>();

		protected int _selectedTermIndex;
		public int SelectedTermIndex 
		{ 
			get { return _selectedTermIndex; }
			set
			{
				if (_selectedTermIndex != value)
				{
					_selectedTermIndex = value;
					if (value < 0 || value >= InterestRateList.Count)
						InterestRate = 0;
					else
						InterestRate = InterestRateList[value];
				}
			}
		}

		public float InterestRate { get; set; }

		public int ID { get; set; }
		protected DateTime _createDate;
		public DateTime CreateDate 
		{ 
			get { return _createDate; }
			set
			{
				if (value != _createDate)
				{
					_createDate = value;
					TermsList.Clear();
					InterestRateList.Clear();
					SelectedTermIndex = -1;
					InterestRate = 0;

					var tempContainer = TermTypeViewModel.GetTermWithDate(value);
					foreach (var item in tempContainer)
					{
						TermsList.Add(item.Key);
						InterestRateList.Add(item.Value);
					}
				}
			}
		}

		public DateTime? LastUpdateDate { get; set; }
		public DateTime? CloseDate { get; set; }
		public decimal Balance { get; set; }
		public decimal InitialBalance { get; set; }
		public int CustomerID { get; set; }


		protected RelayCommand<SavingAccountsManagerViewModel> _addCommand;
		protected RelayCommand<SavingAccountsManagerViewModel> _deleteCommand;
		protected RelayCommand<SavingAccountsManagerViewModel> _updateOne;
		protected RelayCommand<SavingAccountsManagerViewModel> _updateAll;

		public ICommand CreateAccountCommand => _addCommand ?? (_addCommand = new RelayCommand<SavingAccountsManagerViewModel>(param => CreateAccount(), param => CanCreateAccount()));
		public ICommand DeleteAccountCommand => _deleteCommand ?? (_deleteCommand = new RelayCommand<SavingAccountsManagerViewModel>(param => DeleteAccount(), param => CanDeleteAccount()));
		public ICommand UpdateOneCommand => _updateOne ?? (_updateOne = new RelayCommand<SavingAccountsManagerViewModel>(param => UpdateAccount(), param => CanUpdateAccount()));
		public ICommand UpdateAllCommand => _updateAll ?? (_updateAll = new RelayCommand<SavingAccountsManagerViewModel>(param => UpdateAllAccounts(), param => CanUpdateAllAccounts()));

		public SavingAccountsManagerViewModel(MenuItemViewModel menuItem) : base(menuItem)
		{
            SavingAccounts = SavingAccountViewModel.Container;
			Customers = CustomerViewModel.Container;
			CreateDate = DateTime.Now;
		}

		public void CreateAccount()
		{
			SavingAccountViewModel.CreateAccount(new SavingAccountViewModel{
				MaKH = CustomerID,
				KyHan = TermsList[SelectedTermIndex],
				SoTienBanDau = InitialBalance,
				NgayTao = CreateDate,
				LaiSuat = InterestRate,
			});
		}

		public bool CanCreateAccount()
		{
			if (CreateDate.Year < 1800 || SelectedTermIndex < 0)
			{
				return false;
			}
			else
				return true;
		}


		public void UpdateAccount()
		{
			SavingAccountViewModel.CallUpdateOneAccount(SelectedAccount.MaSo, DateTime.Now);
		}

		public bool CanUpdateAccount()
		{
			if (SelectedAccount == null)
				return false;
			else
				return true;
		}

		public void UpdateAllAccounts()
		{
			SavingAccountViewModel.CallUpdateAllAccounts(DateTime.Now);
		}

		public bool CanUpdateAllAccounts()
		{
			return true;
		}

		public void DeleteAccount()
		{
			int index = SelectedAccountIndex;
			SavingAccountViewModel.DeleteAccount(ID);
			SelectedTermIndex = index;
		}

		public bool CanDeleteAccount()
		{
			if (SelectedAccount == null)
				return false;
			else 
				return true;
		}
    }
}
