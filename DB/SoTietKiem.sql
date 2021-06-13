/*=================================================================================PROCEDURE=============================================================================*/

DROP PROCEDURE IF EXISTS UpdateSoTietKiem;
DELIMITER $$
CREATE PROCEDURE UpdateSoTietKiem(IN MaSo INT, IN NgayCanUpdate DATE)
BEGIN
    SELECT LanCapNhatCuoi, NgayTao, MaKyHan, SoDu, MaKyHan, NgayDongSo INTO @LanCapNhatCuoi, @NgayTao, @MaKyHan, @SoDu, @MaKyHan, @NgayDongSo FROM SOTIETKIEM STK WHERE STK.MaSo = MaSo;
	IF (@NgayDongSo IS NULL) THEN
		IF (@LanCapNhatCuoi > NgayCanUpdate OR NgayCanUpdate > NOW()) THEN
			CALL ThrowException('TK004');
		ELSE
			SET @KyHan = (SELECT KyHan FROM LOAIKYHAN WHERE MaKyHan = @MaKyHan);
			SET @NgayDaoHan = TIMESTAMPADD(MONTH, @KyHan, @NgayTao);
			IF (@LanCapNhatCuoi < @NgayDaoHan) THEN
				SET @NgayUpdateToi = IF(NgayCanUpdate < @NgayDaoHan, NgayCanUpdate, @NgayDaoHan);
				SET @LaiSuat = (SELECT LaiSuat FROM LOAIKYHAN WHERE @MaKyHan = MaKyHan);
				SET @SoDu = @SoDu * (1 + @LaiSuat / 100 / 365 * TIMESTAMPDIFF(DAY, @LanCapNhatCuoi, @NgayUpdateToi));
				SET @LanCapNhatCuoi = @NgayUpdateToi;
			END IF;
			SET @SoDu = @SoDu * (1 + LayLaiSuatKhongKyHanTrongKhoangThoiGian(@LanCapNhatCuoi, NgayCanUpdate));
		END IF;
		CALL BatDauCapNhatSoTietKiem();
		UPDATE SOTIETKIEM STK
		SET STK.SoDU = @SoDu, STK.LanCapNhatCuoi = NgayCanUpdate
		WHERE STK.MaSo = MaSo;
		CALL KetThucCapNhatSoTietKiem();
	END IF;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS UpdateSoTietKiemVaReturn;
DELIMITER $$
CREATE PROCEDURE UpdateSoTietKiemVaReturn(IN MaSo INT, IN NgayCanUpdate DATE)
BEGIN
	CALL UpdateSoTietKiem(MaSo, NgayCanUpdate);
    SET @MaSo = MaSo;
    PREPARE Stmt FROM 'SELECT * FROM SOTIETKIEM WHERE MaSo = ?';
    EXECUTE Stmt USING @MaSo;
    DEALLOCATE PREPARE Stmt;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS ThemSoTietKiem;
DELIMITER $$
CREATE PROCEDURE ThemSoTietKiem(IN MaKH INT, IN KyHan TINYINT, IN SoTienBanDau DECIMAL(15, 2), IN NgayTao DATE)
BEGIN
	SELECT LKH.MaKyHan INTO @MaKyHan FROM LOAIKYHAN LKH WHERE LKH.KyHan = KyHan AND LKH.NgayTao <= NgayTao ORDER BY LKH.NgayTao DESC LIMIT 1;
    INSERT INTO SOTIETKIEM(MaKH, MaKyHan, NgayTao, SoTienBanDau) VALUES(MaKH, @MaKyHan, NgayTao, SoTienBanDau);
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS ThemSoTietKiemVaReturn;
DELIMITER $$
CREATE PROCEDURE ThemSoTietKiemVaReturn(IN MaKH INT, IN KyHan TINYINT, IN SoTienBanDau DECIMAL(15, 2), IN NgayTao DATE)
BEGIN
	CALL ThemSoTietKiem(MaKH, KyHan, SoTienBanDau, NgayTao);
    PREPARE Stmt FROM 'SELECT * FROM SOTIETKIEM ORDER BY MaSo DESC LIMIT 0, 1';
    EXECUTE Stmt;
    DEALLOCATE PREPARE Stmt;
END;
$$
DELIMITER ;

/*==================================================================================FUNCTIONS=============================================================================*/
/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS SoTietKiemBeforeUpdate;
DELIMITER $$
CREATE TRIGGER SoTietKiemBeforeUpdate BEFORE UPDATE ON SOTIETKIEM FOR EACH ROW
BEGIN
	IF (CoTheCapNhatSoTietKiem() = FALSE) THEN
		CALL ThrowException('TK003');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS SoTietKiemInsert;
DELIMITER $$
CREATE TRIGGER SoTietKiemInsert BEFORE INSERT ON SOTIETKIEM FOR EACH ROW
BEGIN
	IF (NEW.NgayTao = '0/0/0') THEN SET NEW.NgayTao = NOW(); END IF;
	IF (NEW.SoTienBanDau < LaySoTienMoTaiKhoanNhoNhat(NEW.NgayTao)) THEN CALL ThrowException('TK001'); END IF;
    IF (KiemTraKyHan(NEW.MaKyHan, NEW.NgayTao) = FALSE) THEN
		CALL ThrowException('TK002');
	END IF; 
	SET NEW.SoDu = NEW.SoTienBanDau;
    SET NEW.LanCapNhatCuoi = NEW.NgayTao;
    SET NEW.NgayDongSo = NULL;
    
    CALL CapNhatBaoCaoNgayTaoSoTietKiem(NEW.SoTienBanDau, NEW.NgayTao, NEW.MaKyHan);
    CALL CapNhatBaoCaoThangTaoSoTietKiem(NEW.NgayTao, NEW.MaKyHan);
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS SoTietKiemDelete;
DELIMITER $$
CREATE TRIGGER SoTietKiemDelete BEFORE DELETE ON SOTIETKIEM FOR EACH ROW
BEGIN
    CALL CapNhatBaoCaoNgayXoaSoTietKiem(OLD.SoTienBanDau, OLD.NgayTao, OLD.MaKyHan);
    CALL CapNhatBaoCaoThangXoaSoTietKiem(OLD.NgayDongSo, OLD.NgayDongSo, OLD.NgayDongSo);
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/