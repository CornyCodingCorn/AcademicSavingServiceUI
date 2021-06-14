using System;
using System.Collections.ObjectModel;

namespace AcademicSavingService.DataAccess
{
    public interface ICreateReadDelete<T, t> where T : INPC.BaseINPC
    {
        void Create(T inpcObject);
        ObservableCollection<T> GetAll();
        void Delete(t key);
    }
}
