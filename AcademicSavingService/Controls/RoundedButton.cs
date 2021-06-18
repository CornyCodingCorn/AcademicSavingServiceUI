using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;

namespace AcademicSavingService.Controls
{
    public class RoundedButton : Button
    {
        public RoundedButton() : base()
		{
            Binding cornerWidth = new Binding();
            cornerWidth.Source = this;
            cornerWidth.Path = new PropertyPath("Width");
            cornerWidth.Mode = BindingMode.OneWay;
            cornerWidth.UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged;

            Style newStyle = new Style(typeof(Border));
            newStyle.Setters.Add(new Setter(Border.CornerRadiusProperty, cornerWidth));
            this.Resources.Add(typeof(Border), newStyle);
        }
    }
}
