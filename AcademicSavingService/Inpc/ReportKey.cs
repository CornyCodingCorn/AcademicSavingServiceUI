using System;

namespace AcademicSavingService.INPC
{
    public class ReportKey
    {
        public DateTime? Date;
        public int Month;
        public int Year;

        public ReportKey() { }
        public ReportKey(DateTime date, int month, int year)
        {
            Date = date;
            Month = month;
            Year = year;
        }
    }
}
