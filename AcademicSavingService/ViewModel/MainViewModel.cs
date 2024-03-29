﻿using PropertyChanged;
using System.ComponentModel;
using System.Collections.ObjectModel;
using MahApps.Metro.IconPacks;
using System.Windows.Media;
using System.Windows;
using System.Collections.Generic;
using System;

namespace AcademicSavingService.ViewModel
{
	[AddINotifyPropertyChangedInterface]
	class MainViewModel : INotifyPropertyChanged, IDisposable
	{
		public event PropertyChangedEventHandler PropertyChanged = (sender, e) => { };
		public ObservableCollection<MenuItemViewModel> MenuItems { get; set; }
		public ObservableCollection<MenuItemViewModel> MenuOptionItems { get; set; }
        public SolidColorBrush TitleBarBackGround { get; set; }

        public static MainViewModel Instance { get; protected set; }
        public bool AskBeforeUpdate { get; set; }
        public bool AskBeforeDelete { get; set; }

        protected bool _showDarkBackGround = false;
        public bool ShowDarkBackGround
		{
            get { return _showDarkBackGround; }
            set { if (_showDarkBackGround != value) _showDarkBackGround = value; }
		}

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

                        if (_darkMenu.Contains(value) && _darkMenu.Contains(_selectedMenu))
                            ShowDarkBackGround = true;
                        else
                            ShowDarkBackGround = false;
                    }

                    _selectedMenu = value;
                    _selectedMenu.IsVisible = true;
                }
            }    
        }

        protected List<MenuItemViewModel> _darkMenu;

        public MainViewModel()
        {
            Instance = this;
            CreateMenuItems();
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
                Icon = new PackIconMaterial() { Kind = PackIconMaterialKind.Safe },
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

            _darkMenu = new List<MenuItemViewModel>
            {
                ContactVM,
                HomeVM
            };
        }

        public void Dispose()
		{
            foreach (var item in MenuItems)
                item.Dispose();
            foreach (var item in MenuOptionItems)
                item.Dispose();
		}
    }
}
