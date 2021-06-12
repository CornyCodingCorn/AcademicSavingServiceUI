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
				if (value)
					regex = new Regex("[^0-9]+.");
				else
					regex = new Regex("[^0-9]+");
			}
		}

		Regex regex;
		public DigitTextBox()
		{
			regex = new Regex("[^0-9]+");
			PreviewTextInput += NumberValidationTextBox;
		}

		private void NumberValidationTextBox(object sender, TextCompositionEventArgs e)
		{
			e.Handled = regex.IsMatch(e.Text);
		}
	}
}
