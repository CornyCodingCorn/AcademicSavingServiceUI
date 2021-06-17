using System;
using System.Globalization;
using System.Windows.Data;

namespace AcademicSavingService.Converters
{
    public class DecimalsToStringMultiConverter : IMultiValueConverter
    {
        public object Convert(object[] values, Type targetType, object parameter, CultureInfo culture)
        {
            try
            {
                var difference = (decimal)values[0] - (decimal)values[1];

                if (difference > 0) return "green";
                else if (difference < 0) return "red";
                else return "black";
            }
            catch { return "black"; }
        }

        public object[] ConvertBack(object value, Type[] targetTypes, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
