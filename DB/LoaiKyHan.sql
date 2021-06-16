/*=================================================================================PROCEDURES=============================================================================*/

DROP PROCEDURE IF EXISTS NgungSuDungKyHan;
DELIMITER $$
CREATE PROCEDURE NgungSuDungKyHan(IN KyHanNgungSuDung TINYINT, IN NgayNgungSuDungMoi DATE)
BEGIN
	CALL BatDauCapNhatLoaiKyHan();
	UPDATE LoaiKyHan
    SET NgayNgungSuDung = NgayNgungSuDungMoi
    WHERE KyHan = KyHanNgungSuDung AND NgayNgungSuDung IS NULL;
    CALL KetThucCapNhatLoaiKyHan();
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS ThemKyHan;
DELIMITER $$
CREATE PROCEDURE ThemKyHan(IN KyHan TINYINT, IN LaiSuat FLOAT, IN NgayTao DATE, IN NgayNgungSuDung DATE)
BEGIN
	IF (NgayTao = '0/0/0') THEN
		SET NgayTao = NOW();
	END IF;
	IF ((SELECT LKH.NgayTao FROM LoaiKyHan LKH WHERE LKH.KyHan = KyHan ORDER BY LKH.NgayTao DESC LIMIT 1) < NgayTao) THEN
		CALL NgungSuDungKyHan(KyHan, NgayTao);
    END IF;
	INSERT INTO LoaiKyHan (KyHan, LaiSuat, NgayTao, NgayNgungSuDung) VALUES(KyHan, LaiSuat, NgayTao, NgayNgungSuDung);
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS LayKyHanVaLaiSuat;
DELIMITER $$
CREATE PROCEDURE LayKyHanVaLaiSuat(IN NgayKiemTra DATE)
BEGIN
	PREPARE QueryStr FROM 'SELECT LKH.KyHan, LaiSuat FROM LOAIKYHAN LKH JOIN (SELECT MAX(MaKyHan) AS MaKyHan FROM LOAIKYHAN LKH2 WHERE NgayTao <= ? AND NgayNgungSuDung > ? GROUP BY KyHan) KQ ON LKH.MaKyHan = KQ.MaKyHan;';
	SET @NgayKiemTra = NgayKiemTra;
	EXECUTE QueryStr USING @NgayKiemTra, @NgayKiemTra;
    DEALLOCATE PREPARE QueryStr;
END;
$$
DELIMITER ;

/*==================================================================================FUNCTIONS=============================================================================*/

DROP FUNCTION IF EXISTS LayLaiSuatPhuHopCuaKyHan;
DELIMITER $$
CREATE FUNCTION LayLaiSuatPhuHopCuaKyHan(KyHanCanTim INT, NgayCanTim DATE) RETURNS FLOAT DETERMINISTIC
BEGIN
	RETURN (SELECT MaKyHan FROM LOAIKYHAN WHERE KyHan = KyHanCanTim AND NgayTao <= NgayCanTim AND (NgayNgungSuDung IS NULL OR NgayNgungSuDung > NgayCanTim) ORDER BY NgayTao DESC LIMIT 1);
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS LaiSuatKhongKyHan;
DELIMITER $$
CREATE FUNCTION LaiSuatKhongKyHan() RETURNS FLOAT
DETERMINISTIC
BEGIN
	SELECT LaiSuat INTO @LaiSuat FROM LoaiKyHan WHERE KyHan = 0 LIMIT 1;
    RETURN @LaiSuat;
END
$$
DELIMITER ;

DROP FUNCTION IF EXISTS KiemTraKyHan;
DELIMITER $$
CREATE FUNCTION KiemTraKyHan(TimKyHan INT, NgayTim DATE) RETURNS BOOL
DETERMINISTIC
BEGIN
	SELECT NgayNgungSuDung, NgayTao INTO @NgayNgungSuDung, @NgayTao FROM LoaiKyHan WHERE MaKyHan = TimKyHan AND NgayTao <= NgayTim ORDER BY NgayTao DESC LIMIT 1;
    IF (@NgayTao > NgayTim) THEN
		RETURN FALSE;
	ELSEIF (@NgayNgungSuDung IS NULL OR @NgayNgungSuDung > NgayTim) THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS LayLaiSuatKhongKyHanTrongKhoangThoiGian;
DELIMITER $$
CREATE FUNCTION LayLaiSuatKhongKyHanTrongKhoangThoiGian(NgayBatDau DATE, NgayKetThuc DATE) RETURNS FLOAT DETERMINISTIC
BEGIN
	DECLARE Counter INT;
    DECLARE _laiSuatHienTai FLOAT;
    DECLARE _tongLaiSuat FLOAT;
    DECLARE _ngayHienTai DATE;
    DECLARE _ngayTuongLai DATE;
    DECLARE _laiSuatTrongTuongLai FLOAT;

	IF (NgayBatDau >= NgayKetThuc) THEN RETURN 0; END IF;
    SET _laiSuatHienTai = (SELECT LaiSuat FROM LOAIKYHAN WHERE NgayTao <= NgayBatDau AND KyHan = 0 ORDER BY NgayTao DESC LIMIT 1);
    SELECT COUNT(*) INTO @Size FROM LOAIKYHAN WHERE NgayTao > NgayBatDau AND KyHan = 0 AND NgayTao <= NgayKetThuc;
    
    IF (_laiSuatHienTai IS NULL) THEN
		SET _laiSuatHienTai = 0;
    END IF;
    
    SET _tongLaiSuat = 0;
    SET _ngayHienTai = NgayBatDau;
    SET Counter = 0;
    WHILE (Counter < @Size) DO
		SELECT LaiSuat, NgayTao INTO _laiSuatTrongTuongLai, _ngayTuongLai FROM LOAIKYHAN WHERE  NgayTao > NgayBatDau AND KyHan = 0 AND NgayTao <= NgayKetThuc LIMIT Counter, 1;
        SET _tongLaiSuat = _tongLaiSuat + ((_laiSuatHienTai / (365 * 100)) * TIMESTAMPDIFF(DAY, _ngayHienTai, _ngayTuongLai));
        SET _laiSuatHienTai = _laiSuatTrongTuongLai;
        SET _ngayHienTai = _ngayTuongLai;
        SET Counter = Counter + 1;
    END WHILE;
    SET _tongLaiSuat = _tongLaiSuat + ((_laiSuatHienTai / (365 * 100)) * TIMESTAMPDIFF(DAY, _ngayHienTai, NgayKetThuc));
    RETURN _tongLaiSuat;
END;
$$
DELIMITER ;

/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS LoaiKyHanAfterInsert;
DELIMITER $$
CREATE TRIGGER LoaiKyHanAfterInsert AFTER INSERT ON LOAIKYHAN FOR EACH ROW
BEGIN
    IF (EXISTS(SELECT * FROM LOAIKYHAN WHERE MaKyHan > NEW.MaKyHan)) THEN
        CALL ThrowException('FU005');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS LoaiKyHanBeforeInsert;
DELIMITER $$
CREATE TRIGGER LoaiKyHanBeforeInsert BEFORE INSERT ON LOAIKYHAN FOR EACH ROW
BEGIN
    DECLARE  _throwException BOOL;
    DECLARE  _ngayNgungSuDung DATE;
    SET _throwException = FALSE;

	IF (NEW.KyHan = 0) THEN
	    IF (NEW.NgayNgungSuDung IS NOT NULL) THEN
            CALL ThrowException('KY001');
        ELSE
            SELECT NgayNgungSuDung INTO _ngayNgungSuDung FROM LOAIKYHAN WHERE KyHan = 0 AND NgayTao <= NEW.NgayTao ORDER BY MaKyHan DESC LIMIT 1;
            IF (_ngayNgungSuDung IS NOT NULL AND _ngayNgungSuDung != NEW.NgayTao) THEN
                CALL ThrowException('KY001');
            END IF;
	    END IF;
    END IF;
	SET _throwException = EXISTS (SELECT * FROM LOAIKYHAN WHERE KyHan = NEW.KyHan AND NgayTao > NEW.NgayTao);
    SET _throwException = _throwException OR EXISTS (SELECT * FROM LOAIKYHAN WHERE KyHan = NEW.KyHan AND (NgayNgungSuDung IS NULL OR NgayNgungSuDung > NEW.NgayTao));
	IF (_throwException) THEN
		CALL ThrowException('KY002');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS LoaiKyHanBeforeUpdate;
DELIMITER $$
CREATE TRIGGER LoaiKyHanBeforeUpdate BEFORE UPDATE ON LOAIKYHAN FOR EACH ROW
BEGIN
	IF (NOT CoTheCapNhatLoaiKyHan() AND (NEW.MaKyHan != OLD.MaKyHan OR NEW.NgayTao != OLD.NgayTao OR NEW.KyHan != OLD.KyHan)) THEN
		CALL ThrowException('KY004');
    END IF;
    IF (NEW.LaiSuat != OLD.LaiSuat AND EXISTS(SELECT * FROM SOTIETKIEM STK WHERE STK.MaKyHan = NEW.MaKyHan)) THEN
        CALL ThrowException('KY005');
    END IF;
	IF (NEW.NgayNgungSuDung != OLD.NgayNgungSuDung AND EXISTS(SELECT * FROM SOTIETKIEM STK WHERE STK.MaKyHan = NEW.MaKyHan AND STK.NgayTao >= OLD.NgayNgungSuDung)) THEN
        CALL ThrowException('KY006');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS LoaiKyHanBeforeDelete;
DELIMITER $$
CREATE TRIGGER LoaiKyHanBeforeDelete BEFORE DELETE ON LOAIKYHAN FOR EACH ROW
BEGIN
    DECLARE _errorCode TEXT;
    SET _errorCode = '';

    IF (OLD.KyHan = 0) THEN
        IF (EXISTS (SELECT * FROM SOTIETKIEM WHERE NgayTao >= OLD.NgayTao)) THEN
    	    CALL ThrowException('KY003');
        END IF;
    END IF;
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/