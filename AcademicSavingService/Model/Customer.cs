using System;

namespace AcademicSavingService.Model
{
	public class Customer
	{
		public int MaKH { get; set; }
		public string HoTen { get; set; }
		public string CMND { get; set; }
		public string SDT { get; set; }
		public string DiaChi { get; set; }
		public DateTime NgayDangKy { get; set; }

		public Customer(int id, string name, string ctid, string phone, string address, DateTime registerDate)
		{
			MaKH = id;
			HoTen = name;
			CMND = ctid;
			SDT = phone;
			DiaChi = address;
			NgayDangKy = registerDate;
		}

		public Customer() { }
	}
}
