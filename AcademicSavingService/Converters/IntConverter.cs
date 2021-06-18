using System;
using System.Globalization;
using System.Windows.Data;

namespace AcademicSavingService.Converters
{
    public class IntConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            var intValue = (int)value;

            if (intValue > 0) return 1;
            else if (intValue == 0) return 0;
            else return -1;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
