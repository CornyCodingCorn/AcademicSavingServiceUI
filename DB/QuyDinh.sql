/*==================================================================================FUNCTIONS=============================================================================*/

DROP FUNCTION IF EXISTS LaySoTienNapNhoNhat;
DELIMITER $$
CREATE FUNCTION LaySoTienNapNhoNhat(NgayKiemTra DATE) RETURNS BIGINT
DETERMINISTIC 
BEGIN
	SELECT SoTienNapNhoNhat INTO @SoTien FROM QuyDinh WHERE NgayTao <= NgayKiemTra ORDER BY NgayTao DESC LIMIT 1;
	IF (@SoTien IS NULL) THEN
		CALL ThrowException('QD004');
    END IF;
	RETURN @SoTien;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS LaySoTienMoTaiKhoanNhoNhat;
DELIMITER $$
CREATE FUNCTION LaySoTienMoTaiKhoanNhoNhat(NgayKiemTra DATE) RETURNS BIGINT
DETERMINISTIC 
BEGIN
	SELECT SoTienNapNhoNhat INTO @SoTien FROM QuyDinh WHERE NgayTao <= NgayKiemTra ORDER BY NgayTao DESC LIMIT 1;
    IF (@SoTien IS NULL) THEN
		CALL ThrowException('QD004');
    END IF;
	RETURN @SoTien;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS LaySoNgayKhongKyHanNhoNhat;
DELIMITER $$
CREATE FUNCTION LaySoNgayKhongKyHanNhoNhat(NgayKiemTra DATE) RETURNS BIGINT
DETERMINISTIC 
BEGIN
	SELECT SoNgayToiThieu INTO @SoTien FROM QuyDinh WHERE NgayTao <= NgayKiemTra ORDER BY NgayTao DESC LIMIT 1;
	IF (@SoTien IS NULL) THEN
		CALL ThrowException('QD004');
    END IF;
	RETURN @SoTien;
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

DROP TRIGGER IF EXISTS AfterInsertQuyDinh;
DELIMITER $$
CREATE TRIGGER AfterInsertQuyDinh AFTER INSERT ON QUYDINH FOR EACH ROW
BEGIN
    IF (EXISTS(SELECT * FROM QUYDINH WHERE MaQD > NEW.MaQD)) THEN
        CALL ThrowException('FU004');
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
    SET Result = Result OR EXISTS(SELECT * FROM PHIEUGUI WHERE NgayTao >= OLD.NgayTao);
    SET Result = Result OR EXISTS(SELECT * FROM PHIEURUT WHERE NgayTao >= OLD.NgayTao);
    IF (Result = TRUE) THEN
		CALL ThrowException('QD002');
    END IF;
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/