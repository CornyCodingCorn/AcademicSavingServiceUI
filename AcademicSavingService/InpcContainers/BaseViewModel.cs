using System.ComponentModel;
using AcademicSavingService.Controls;
using PropertyChanged;

namespace AcademicSavingService.InpcContainers
{
    [AddINotifyPropertyChangedInterface]
    public abstract class BaseViewModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged = (sender, e) => { };

        public static void ShowErrorMessage(string baseMessage)
		{
            string errorCode = baseMessage.Substring(0, 5);
            string message = baseMessage.Substring(5, baseMessage.Length - 5);
            MessageBox.ShowMessage(errorCode, message);
        }
    }
}
