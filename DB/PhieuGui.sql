/*==================================================================================PROCEDURE=============================================================================*/
/*==================================================================================FUNCTIONS=============================================================================*/
/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS  AfterInsertPhieuGui;
DELIMITER $$
CREATE TRIGGER AfterInsertPhieuGui AFTER INSERT ON PHIEUGUI FOR EACH ROW
BEGIN
    IF (EXISTS(SELECT * FROM PHIEUGUI WHERE MaPhieu > NEW.MaPhieu)) THEN
        CALL ThrowException('FU002');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeInsertPhieuGui;
DELIMITER $$
CREATE TRIGGER BeforeInsertPhieuGui BEFORE INSERT ON PHIEUGUI FOR EACH ROW
BEGIN
	IF (NEW.NgayTao = '0/0/0') THEN SET NEW.NgayTao = NOW(); END IF;
    SELECT NgayTao, MaKyHan, SoDu, NgayDongSo, LanCapNhatCuoi, COUNT(*) INTO @NgayTao, @MaKyHan, @SoDu, @NgayDongSo, @LanCapNhatCuoi, @Size FROM SOTIETKIEM WHERE MaSo = NEW.MaSo;
    
    IF (@Size = 0 OR @NgayDongSo IS NOT NULL) THEN CALL ThrowException('PH001'); END IF;
    IF (NEW.NgayTao < @NgayTao) THEN CALL ThrowException('PH003'); END IF;
    IF (NEW.NgayTao < @LanCapNhatCuoi) THEN CALL ThrowException('PG004'); END IF;
    
    IF (NEW.NgayTao < TIMESTAMPADD(MONTH, @KyHan, @NgayTao)) THEN
		CALL ThrowException('PG003');
	END IF;
    
    IF (NEW.SoTien < LaySoTienNapNhoNhat(NEW.NgayTao)) THEN
		CALL ThrowException('PG001');
    END IF;
    
    CALL BatDauCapNhatSoTietKiem();
    UPDATE SOTIETKIEM
    SET SoDu = SoDu + (NEW.SoTien * (1 + LayLaiSuatKhongKyHanTrongKhoangThoiGian(NEW.NgayTao, NOW())))
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
		IF (@ThrowException = TRUE) THEN
			CALL ThrowException('PH002');
		ELSE
			CALL BatDauCapNhatSoTietKiem();
			UPDATE SOTIETKIEM 
			SET SoDu = SoDu - (OLD.SoTien * (1 + LayLaiSuatKhongKyHanTrongKhoangThoiGian(OLD.NgayTao, NOW())))
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
    DECLARE NgayTaoSo DATE;
    DECLARE KyHanSo INT;

	IF (NEW.MaPhieu != OLD.MaPhieu OR NEW.MaSo != OLD.MaSo) THEN
		CALL ThrowException('PH005');
	END IF;

    IF ((NEW.SoTien != OLD.SoTien OR NEW.NgayTao != OLD.NgayTao) AND (SELECT LanCapNhatCuoi FROM SOTIETKIEM WHERE MaSo = NEW.MaSo) > NEW.NgayTao) THEN
		CALL ThrowException('PH005');
	ELSE
		IF (NEW.SoTien < LaySoTienNapNhoNhat(NEW.NgayTao)) THEN
			CALL ThrowException('PG001');
		END IF;
        SELECT STK.NgayTao, KyHan INTO NgayTaoSo, KyHanSo FROM SOTIETKIEM STK JOIN LOAIKYHAN LKH ON STK.MaKyHan = LKH.MaKyHan WHERE STK.MaSo = NEW.MaSo;
		IF (NgayTaoSo > NEW.NgayTao) THEN
            CALL ThrowException('PH003');
        END IF;
		IF (TIMESTAMPADD(MONTH, KyHanSo, NgayTaoSo) > NEW.NgayTao) THEN
            CALL ThrowException('PG003');
        END IF;

		CALL BatDauCapNhatSoTietKiem();
		UPDATE SOTIETKIEM 
		SET SoDu = SoDu - OLD.SoTien * (1 + LayLaiSuatKhongKyHanTrongKhoangThoiGian(OLD.NgayTao, NOW())) + NEW.SoTien * (1 + LayLaiSuatKhongKyHanTrongKhoangThoiGian(NEW.NgayTao, NOW()))
		WHERE MaSo = OLD.MaSo;
		CALL KetThucCapNhatSoTietKiem();
        
        CALL CapNhatBaoCaoNgayXoaPhieu(OLD.SoTien, OLD.MaSo, OLD.NgayTao);
		CALL CapNhatBaoCaoNgayTaoPhieu(NEW.SoTien, NEW.MaSo, NEW.NgayTao);
    END IF;
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/