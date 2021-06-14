using System.Collections.ObjectModel;

namespace AcademicSavingService.Containers
{
    public abstract class BaseContainer<T, t> where T : INPC.BaseINPC
    {
        public ObservableCollection<T> Collection { get; set; }

        public abstract void AddToCollection(T item);
        public abstract void DeleteFromCollectionByDefaultKey(t field);
        public abstract ObservableCollection<T> GetFromCollectionByDefaultKey(t field);
    }
}
