using PropertyChanged;
using System.Windows.Controls;

namespace AcademicSavingService.Controls
{
	/// <summary>
	/// Interaction logic for AssDeveloper.xaml
	/// </summary>
	[AddINotifyPropertyChangedInterface]
	public partial class AssDeveloper : UserControl
	{
		public string DevTitle	{ get; set; }
		public string DevName	{ get; set; }
		public string DevEmail	{ get; set; }
		public string DevPhone	{ get; set; }

		public AssDeveloper()
		{
			InitializeComponent();
			content.DataContext = this;
		}
	}
}
