using System.ComponentModel;
using AcademicSavingService.Controls;
using PropertyChanged;

namespace AcademicSavingService.INPC
{
    [AddINotifyPropertyChangedInterface]
    public abstract class BaseINPC : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged = (sender, e) => { };

        public static void ShowErrorMessage(string baseMessage)
		{
            string errorCode = "Warning";
            string message = baseMessage.Substring(baseMessage.Length);
            MessageBox.ShowMessage(errorCode, message);
        }
    }
}
