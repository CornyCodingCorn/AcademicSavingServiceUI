using MySql.Data.MySqlClient;
using System.Collections.ObjectModel;

namespace AcademicSavingService.DataAccess
{
    public abstract class BaseDataAccess
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
    }
}
