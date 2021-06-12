/*==================================================================================FUNCTIONS=============================================================================*/
/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS BeforeUpdateNhanVien;
DELIMITER $$
CREATE TRIGGER BeforeUpdateNhanVien BEFORE UPDATE ON NHANVIEN FOR EACH ROW
BEGIN
	IF (NEW.NoiLamViec != OLD.NoiLamViec) THEN
    
    END IF;
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/

INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Phuc Nguyen', '093840000', 'Quan 7 Ho Chi Minh', '000000001', '2001/01/01', 1);

INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Do Phi Long', '094206900', 'Quan 8 Ho Chi Minh', '000000022', '2012/01/02', 2);

INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Nguyen Bao Duy', '093840000', 'Quan 9 Ho Chi Minh', '0000211001', '2000/02/29', 3);

SELECT * FROM NHANVIEN;