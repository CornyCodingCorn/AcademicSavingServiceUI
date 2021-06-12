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
    DECLARE LaiSuatHienTai FLOAT;
    DECLARE TongLaiSuat FLOAT;
    DECLARE NgayHienTai DATE;

	IF (NgayBatDau >= NgayKetThuc) THEN RETURN 0; END IF;
    SET LaiSuatHienTai = (SELECT LaiSuat FROM LOAIKYHAN WHERE NgayTao <= NgayBatDau AND KyHan = 0 ORDER BY NgayTao DESC LIMIT 1);
    SELECT COUNT(*) INTO @Size FROM LOAIKYHAN WHERE NgayTao > NgayBatDau AND KyHan = 0 AND NgayTao <= NgayKetThuc;
    
    IF (LaiSuatHienTai IS NULL) THEN
		SET LaiSuatHienTai = 0;
    END IF;
    
    SET TongLaiSuat = 0;
    SET NgayHienTai = NgayBatDau;
    SET Counter = 0;
    WHILE (Counter < @Size) DO
		SELECT LaiSuat, NgayTao INTO @LaiSuatTrongTuongLai, @NgayTuongLai FROM LOAIKYHAN WHERE  NgayTao > NgayBatDau AND KyHan = 0 AND NgayTao <= NgayKetThuc LIMIT Counter, 1;
        SET TongLaiSuat = TongLaiSuat + (LaiSuatHienTai / 365 / 100 * TIMESTAMPDIFF(DAY, NgayHienTai, @NgayTuongLai));
        SET LaiSuatHienTai = @LaiSuatTrongTuongLai;
        SET NgayHienTai = @NgayTuongLai;
        SET Counter = Counter + 1;
    END WHILE;
    SET TongLaiSuat = TongLaiSuat + (LaiSuatHienTai / 365 / 100 * TIMESTAMPDIFF(DAY, NgayHienTai, NgayKetThuc));
    RETURN TongLaiSuat;
END;
$$
DELIMITER ;

/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS LoaiKyHanBeforeInsert;
DELIMITER $$
CREATE TRIGGER LoaiKyHanBeforeInsert BEFORE INSERT ON LOAIKYHAN FOR EACH ROW
BEGIN
	IF (NEW.KyHan = 0 AND NEW.NgayNgungSuDung IS NOT NULL) THEN
     CALL ThrowException('KY001');
    END IF;
	SET @Result = EXISTS (SELECT * FROM LOAIKYHAN WHERE KyHan = NEW.KyHan AND NgayTao > NEW.NgayTao);
    SET @Result = @Result OR EXISTS (SELECT * FROM LOAIKYHAN WHERE KyHan = NEW.KyHan AND (NgayNgungSuDung IS NULL OR NgayNgungSuDung > NEW.NgayTao));
	IF (@Result) THEN
		CALL ThrowException('KY002');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS LoaiKyHanBeforeUpdate;
DELIMITER $$
CREATE TRIGGER LoaiKyHanBeforeUpdate BEFORE UPDATE ON LOAIKYHAN FOR EACH ROW
BEGIN
	IF (CoTheCapNhatLoaiKyHan() = FALSE) THEN
		CALL ThrowException('KY004');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS LoaiKyHanBeforeDelete;
DELIMITER $$
CREATE TRIGGER LoaiKyHanBeforeDelete BEFORE DELETE ON LOAIKYHAN FOR EACH ROW
BEGIN
	SET @Result = EXISTS (SELECT * FROM SOTIETKIEM WHERE NgayTao >= OLD.NgayTao);
    IF (@Result) THEN
    	CALL ThrowException('KY003');
    END IF;
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/

DELETE FROM LoaiKyHan;

INSERT INTO LoaiKyHan (KyHan, LaiSuat)
VALUES(0, 1.1);

CALL ThemKyHan(6, 5, '2020/01/01', '2021/02/03');
CALL ThemKyHan(6, 5, '2021/04/01', '2021/08/03');
CALL ThemKyHan(3, 5, '2021/01/01', '2021/02/03');
CALL ThemKyHan(0, 1.1, '2021/01/07', NULL);
CALL ThemKyHan(0, 2.2, '2021/02/07', NULL);
CALL ThemKyHan(0, 3.3, '2021/03/07', NULL);
CALL ThemKyHan(0, 4.5, '2021/05/07', NULL);

SELECT * FROM LoaiKyHan;