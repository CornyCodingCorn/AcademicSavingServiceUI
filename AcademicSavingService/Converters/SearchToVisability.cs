using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Data;

namespace AcademicSavingService.Converters
{
	class SearchToVisability : IMultiValueConverter
    {
        public object Convert(object[] values, Type targetType, object parameter, CultureInfo culture)
        {
            if ((string)values[0] == "") return Visibility.Visible;

            var searchText = ((string)values[0]).ToLower();
            var row = values[1];
            foreach (var p in row.GetType().GetProperties())
            {
                if (System.Convert.ToString(p.GetValue(row)).ToLower().Contains(searchText))
                    return Visibility.Visible;
            }
            return Visibility.Collapsed;
        }

        public object[] ConvertBack(object value, Type[] targetTypes, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
