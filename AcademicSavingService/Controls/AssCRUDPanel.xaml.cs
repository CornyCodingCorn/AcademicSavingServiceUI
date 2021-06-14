using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using PropertyChanged;

namespace AcademicSavingService.Controls
{
	/// <summary>
	/// Interaction logic for AssCRUDPanel.xaml
	/// </summary>
	[AddINotifyPropertyChangedInterface]
	public partial class AssCRUDPanel : UserControl
	{
		public object Left
		{ 
			get { return leftChild.Content; }	
			set { leftChild.Content = value; }
		}
		public object Middle
		{ 
			get { return middleChild.Content; }
			set { middleChild.Content = value; }
		}

		public AssCRUDPanel()
		{
			InitializeComponent();
		}
	}
}
