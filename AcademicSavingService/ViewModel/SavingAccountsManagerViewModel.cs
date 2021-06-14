using System.Collections.ObjectModel;
using AcademicSavingService.Containers;
using AcademicSavingService.Commands;
using PropertyChanged;
using System;
using AcademicSavingService.Controls;
using System.Windows.Input;
using AcademicSavingService.INPC;

namespace AcademicSavingService.ViewModel
{
	[AddINotifyPropertyChangedInterface]
	class SavingAccountsManagerViewModel : TabItemViewModel
	{
		public ObservableCollection<SavingAccountINPC> SavingAccounts { get; set; }
		public ObservableCollection<CustomerINPC> Customers { get; set; }

		public int SelectedAccountIndex { get; set; }
		protected SavingAccountINPC _selectedAccount;
		public SavingAccountINPC SelectedAccount 
		{ 
			get { return _selectedAccount; }
			set
			{
				_selectedAccount = value;
				if (_selectedAccount != null)
                {
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
				else
                {
                    ID = 0;
                    CreateDate = DateTime.Now;
                    CloseDate = null;
                    LastUpdateDate = null;
                    Balance = 0;
                    InitialBalance = 0;

					SelectedTermIndex = -1;
					SelectedCustomer = null;
                }
			}
		}

		protected CustomerINPC _selectedCustomer;
		public CustomerINPC SelectedCustomer 
		{ 
			get { return _selectedCustomer; }
			set
			{
				_selectedCustomer = value;
				if (_selectedCustomer != null)
				{
					CustomerID = _selectedCustomer.MaKH;
				}
				else CustomerID = 0;
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

					var tempContainer = TermTypeContainer.Instance.GetClosestTermAndInterestToDate(value);
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

		public double VerticleSplit { get; set; }
		public double HorizontalSplit { get; set; }

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
            SavingAccounts = SavingAccountContainer.Instance.Collection;
			Customers = CustomerContainer.Instance.Collection;
			CreateDate = DateTime.Now;
		}

		public void CreateAccount()
		{
			SavingAccountContainer.Instance.AddToCollection(new SavingAccountINPC{
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
			SavingAccountContainer.Instance.UpdateSavingAccountStateToNgayCanUpdate(SelectedAccount.MaSo, DateTime.Now);
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
			for (int i = 0; i < SavingAccounts.Count; i++)
			{
				SavingAccountContainer.Instance.UpdateSavingAccountStateToNgayCanUpdate(SavingAccounts[i].MaSo, DateTime.Now);
			}
		}

		public bool CanUpdateAllAccounts()
		{
			return true;
		}

		public void DeleteAccount()
		{
			int index = SelectedAccountIndex;
			SavingAccountContainer.Instance.DeleteFromCollectionByDefaultKey(ID);
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
