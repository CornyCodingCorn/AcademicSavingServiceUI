/*==================================================================================FUNCTIONS=============================================================================*/

DROP FUNCTION IF EXISTS LaySoTienNapNhoNhat;
DELIMITER $$
CREATE FUNCTION LaySoTienNapNhoNhat(NgayKiemTra DATE) RETURNS BIGINT
DETERMINISTIC 
BEGIN
	RETURN (SELECT SoTienNapNhoNhat FROM QuyDinh WHERE NgayTao <= NgayKiemTra ORDER BY NgayTao DESC LIMIT 1);
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS LaySoTienMoTaiKhoanNhoNhat;
DELIMITER $$
CREATE FUNCTION LaySoTienMoTaiKhoanNhoNhat(NgayKiemTra DATE) RETURNS BIGINT
DETERMINISTIC 
BEGIN
	RETURN (SELECT SoTienNapNhoNhat FROM QuyDinh WHERE NgayTao <= NgayKiemTra ORDER BY NgayTao DESC LIMIT 1);
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS LaySoNgayKhongKyHanNhoNhat;
DELIMITER $$
CREATE FUNCTION LaySoNgayKhongKyHanNhoNhat(NgayKiemTra DATE) RETURNS BIGINT
DETERMINISTIC 
BEGIN
	RETURN (SELECT SoNgayToiThieu FROM QuyDinh WHERE NgayTao <= NgayKiemTra ORDER BY NgayTao DESC LIMIT 1);
END$$
DELIMITER ;

/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS AutofillQuyDinh;
DELIMITER $$
CREATE TRIGGER AutofillQuyDinh BEFORE INSERT ON QuyDinh FOR EACH ROW
BEGIN
	IF (NEW.NgayTao = '0/0/0') THEN
		SET NEW.NgayTao = NOW();
	END IF;
    IF (EXISTS (SELECT * FROM QUYDINH WHERE NgayTao > NEW.NgayTao)) THEN
		CALL ThrowException('QD003');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeUpdateQuyDinh;
DELIMITER $$
CREATE TRIGGER BeforeUpdateQuyDinh BEFORE UPDATE ON QUYDINH FOR EACH ROW
BEGIN
	CALL ThrowException('QD001');
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeDeleteQuyDinh;
DELIMITER $$
CREATE TRIGGER BeforeDeleteQuyDinh BEFORE DELETE ON QUYDINH FOR EACH ROW
BEGIN
	DECLARE Result BOOL;
    SET Result = EXISTS(SELECT * FROM SOTIETKIEM WHERE NgayTao >= OLD.NgayTao);
    SET Result = Result OR EXISTS(SELECT * FROM PHIEU WHERE NgayTao >= OLD.NgayTao);
    IF (Result = TRUE) THEN
		CALL ThrowException('QD002');
    END IF;
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/

DELETE FROM QUYDINH;

INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(100000, 1000000, 15, '2021/06/06');
INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(10000, 1000000, 10, '2021/06/04');
INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(90000, 900000, 14, '2021/06/07');
INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(90000, 900000, 14, '2020/02/07');

SELECT * FROM SOTIETKIEM WHERE NgayTao >= '2020/02/07';

SELECT * FROM QuyDinh;