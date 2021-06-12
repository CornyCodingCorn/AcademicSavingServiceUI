/*==================================================================================FUNCTIONS=============================================================================*/
/*===================================================================================TRIGGERS==============================================================================*/

DELIMITER $$
DROP TRIGGER IF EXISTS KhachHangInsertTrigger;
CREATE TRIGGER KhachHangInsertTrigger BEFORE INSERT
ON KhachHang FOR EACH ROW
BEGIN
	IF (NEW.NgayDangKy = '0/0/0') THEN
    	SET NEW.NgayDangKy = CURRENT_DATE;
    END IF;
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/

INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Pham Phuc Nguyen', '093840000', 'Quan 7 Ho Chi Minh', '000000001', 1);

INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Do Phi Long', '094206900', 'Quan 8 Ho Chi Minh', '000000022', 1);

INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Nguyen Bao Duy', '093840000', 'Quan 9 Ho Chi Minh', '0000211001', 3);

SELECT * FROM KHACHHANG;