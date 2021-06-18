using PropertyChanged;
using System.ComponentModel;
using System.Threading.Tasks;
using System.Collections.ObjectModel;
using MahApps.Metro.IconPacks;
using System.Windows.Media;
using System.Windows;
using ControlzEx.Theming;
using AcademicSavingService.Controls;
using AcademicSavingService.Animation;

namespace AcademicSavingService.ViewModel
{
	[AddINotifyPropertyChangedInterface]
	class MainViewModel : INotifyPropertyChanged
	{
		public event PropertyChangedEventHandler PropertyChanged = (sender, e) => { };
		public ObservableCollection<MenuItemViewModel> MenuItems { get; set; }
		public ObservableCollection<MenuItemViewModel> MenuOptionItems { get; set; }
        public SolidColorBrush TitleBarBackGround { get; set; }

        public static MainViewModel Instance { get; protected set; }
        public bool AskBeforeUpdate { get; set; }
        public bool AskBeforeDelete { get; set; }

        public MenuItemViewModel HomeVM { get; set; }
        public MenuItemViewModel BankMVM { get; set; }
        public MenuItemViewModel ServiceMVM { get; set; }
        public MenuItemViewModel ReportMVM { get; set; }
        public MenuItemViewModel ContactVM { get; set; }
        public MenuItemViewModel SettingVM { get; set; }

        public object Label { get => SelectedMenu.Label; }

        protected MenuItemViewModel _selectedItem;
        public MenuItemViewModel SelectedItem
		{
            get { return _selectedItem; }
            set
			{
                _selectedItem = value;
                if (value != null)
                    SelectedMenu = _selectedItem;
            }
		}

        protected MenuItemViewModel _selectedOptionItem;
        public MenuItemViewModel SelectedOptionItem
        {
            get { return _selectedOptionItem; }
            set
            {
                _selectedOptionItem = value;
                if (value != null)
                    SelectedMenu = _selectedOptionItem;
            }
        }

        protected MenuItemViewModel _selectedMenu;
        protected MenuItemViewModel SelectedMenu
		{ 
            get { return _selectedMenu; }
            set
			{
                if (_selectedMenu != value)
				{
                    if (_selectedMenu != null)
                    {
                        var item = _selectedMenu;
                        item.IsVisible = false;
                    }

                    _selectedMenu = value;
                    _selectedMenu.IsVisible = true;
                }
            }    
        }

        public MainViewModel()
        {
            Instance = this;
            Load();
            CreateMenuItems();
        }

        protected void Load()
		{

		}

        protected void CreateMenuItems()
        {
            TitleBarBackGround = (SolidColorBrush)(Application.Current.FindResource("MahApps.Brushes.AccentBase"));

            HomeVM = new HomeViewModel(this)
            {
                Icon = new PackIconMaterial() { Kind = PackIconMaterialKind.Home },
                Label = "Home menu",
                ToolTip = "Home menu",
                IsVisible = false
            };
            BankMVM = new BanksManagerViewModel(this)
            {
                Icon = new PackIconMaterial() { Kind = PackIconMaterialKind.Bank },
                Label = "Banks manager",
                ToolTip = "Where you manage banks",
                IsVisible = false
            };
            ServiceMVM = new ServicesManagerViewModel(this)
            {
                Icon = new PackIconMaterial() { Kind = PackIconMaterialKind.CurrencyEur },
                Label = "Services manager",
                ToolTip = "Where you manage services",
                IsVisible = false
            };
            ReportMVM = new ReportsManagerViewModel(this)
            {
                Icon = new PackIconMaterial() { Kind = PackIconMaterialKind.Notebook },
                Label = "Reports",
                ToolTip = "where you manage reports",
                IsVisible = false
            };

            MenuItems = new ObservableCollection<MenuItemViewModel>
            {
                HomeVM,
                BankMVM,
                ServiceMVM,
                ReportMVM
            };

            ContactVM = new ContactAndHelpViewModel(this)
            {
                Icon = new PackIconMaterial() { Kind = PackIconMaterialKind.Help },
                Label = "Helps",
                ToolTip = "Contact the developers",
                IsVisible = false
            };

            SettingVM = new SettingsViewModel(this)
            {
                Icon = new PackIconMaterial() { Kind = PackIconMaterialKind.Cog },
                Label = "Settings",
                ToolTip = "The Application settings",
                IsVisible = false
            };

            MenuOptionItems = new ObservableCollection<MenuItemViewModel>
            {
                ContactVM,
                SettingVM
            };
        }
    }
}
