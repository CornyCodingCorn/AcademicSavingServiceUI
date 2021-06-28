using MySql.Data.MySqlClient;

namespace AcademicSavingService.DataAccess
{
    // pending changes
    public static class BaseDBConnection
    {
        #region Private fields

        private static MySqlConnection _connection;
        private static string _connectionString = "Server=127.0.0.1;Database=academicsavingservice;Uid=root;Pwd=Password123!";

        private static int _connectionAttemptCount = 0;

        #endregion

        #region Public prop

        public static MySqlConnection Connection => _connection;

        #endregion

        static BaseDBConnection()
        {
            _connection = new MySqlConnection(_connectionString);
        }

        public static void OpenConnection()
        {
            if (_connection.State != System.Data.ConnectionState.Open)
            {
                _connection.Open();
            }
            _connectionAttemptCount++;
        }

        public static void CloseConnection()
        {
            if (_connection.State != System.Data.ConnectionState.Closed)
            {
                _connectionAttemptCount--;
                if (_connectionAttemptCount == 0)
                {
                    _connection.Close();
                }
            }
        }
    }
}
