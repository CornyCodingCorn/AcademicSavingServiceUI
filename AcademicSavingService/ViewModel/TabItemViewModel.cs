using PropertyChanged;
using System.ComponentModel;
using System.Threading.Tasks;
using System.Collections.ObjectModel;
using System.Windows;

namespace AcademicSavingService.ViewModel
{
	[AddINotifyPropertyChangedInterface]
	class TabItemViewModel : INotifyPropertyChanged
	{
		public event PropertyChangedEventHandler PropertyChanged = (sender, e) => { };

		public TabItemViewModel(MenuItemViewModel menuItem)
		{
			MenuItem = menuItem;
		}

		public MenuItemViewModel MenuItem { get; }
		public object Header { get; set; }
		public double Width { get; set; }
		public Thickness Margin { get; set; }
	}
}
