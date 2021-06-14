using System.Collections.ObjectModel;

namespace AcademicSavingService.Containers
{
    public abstract class BaseContainer<T, t> where T : INPC.BaseINPC
    {
        public ObservableCollection<T> Collection { get; set; }

        public abstract void AddToCollection(T item);
        public abstract void DeleteFromCollectionByDefaultKey(t field);
        public virtual void UpdateOnCollection(T item)
		{
            throw new System.NotImplementedException();
		}
        public abstract ObservableCollection<T> GetFromCollectionByDefaultKey(t field);
        public abstract int GetNextAutoID();
    }
}
