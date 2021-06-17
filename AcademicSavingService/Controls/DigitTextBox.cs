using PropertyChanged;
using System.Windows.Controls;
using System.Text.RegularExpressions;
using System.Windows.Input;
using System.Windows;

namespace AcademicSavingService.Controls
{
	[AddINotifyPropertyChangedInterface]
	public class DigitTextBox : TextBox
	{
		public readonly static DependencyProperty AcceptDecimalProperty = 
			DependencyProperty.Register("AcceptDecimal", typeof(bool), typeof(DigitTextBox));
		public bool AcceptDecimal
		{
			get { return (bool)GetValue(AcceptDecimalProperty); }
			set { 
				SetValue(AcceptDecimalProperty, value);
			}
		}

		Regex regex;
		public DigitTextBox()
		{
			regex = new Regex("[^0-9.]");
			PreviewTextInput += NumberValidationTextBox;
			TextChanged += (sender, e) =>
			{
				if (((TextBox)sender).Text == "")
					((TextBox)sender).Text = "0";
			};

		}

		private void NumberValidationTextBox(object sender, TextCompositionEventArgs e)
		{
			if (regex.IsMatch(e.Text))
				e.Handled = true;
			else if (Text.Contains('.'))
			{
				if (e.Text.Contains('.'))
					e.Handled = true;
			}
		}
	}
}
