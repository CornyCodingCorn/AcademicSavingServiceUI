/*=================================================================================PROCEDURE=============================================================================*/

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

DROP PROCEDURE IF EXISTS ForceDeleteAllSoTietKiem;
DELIMITER $$
CREATE PROCEDURE ForceDeleteAllSoTietKiem()
BEGIN
	DECLARE i INT;
    SET i = 0;
    SELECT COUNT(*) INTO @Size FROM SOTIETKIEM;
    WHILE (i < @Size) DO
		CALL ForceDeleteSoTietKiem((SELECT MaSo FROM SOTIETKIEM LIMIT 1));
        SET i = i + 1;
    END WHILE;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS ForceDeleteSoTietKiem;
DELIMITER $$
CREATE PROCEDURE ForceDeleteSoTietKiem(IN MaSoDelete INT)
BEGIN
	CALL BatDauCapNhatSoTietKiem();
    UPDATE SOTIETKIEM STK SET STK.LanCapNhatCuoi = '0/0/0' WHERE STK.MaSo = MaSoDelete;
    CALL KetThucCapNhatSoTietKiem();
    
    CALL StartForceDelete();
    DELETE FROM PHIEUGUI PG WHERE PG.MaSo = MaSoDelete;
    DELETE FROM PHIEURUT PR WHERE PR.MaSo = MaSoDelete;
    DELETE FROM SOTIETKIEM STK WHERE STK.MaSo = MaSoDelete;
    CALL EndForceDelete();
END;
$$
DELIMITER ;

/*USED TO GET THE BALANCE WITHOUT UPDATE*/
DROP PROCEDURE IF EXISTS LaySoTienVoiNgay;
DELIMITER $$
CREATE PROCEDURE LaySoTienVoiNgay (IN NgayTao DATE, IN LanCapNhatCuoi DATE, IN NgayDongSo DATE, IN MaKyHan INT, IN SoDu DECIMAL(15, 2), IN SoDuLanCapNhatCuoi DECIMAL(15, 2), IN NgayCanUpdate DATE, OUT SoDuDung DECIMAL(15, 2), OUT NgayUpdate DATE)
BEGIN
	DECLARE _counter INT;
	DECLARE _ngayDaoHan DATE;
	DECLARE _kyHan INT;
  	SET _counter = 0;

	IF (NgayCanUpdate > CURRENT_DATE()) THEN
		CALL ThrowException('TK004');
	END IF;

	IF (NgayDongSo IS NULL) THEN
		IF (LanCapNhatCuoi >= NgayCanUpdate) THEN
			SET SoDuDung = SoDuLanCapNhatCuoi;
	        SET NgayUpdate = LanCapNhatCuoi;
		ELSEIF (NgayCanUpdate >= CURRENT_DATE() AND LanCapNhatCuoi IS NOT NULL) THEN
			SET SoDuDung = SoDU;
	        SET NgayUpdate = CURRENT_DATE();
		ELSE
		    SET LanCapNhatCuoi = IF (LanCapNhatCuoi IS NULL, NgayTao, LanCapNhatCuoi);
			SELECT KyHan INTO _kyHan FROM LOAIKYHAN LKH WHERE LKH.MaKyHan = MaKyHan;
			SET _ngayDaoHan = TIMESTAMPADD(MONTH, _kyHan, NgayTao);
	        SET SoDuDung = SoDuLanCapNhatCuoi;

	  		IF (NgayCanUpdate >= _ngayDaoHan) THEN
				IF (LanCapNhatCuoi < _ngayDaoHan) THEN
					SET @NgayUpdateToi = IF(NgayCanUpdate < _ngayDaoHan, NgayCanUpdate, _ngayDaoHan);
					SET @LaiSuat = (SELECT LaiSuat FROM LOAIKYHAN LKH WHERE MaKyHan = LKH.MaKyHan);
					SET SoDuDung = SoDuDung * (1 + (@LaiSuat / (100 * 365)) * TIMESTAMPDIFF(DAY, LanCapNhatCuoi, @NgayUpdateToi));
					SET LanCapNhatCuoi = @NgayUpdateToi;
				END IF;

				SET SoDuDung = SoDuDung * (1 + LayLaiSuatKhongKyHanTrongKhoangThoiGian(LanCapNhatCuoi, NgayCanUpdate));
	    		SELECT COUNT(*) INTO @Size FROM PHIEUGUI PG WHERE PG.NgayTao <= NgayCanUpdate AND PG.NgayTao > LanCapNhatCuoi;

	   			WHILE (_counter < @Size) DO
					SELECT PG.SoTien, PG.NgayTao INTO @SoTien, @NgayTao FROM PHIEUGUI PG WHERE  PG.NgayTao <= NgayCanUpdate AND PG.NgayTao > LanCapNhatCuoi ORDER BY MaPhieu LIMIT _counter, 1;
					SET SoDuDung = SoDuDung + (@SoTien * (1 + LayLaiSuatKhongKyHanTrongKhoangThoiGian(@NgayTao, NgayCanUpdate)));
					SET _counter = _counter + 1;
	    		END WHILE;

	    		SET LanCapNhatCuoi = NgayCanUpdate;
	  		END IF;
			SET NgayUpdate = LanCapNhatCuoi;
		END IF;
	ELSE
		SET SoDuDung = 0;
		SET NgayUpdate = NgayDongSo;
	END IF;
END;
$$
DELIMITER ;

/*QUERY AND GET THE BALANCE (CAN'T BE USE IN TRIGGERS OF STK)*/
DROP PROCEDURE IF EXISTS LaySoTienVoiNgayQuery;
DELIMITER $$
CREATE PROCEDURE LaySoTienVoiNgayQuery(IN MaSo INT, IN NgayCanUpdate DATE, OUT SoDuDung DECIMAL(15, 2), OUT NgayUpdate DATE)
BEGIN
    DECLARE NgayTao, LanCapNhatCuoi, NgayDongSo DATE;
    DECLARE SoDu, SoDuLanCapNhatCuoi DECIMAL(15, 2);
    DECLARE MaKyHan INT;

    SELECT STK.NgayTao, STK.LanCapNhatCuoi, STK.NgayDongSo, STK.MaKyHan, STK.SoDu, STK.SoDuLanCapNhatCuoi
    INTO NgayTao, LanCapNhatCuoi, NgayDongSo, MaKyHan, SoDu, SoDuLanCapNhatCuoi
    FROM SOTIETKIEM STK
    WHERE STK.MaSo = MaSo;

    IF (NgayTao IS NULL) THEN
        SET SoDuDung = NULL;
        SET NgayUpdate = NULL;
    ELSE
        CALL LaySoTienVoiNgay(NgayTao, LanCapNhatCuoi, NgayDongSo, MaKyHan, SoDu, SoDuLanCapNhatCuoi, NgayCanUpdate, SoDuDung, NgayUpdate);
    END IF;
END;
$$
DELIMITER ;

/*==================================================================================FUNCTIONS=============================================================================*/
/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS SoTietKiemBeforeUpdate;
DELIMITER $$
CREATE TRIGGER SoTietKiemBeforeUpdate BEFORE UPDATE ON SOTIETKIEM FOR EACH ROW
BEGIN
    DECLARE SoDuDung DECIMAL(15, 2);
    DECLARE NgayDung DATE;

	IF (NOT CoTheCapNhatSoTietKiem()) THEN
	    IF (NEW.MaSo != OLD.MaSo OR
	        NEW.SoDu != OLD.SoDu OR
	        NEW.SoDuLanCapNhatCuoi != OLD.SoDuLanCapNhatCuoi OR
	        NEW.LanCapNhatCuoi != OLD.LanCapNhatCuoi OR
	        NEW.NgayDongSo != OLD.NgayDongSo OR
	        NEW.MaKyHan != OLD.MaKyHan) THEN
		    CALL ThrowException('TK003');
        END IF;
    END IF;

	IF (NEW.SoTienBanDau != OLD.SoTienBanDau OR NEW.NgayTao != OLD.NgayDongSo) THEN
	    IF (EXISTS(SELECT * FROM PHIEURUT PR WHERE PR.MaSo = NEW.MaSo)) THEN
            CALL ThrowException('TK005');
        END IF;
        IF (NEW.SoTienBanDau < LaySoTienMoTaiKhoanNhoNhat(NEW.NgayTao)) THEN CALL ThrowException('TK001'); END IF;
	    IF (EXISTS(SELECT * FROM PHIEUGUI PG WHERE PG.MaSo = NEW.MaSo AND PG.NgayTao < NEW.NgayTao)) THEN
            CALL ThrowException('TK006');
        END IF;
    END IF;

	IF (NEW.SoDuLanCapNhatCuoi != OLD.SoDuLanCapNhatCuoi) THEN
        IF (NEW.SoDuLanCapNhatCuoi = 0) THEN
            SET NEW.SoDU = 0;
            SET NEW.NgayDongSo = NEW.LanCapNhatCuoi;
        ELSE
            SET NEW.NgayDongSo = NULL;
	        CALL LaySoTienVoiNgay(NEW.NgayTao, NEW.LanCapNhatCuoi,
	            NEW.NgayDongSo, NEW.MaKyHan, NEW.SoDu,
	            NEW.SoDuLanCapNhatCuoi, CURRENT_DATE(), SoDuDung, NgayDung);
            SET NEW.SoDu = SoDuDung;
        END IF;
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS SoTietKiemInsert;
DELIMITER $$
CREATE TRIGGER SoTietKiemInsert BEFORE INSERT ON SOTIETKIEM FOR EACH ROW
BEGIN
    DECLARE SoDuDung DECIMAL(15, 2);
    DECLARE NgayDung DATE;

	IF (NEW.NgayTao = '0/0/0') THEN SET NEW.NgayTao = NOW(); END IF;
	IF (NEW.SoTienBanDau < LaySoTienMoTaiKhoanNhoNhat(NEW.NgayTao)) THEN CALL ThrowException('TK001'); END IF;
    IF (KiemTraKyHan(NEW.MaKyHan, NEW.NgayTao) = FALSE) THEN
		CALL ThrowException('TK002');
	END IF; 
	SET NEW.SoDu = NEW.SoTienBanDau;
    SET NEW.SoDuLanCapNhatCuoi = NEW.SoTienBanDau;

	CALL LaySoTienVoiNgay(NEW.NgayTao, NEW.LanCapNhatCuoi,
	    NEW.NgayDongSo, NEW.MaKyHan, NEW.SoDu,
	    NEW.SoDuLanCapNhatCuoi, CURRENT_DATE(), SoDuDung, NgayDung);

	SET NEW.SoDU = SoDuDung;
    SET NEW.LanCapNhatCuoi = NEW.NgayTao;
    SET NEW.NgayDongSo = NULL;

    CALL CapNhatBaoCaoNgayTaoSoTietKiem(NEW.SoTienBanDau, NEW.NgayTao, NEW.MaKyHan);
    CALL CapNhatBaoCaoThangTaoSoTietKiem(NEW.NgayTao, NEW.MaKyHan, NEW.NgayDongSo);
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS SoTietKiemDelete;
DELIMITER $$
CREATE TRIGGER SoTietKiemDelete BEFORE DELETE ON SOTIETKIEM FOR EACH ROW
BEGIN
    CALL CapNhatBaoCaoNgayXoaSoTietKiem(OLD.SoTienBanDau, OLD.NgayTao, OLD.MaKyHan);
    CALL CapNhatBaoCaoThangXoaSoTietKiem(OLD.NgayTao, OLD.MaKyHan, OLD.NgayDongSo);
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/