using System;
using System.Collections.Generic;
using AcademicSavingService.INPC;
using System.IO;

namespace AcademicSavingService.Helpers
{
    public static class ExportToCSVHelper
    {
        public static void GenerateCSVFileForDailyReports(IEnumerable<DailyReportINPC> dailyReportIEnum, string savePath)
        {
            System.Data.DataTable dt = DailyReportIEnumerableToDataTable(dailyReportIEnum);

            dt.WriteToCSV(savePath);
        }

        public static void GenerateCSVFileForMonthlyReports(IEnumerable<MonthlyReportINPC> monthlyReportIEnum, string savePath)
        {
            System.Data.DataTable dt = MonthlyReportIEnumerableToDataTable(monthlyReportIEnum);

            dt.WriteToCSV(savePath);
        }

        private static void WriteToCSV(this System.Data.DataTable dt, string savePath)
        {
            StreamWriter sw = new(savePath, false);

            for (int i = 0; i < dt.Columns.Count; i++)
            {
                sw.Write(dt.Columns[i]);
                if (i < dt.Columns.Count - 1)
                {
                    sw.Write(",");
                }
            }

            sw.Write(sw.NewLine);

            foreach (System.Data.DataRow dr in dt.Rows)
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    if (!Convert.IsDBNull(dr[i]))
                    {
                        string value = dr[i].ToString();
                        if (value.Contains(','))
                        {
                            value = String.Format("\"{0}\"", value);
                            sw.Write(value);
                        }
                        else
                        {
                            sw.Write(dr[i].ToString());
                        }
                    }
                    if (i < dt.Columns.Count - 1)
                    {
                        sw.Write(",");
                    }
                }
                sw.Write(sw.NewLine);
            }
            sw.Close();
        }

        private static System.Data.DataTable DailyReportIEnumerableToDataTable(IEnumerable<DailyReportINPC> dailyReportIEnum)
        {
            System.Data.DataTable dt = new();

            dt.Columns.Add("Date");
            dt.Columns.Add("Term");
            dt.Columns.Add("Income");
            dt.Columns.Add("Outcome");
            dt.Columns.Add("Difference");

            foreach (DailyReportINPC report in dailyReportIEnum)
            {
                var newRow = dt.NewRow();
                newRow["Date"] = report.Ngay.ToString("dd/MM/yyyy");
                newRow["Term"] = report.KyHan;
                newRow["Income"] = report.TongThu;
                newRow["Outcome"] = report.TongChi;
                newRow["Difference"] = report.ChenhLech;

                dt.Rows.Add(newRow);
            }

            return dt;
        }

        private static System.Data.DataTable MonthlyReportIEnumerableToDataTable(IEnumerable<MonthlyReportINPC> monthlyReportIEnum)
        {
            System.Data.DataTable dt = new();

            dt.Columns.Add("Month");
            dt.Columns.Add("Year");
            dt.Columns.Add("Term");
            dt.Columns.Add("Opened accounts");
            dt.Columns.Add("Closed accounts");
            dt.Columns.Add("Difference");

            foreach (MonthlyReportINPC report in monthlyReportIEnum)
            {
                var newRow = dt.NewRow();
                newRow["Month"] = report.Thang;
                newRow["Year"] = report.Nam;
                newRow["Term"] = report.KyHan;
                newRow["Opened accounts"] = report.SoMo;
                newRow["Closed accounts"] = report.SoDong;
                newRow["Difference"] = report.ChenhLech;

                dt.Rows.Add(newRow);
            }

            return dt;
        }
    }
}
