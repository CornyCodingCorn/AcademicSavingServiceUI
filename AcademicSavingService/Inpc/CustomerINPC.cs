using System;

namespace AcademicSavingService.INPC
{
	public class CustomerINPC : BaseINPC
	{
		public int MaKH { get; set; }
		public string HoTen { get; set; }
		public string CMND { get; set; }
		public string SDT { get; set; }
		public string DiaChi { get; set; }
		public DateTime NgayDangKy { get; set; }

		public CustomerINPC(int id, string name, string ctid, string phone, string address, DateTime registerDate)
		{
			MaKH = id;
			HoTen = name;
			CMND = ctid;
			SDT = phone;
			DiaChi = address;
			NgayDangKy = registerDate;
		}

		public CustomerINPC() { }
	}
}
