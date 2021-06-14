using MySql.Data.MySqlClient;
using System.Collections.ObjectModel;

namespace AcademicSavingService.DataAccess
{
    public abstract class BaseDataAccess<T, t> : ICreateReadDelete<T, t> where T : INPC.BaseINPC
    {
        protected MySqlCommand cmd;

        protected abstract string _tableName { get; }

        public BaseDataAccess()
        {
            cmd = new MySqlCommand
            {
                Connection = BaseDBConnection.Connection
            };
        }

        public abstract void Create(T inpcObject);
        public abstract ObservableCollection<T> GetAll();
        public abstract void Delete(t key);
    }
}
