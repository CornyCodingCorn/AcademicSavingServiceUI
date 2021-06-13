/*==================================================================================PROCEDURE=============================================================================*/
/*==================================================================================FUNCTIONS=============================================================================*/
/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS BeforeInsertPhieuGui;
DELIMITER $$
CREATE TRIGGER BeforeInsertPhieuGui BEFORE INSERT ON PHIEUGUI FOR EACH ROW
BEGIN
	IF (NEW.NgayTao = '0/0/0') THEN SET NEW.NgayTao = NOW(); END IF;
    CALL UpdateSoTietKiem(NEW.MaSo, NEW.NgayTao);
    SELECT NgayTao, MaKyHan, SoDu, NgayDongSo, COUNT(*) INTO @NgayTao, @MaKyHan, @SoDu, @NgayDongSo, @Size FROM SOTIETKIEM WHERE MaSo = NEW.MaSo;
    
    IF (@Size = 0 OR @NgayDongSo IS NOT NULL) THEN CALL ThrowException('PH001'); END IF;
    IF (NEW.NgayTao < @NgayTao) THEN CALL ThrowException('PH003'); END IF;
    
    IF (NEW.NgayTao < TIMESTAMPADD(MONTH, @KyHan, @NgayTao)) THEN
		CALL ThrowException('PG003');
	END IF;
    IF (NEW.SoTien < LaySoTienNapNhoNhat(NEW.NgayTao)) THEN
		CALL ThrowException('PG001');
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

DROP TRIGGER IF EXISTS BeforeDeletePhieuGui;
DELIMITER $$
CREATE TRIGGER BeforeDeletePhieuGui BEFORE DELETE ON PHIEUGUI FOR EACH ROW
BEGIN
	IF (NOT CanForceDelete()) THEN
		SELECT LanCapNhatCuoi INTO @LanCapNhatCuoi FROM SOTIETKIEM WHERE MaSo = OLD.MaSo;
		SET @ThrowException = @LanCapNhatCuoi > OLD.NgayTao;
		SET @ThrowException = @ThrowException OR OLD.MaPhieu != (SELECT MaPhieu FROM PHIEUGUI WHERE OLD.NgayTao = NgayTao AND MaSo = OLD.MaSo ORDER BY MaPhieu DESC LIMIT 1);
		SET @ThrowException = @ThrowException OR OLD.MaPhieu != (SELECT MaPhieu FROM PHIEURUT WHERE OLD.NgayTao = NgayTao AND MaSo = OLD.MaSo ORDER BY MaPhieu DESC LIMIT 1);
		IF (@ThrowException = TRUE) THEN
			CALL ThrowException('PH002');
		ELSE
			CALL BatDauCapNhatSoTietKiem();
			UPDATE SOTIETKIEM 
			SET NgayDongSo =  IF (SoDu - OLD.SoTien = 0, OLD.NgayTao, NULL),SoDu = SoDu - OLD.SoTien
			WHERE MaSo = OLD.MaSo;
			CALL KetThucCapNhatSoTietKiem();
		END IF;
		CALL CapNhatBaoCaoNgayXoaPhieu(OLD.SoTien, OLD.MaSo, OLD.NgayTao);
	END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeUpdatePhieuGui;
DELIMITER $$
CREATE TRIGGER BeforeUpdatePhieuGui BEFORE UPDATE ON PHIEUGUI FOR EACH ROW
BEGIN
	CALL ThrowException('PH005');
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/