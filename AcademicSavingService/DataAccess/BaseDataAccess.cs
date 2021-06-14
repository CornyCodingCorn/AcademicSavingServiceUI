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

        public int GetNextAutoID()
        {
            string q = $@"SELECT `AUTO_INCREMENT`
                        FROM INFORMATION_SCHEMA.TABLES
                        WHERE TABLE_SCHEMA = '{_databaseName}'
                        AND TABLE_NAME = '{_tableName}'";
            cmd.CommandText = q;
            cmd.Parameters.Clear();

            BaseDBConnection.OpenConnection();
            try
            {
                var result = cmd.ExecuteScalar();
                if (result != null)
                {
                    int nextID = System.Convert.ToInt32(result);
                    return nextID;
                }
                return -1;
            }
            catch { throw; }
            finally { BaseDBConnection.CloseConnection(); }
        }

        public abstract void Create(T inpcObject);
        public abstract ObservableCollection<T> GetAll();
        public abstract void Delete(t key);
        public virtual void Update(T key)
		{
            throw new System.NotImplementedException();
        }

        private const string _databaseName = "academicsavingservice";
    }
}
