using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace AcademicSavingService.Converters
{
	public class BoolAndConverter : IMultiValueConverter
	{
        public object Convert(object[] values, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            int size = values.Length;
            bool result = true;
            for (int i = 0; i < size; i++)
			{
                result = result && (bool)values[i];
			}
            return result;
        }

        public object[] ConvertBack(object value, Type[] targetTypes, object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
