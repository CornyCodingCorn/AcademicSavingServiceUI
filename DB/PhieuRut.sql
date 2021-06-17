/*==================================================================================PROCEDURE=============================================================================*/
/*==================================================================================FUNCTIONS=============================================================================*/
/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS  AfterInsertPhieuRut;
DELIMITER $$
CREATE TRIGGER AfterInsertPhieuRut AFTER INSERT ON PHIEURUT FOR EACH ROW
BEGIN
    IF (EXISTS(SELECT * FROM PHIEURUT WHERE MaPhieu > NEW.MaPhieu)) THEN
        CALL ThrowException('FU003');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeInsertPhieuRut;
DELIMITER $$
CREATE TRIGGER BeforeInsertPhieuRut BEFORE INSERT ON PHIEURUT FOR EACH ROW
BEGIN
    DECLARE NgayTaoSo, LanCapNhatCuoi, NgayDongSo, NgayUpdate DATE;
    DECLARE SoDu, SoDuLanCapNhatCuoiSo, SoDuDung DECIMAL(15, 2);
    DECLARE MaKyHanSo , SIZE, KyHanSo INT;

	IF (NEW.NgayTao = '0/0/0') THEN SET NEW.NgayTao = NOW(); END IF;
    SELECT STK.NgayTao, STK.LanCapNhatCuoi, STK.NgayDongSo, STK.MaKyHan, STK.SoDuLanCapNhatCuoi, COUNT(*)
    INTO NgayTaoSo, LanCapNhatCuoi, NgayDongSo, MaKyHanSo, SoDuLanCapNhatCuoiSo, SIZE
    FROM SOTIETKIEM STK
    WHERE STK.MaSo = NEW.MaSo;

    IF (SIZE = 0 OR SIZE IS NULL) THEN
        CALL ThrowException('PH001');
    END IF;
    IF (NEW.NgayTao < NgayTaoSo) THEN
        CALL ThrowException('PH003');
    END IF;
    IF (New.NgayTao < LanCapNhatCuoi) THEN
        CALL ThrowException('PR005');
    END IF;

    CALL LaySoTienVoiNgay(NgayTaoSo, LanCapNhatCuoi, NgayDongSo, MaKyHanSo, NEW.MaSo, SoDuLanCapNhatCuoiSo, NEW.NgayTao, SoDuDung, NgayUpdate);
	SELECT KyHan INTO KyHanSo FROM LOAIKYHAN LKH WHERE LKH.MaKyHan = MaKyHanSo;
    IF (KyHanSo = 0) THEN
		IF (NEW.NgayTao < TIMESTAMPADD(DAY, LaySoNgayKhongKyHanNhoNhat(NgayTaoSo), NgayTaoSo)) THEN
			CALL ThrowException('PR001');
        END IF;
		IF (NEW.SoTien > SoDuDung) THEN
			CALL ThrowException('PR003');
		END IF;
    ELSE
		IF (NEW.NgayTao < TIMESTAMPADD(MONTH, KyHanSo, NgayTaoSo)) THEN
			CALL ThrowException('PR001');
        END IF;
        IF (NEW.SoTien != SoDuDung) THEN
			CALL ThrowException('PR002');
		END IF;
    END IF;

    SET NEW.LanCapNhatCuoiTruoc = LanCapNhatCuoi;
    SET NEW.SoDuTruoc = SoDuLanCapNhatCuoiSo;
    SET @SoDuLanCapNhatNay = SoDuDung - NEW.SoTien;
    IF (@SoDuLanCapNhatNay = 0 AND EXISTS (SELECT * FROM PHIEURUT PG WHERE PG.MaSo = NEW.MaSo AND PG.NgayTao > NEW.NgayTao)) THEN
        CALL ThrowException('PR006');
    END IF;

    CALL BatDauCapNhatSoTietKiem();
    UPDATE SOTIETKIEM
    SET SoDuLanCapNhatCuoi = (SoDuDung - NEW.SoTien), LanCapNhatCuoi = NEW.NgayTao
    WHERE MaSo = NEW.MaSo;
    CALL KetThucCapNhatSoTietKiem();
    CALL CapNhatBaoCaoNgayTaoPhieu(-NEW.SoTien, NEW.MaSo, NEW.NgayTao);
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeDeletePhieuRut;
DELIMITER $$
CREATE TRIGGER BeforeDeletePhieuRut BEFORE DELETE ON PHIEURUT FOR EACH ROW
BEGIN
	IF (NOT CanForceDelete()) THEN
		SELECT LanCapNhatCuoi INTO @LanCapNhatCuoi FROM SOTIETKIEM WHERE MaSo = OLD.MaSo;
		SET @ThrowException = @LanCapNhatCuoi > OLD.NgayTao;
		SET @ThrowException = @ThrowException OR OLD.MaPhieu != (SELECT MaPhieu FROM PHIEURUT WHERE OLD.NgayTao = NgayTao AND MaSo = OLD.MaSo ORDER BY MaPhieu DESC LIMIT 1);
		IF (@ThrowException = TRUE) THEN
			CALL ThrowException('PH002');
		ELSE
			CALL BatDauCapNhatSoTietKiem();
			UPDATE SOTIETKIEM 
			SET SoDuLanCapNhatCuoi = OLD.SoDuTruoc, LanCapNhatCuoi = OLD.LanCapNhatCuoiTruoc
			WHERE MaSo = OLD.MaSo;

			CALL LaySoTienVoiNgayQuery(OLD.MaSo, CURRENT_DATE(), @SoDuDung, @NgayUpate);
		    UPDATE SOTIETKIEM
			SET SoDu = @SoDuDung
			WHERE MaSo = OLD.MaSo;
			CALL KetThucCapNhatSoTietKiem();
		END IF;
		CALL CapNhatBaoCaoNgayXoaPhieu(-OLD.SoTien, OLD.MaSo, OLD.NgayTao);
	END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeUpdatePhieuRut;
DELIMITER $$
CREATE TRIGGER BeforeUpdatePhieuRut BEFORE UPDATE ON PHIEURUT FOR EACH ROW
BEGIN
	IF (NEW.MaPhieu != OLD.MaPhieu OR NEW.NgayTao != OLD.NgayTao OR NEW.MaSo != OLD.MaSo OR NEW.SoDuTruoc != OLD.SoDuTruoc OR NEW.LanCapNhatCuoiTruoc != OLD.LanCapNhatCuoiTruoc OR NEW.SoTien != OLD.SoTien) THEN
		CALL ThrowException('PH005');
	END IF;
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/