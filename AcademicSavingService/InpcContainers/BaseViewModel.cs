using System.ComponentModel;
using PropertyChanged;

namespace AcademicSavingService.InpcContainers
{
    [AddINotifyPropertyChangedInterface]
    public abstract class BaseViewModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged = (sender, e) => { };
    }
}
