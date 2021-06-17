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
			DependencyProperty.Register("AcceptDecimal", typeof(bool), typeof(DigitTextBox), new PropertyMetadata(true));
		public bool AcceptDecimal
		{
			get { return (bool)GetValue(AcceptDecimalProperty); }
			set { SetValue(AcceptDecimalProperty, value); }
		}

		Regex regexDecimal;
		Regex regexInt;
		public DigitTextBox()
		{
			regexDecimal = new Regex("[^0-9.]");
			regexInt = new Regex("[^0-9]");
			PreviewTextInput += NumberValidationTextBox;
			TextChanged += (sender, e) =>
			{
				if (((TextBox)sender).Text == "")
					((TextBox)sender).Text = "0";
			};

		}

		private void NumberValidationTextBox(object sender, TextCompositionEventArgs e)
		{
			if (AcceptDecimal)
			{
				if (regexDecimal.IsMatch(e.Text))
					e.Handled = true;
				else if (Text.Contains('.'))
				{
					if (e.Text.Contains('.'))
						e.Handled = true;
				}
			}
			else
			{
				e.Handled = regexInt.IsMatch(e.Text);
			}
		}
	}
}
