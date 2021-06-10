using PropertyChanged;
using System.ComponentModel;
using System.Threading.Tasks;
using System.Collections.ObjectModel;
using System.Windows;

namespace AcademicSavingService.ViewModel
{
	[AddINotifyPropertyChangedInterface]
	class MenuItemViewModel : INotifyPropertyChanged
	{
		public event PropertyChangedEventHandler PropertyChanged = (sender, e) => { };

		public MenuItemViewModel(MainViewModel mainViewModel)
		{
			MainViewModel = mainViewModel;
			_tabsMargin = new Thickness(0, 0, -1, 0);
			SelectedIndex = 0;
		}

        public MainViewModel MainViewModel { get; }
        public object Icon {get; set;}
        public object Label { get; set; }
        public object ToolTip { get; set; }
        public bool IsVisible { get; set; }

		public ObservableCollection<TabItemViewModel> TabItems { get; set; }
		public object SelectedIndex { get; set; }
		protected double _tabsWidth = 120;
		protected Thickness _tabsMargin;
	}
}
