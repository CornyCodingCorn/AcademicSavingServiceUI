/*==================================================================================PROCEDURE=============================================================================*/

DROP PROCEDURE IF EXISTS ThemPhieu;
DELIMITER $$
CREATE PROCEDURE ThemPhieu(IN MaSo INT, IN SoTien DECIMAL(15, 2), IN MaKH INT, IN MaNV INT, IN GhiChu TEXT, IN NgayTao DATE)
BEGIN
	IF (NgayTao = '0/0/0') THEN
		SET NgayTao = NOW();
    END IF;

	SET @MaUQ = NULL;
	IF (MaKH != (SELECT MaKH FROM SOTIETKIEM STK WHERE STK.MaSo = MaSo)) THEN
		SELECT MaUQ INTO @MaUQ FROM UYQUYEN UQ WHERE UQ.MaKH = MaKH AND UQ.MaSo = MaSo AND UQ.NgayTao <= NgayTao AND (UQ.NgayNgungSuDung > NgayTao OR UQ.NgayNgungSuDung IS NULL);
		IF (MaUQ IS NULL) THEN
			CALL ThrowException('PH004');
        END IF;
    END IF;
    
    INSERT INTO PHIEU(MaSo, SoTien, MaUQ, MaNV, GhiChu, NgayTao) VALUES(MaSo, SoTien, @MaUQ, MaNV, GhiCHu, NgayTao);
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS RutHetTien;
DELIMITER $$
CREATE PROCEDURE RutHetTien(IN MaSo INT, IN MaKH INT, IN MaNV INT, IN GhiChu TEXT, IN NgayTao DATE)
BEGIN
	CALL UpdateSoTietKiem(MaSo, NgayTao);
    SELECT SoDu INTO @SoDu FROM SOTIETKIEM STK WHERE STK.MaSo = MaSo;
    CALL ThemPhieu(MaSo, -@SoDu, MaKH, MaNV, GhiChu, NgayTao);
END;
$$
DELIMITER ;

/*==================================================================================FUNCTIONS=============================================================================*/
/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS BeforeInsertPhieu;
DELIMITER $$
CREATE TRIGGER BeforeInsertPhieu BEFORE INSERT ON PHIEU FOR EACH ROW
BEGIN
	IF (NEW.MaUQ IS NOT NULL AND NOT EXISTS(SELECT * FROM UYQUYEN WHERE MaUQ = NEW.MaUQ AND MaSo = NEW.MaSo)) THEN
		CALL ThrowException('PH006');
    END IF;

	IF (NEW.NgayTao = '0/0/0') THEN SET NEW.NgayTao = NOW(); END IF;
    CALL UpdateSoTietKiem(NEW.MaSo, NEW.NgayTao);
    SELECT NgayTao, MaKyHan, SoDu, NgayDongSo, COUNT(*) INTO @NgayTao, @MaKyHan, @SoDu, @NgayDongSo, @Size FROM SOTIETKIEM WHERE MaSo = NEW.MaSo;
    
    IF (@Size = 0 OR @NgayDongSo IS NOT NULL) THEN CALL ThrowException('PH001'); END IF;
    IF (NEW.NgayTao < @NgayTao) THEN CALL ThrowException('PH003'); END IF;
    
    IF (NEW.SoTien < 0) THEN 
		SELECT KyHan INTO @KyHan FROM LOAIKYHAN WHERE MaKyHan = @MaKyHan;
        
        IF (@KyHan = 0) THEN
			IF (NEW.NgayTao < TIMESTAMPADD(DAY, LaySoNgayKhongKyHanNhoNhat(@NgayTao), @NgayTao)) THEN
				CALL ThrowException('PR001');
            END IF;
			IF (-NEW.SoTien > @SoDu) THEN
				CALL ThrowException('PR003');
			END IF;
        ELSE
			IF (NEW.NgayTao < TIMESTAMPADD(MONTH, @KyHan, @NgayTao)) THEN
				CALL ThrowException('PR001');
            END IF;
            IF (-NEW.SoTien != @SoDu) THEN
				CALL ThrowException('PR002');
			END IF;
        END IF;
    ELSE
    	IF (NEW.NgayTao < TIMESTAMPADD(MONTH, @KyHan, @NgayTao)) THEN
			CALL ThrowException('PR005');
		END IF;
        IF (NEW.SoTien < LaySoTienNapNhoNhat(NEW.NgayTao)) THEN
			CALL ThrowException('PG001');
        END IF;
    END IF;
    
    CALL BatDauCapNhatSoTietKiem();
    UPDATE SOTIETKIEM
    SET  NgayDongSo = IF (SoDu + NEW.SoTien = 0, NEW.NgayTao, NULL), SoDu = SoDu + NEW.SoTien
    WHERE MaSo = NEW.MaSo;
    CALL KetThucCapNhatSoTietKiem();
    CALL CapNhatBaoCaoNgayTaoPhieu(NEW.SoTien, NEW.MaSo, NEW.NgayTao);
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeDeletePhieu;
DELIMITER $$
CREATE TRIGGER BeforeDeletePhieu BEFORE DELETE ON PHIEU FOR EACH ROW
BEGIN
	SELECT LanCapNhatCuoi INTO @LanCapNhatCuoi FROM SOTIETKIEM WHERE MaSo = OLD.MaSo;
    IF (@LanCapNhatCuoi > OLD.NgayTao OR OLD.MaPhieu != (SELECT MaPhieu FROM PHIEU WHERE OLD.NgayTao = NgayTao AND MaSo = OLD.MaSo ORDER BY MaPhieu DESC LIMIT 1)) THEN
    	CALL ThrowException('PH002');
    ELSE
		CALL BatDauCapNhatSoTietKiem();
		UPDATE SOTIETKIEM 
        SET NgayDongSo =  IF (SoDu - OLD.SoTien = 0, OLD.NgayTao, NULL),SoDu = SoDu - OLD.SoTien
        WHERE MaSo = OLD.MaSo;
        CALL KetThucCapNhatSoTietKiem();
    END IF;
	CALL CapNhatBaoCaoNgayXoaPhieu(OLD.SoTien, OLD.MaSo, OLD.NgayTao);
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeUpdatePhieu
DELIMITER $$
CREATE TRIGGER BeforeUpdatePhieu BEFORE UPDATE ON PHIEU FOR EACH ROW
BEGIN
	CALL ThrowException('PH005');
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/

DELETE FROM PHIEU;

CALL ThemPhieu(29, 10000, 1, 2, 'Yeah send this to the prison', '2020/011/1');
CALL ThemPhieu(33, 10000, 2, 2, 'Yeah send this to the prison', '2021/06/10');
CALL ThemPhieu(28, 100000, 1, 2, 'Yeah send this to the prison', '2021/06/7');
CALL ThemPhieu(27, -100000, 1, 2, 'Yeah send this to the prison', '2021/05/15');
CALL RutHetTien(29, 1, 2, 'Yeah on second throught', '2021/06/07');
CALL ThemPhieu(27, 100000, 1, 2, 'Yeah send this to the prison', '2021/05/16');

DELETE FROM PHIEU WHERE MaPhieu = 14;

SELECT * FROM PHIEU;