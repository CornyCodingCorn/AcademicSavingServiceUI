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

		public static readonly DependencyProperty LeftMarginProperty = DependencyProperty.Register(
			"LeftMargin",
			typeof(GridLength),
			typeof(AssCRUDPanel)
		);
		public GridLength LeftMargin
		{
			get { return (GridLength)GetValue(LeftMarginProperty); }
			set { SetValue(LeftMarginProperty, value); }
		}

		public static readonly DependencyProperty RightMarginProperty = DependencyProperty.Register(
			"RightMargin",
			typeof(GridLength),
			typeof(AssCRUDPanel)
		);
		public GridLength RightMargin
		{
			get { return (GridLength)GetValue(RightMarginProperty); }
			set { SetValue(RightMarginProperty, value); }
		}

		public static readonly DependencyProperty MaxLeftMarginProperty = DependencyProperty.Register(
			"MaxLeftMargin",
			typeof(double),
			typeof(AssCRUDPanel)
		);
		public double MaxLeftMargin
		{
			get { return (double)GetValue(MaxLeftMarginProperty); }
			set { SetValue(MaxLeftMarginProperty, value); }
		}

		public static readonly DependencyProperty MaxRightMarginProperty = DependencyProperty.Register(
			"MaxRightMargin",
			typeof(double),
			typeof(AssCRUDPanel)
		);
		public double MaxRightMargin
		{
			get { return (double)GetValue(MaxRightMarginProperty); }
			set { SetValue(MaxRightMarginProperty, value); }
		}

		public static readonly DependencyProperty MinLeftMarginProperty = DependencyProperty.Register(
			"MinLeftMargin",
			typeof(double),
			typeof(AssCRUDPanel)
		);
		public double MinLeftMargin
		{
			get { return (double)GetValue(MinLeftMarginProperty); }
			set { SetValue(MinLeftMarginProperty, value); }
		}

		public static readonly DependencyProperty MinRightMarginProperty = DependencyProperty.Register(
			"MinRightMargin",
			typeof(double),
			typeof(AssCRUDPanel)
		);
		public double MinRightMargin
		{
			get { return (double)GetValue(MinRightMarginProperty); }
			set { SetValue(MinRightMarginProperty, value); }
		}

		public AssCRUDPanel()
		{
			MaxRightMargin = 200;
			MinRightMargin = 80;

			MaxLeftMargin = 200;
			MinLeftMargin = 80;

			RightMargin = new GridLength(40, GridUnitType.Star);
			LeftMargin = new GridLength(40, GridUnitType.Star);
			InitializeComponent();
		}
	}
}
