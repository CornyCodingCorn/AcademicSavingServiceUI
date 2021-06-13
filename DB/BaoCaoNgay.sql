/*==================================================================================PROCEDURE=============================================================================*/

DROP PROCEDURE IF EXISTS TongHopBaoCaoNgay;
DELIMITER $$
CREATE PROCEDURE TongHopBaoCaoNgay(IN NgayBaoCao DATE, IN KyHanBaoCao INT)
BEGIN
	DECLARE TongThu DECIMAL(15,2);
    DECLARE TongChi DECIMAL(15,2);
    DECLARE Counter INT;

	IF (NOT EXISTS(SELECT * FROM BAOCAONGAY WHERE Ngay = NgayBaoCao AND KyHan = KyHanBaoCao)) THEN
		DROP TEMPORARY TABLE IF EXISTS PHIEU;
		CREATE TEMPORARY TABLE PHIEU (
			MaPhieu INT NOT NULL AUTO_INCREMENT,
			NgayTao DATE NOT NULL DEFAULT '0/0/0',
			SoTien DECIMAL(15, 2) NOT NULL,
			GhiChu TEXT,
			MaSo INT NOT NULL,
			
			PRIMARY KEY(MaPhieu)
		) CHARACTER SET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
		
		INSERT INTO PHIEU(NgayTao, SoTien, GhiChu, MaSo) SELECT NgayTao, SoTien, GhiChu, MaSo FROM PHIEUGUI;
		INSERT INTO PHIEU(NgayTao, SoTien, GhiChu, MaSo) SELECT NgayTao, (-SoTien) AS SoTien, GhiChu, MaSo FROM PHIEURUT;
    
    	CALL BatDauCapNhatBaoCaoNgay();
		SELECT SUM(STK.SoTienBanDau) INTO @TongTienBanDau FROM SOTIETKIEM STK WHERE STK.NgayTao = NgayBaoCao AND (SELECT LKH.KyHan FROM LOAIKYHAN LKH WHERE LKH.MaKyHan = STK.MaKyHan) = KyHanBaoCao;
        SET TongThu = IF (@TongTienBanDau IS NULL, 0, @TongTienBanDau);
        
		SELECT COUNT(*) INTO @SizeRut FROM PHIEU PH WHERE PH.NgayTao = NgayBaoCao AND PH.SoTien < 0;
        SET TongChi = 0;
        SET Counter = 0;
        IF (KyHanBaoCao = 0) THEN
			SELECT SUM(SoTien) INTO @TienGui FROM PHIEU PH WHERE PH.NgayTao = NgayBaoCao AND PH.SoTien >= 0;
            SET TongThu = TongThu + IF (@TienGui IS NULL, 0, @TienGui);
			WHILE (Counter < @SizeRut) DO
				SELECT SoTien, MaSo INTO @SoTien, @MaSo FROM PHIEU PH WHERE PH.NgayTao = NgayBaoCao AND PH.SoTien < 0 LIMIT Counter, 1;
				SELECT LKH.KyHan, LKH.LaiSuat, STK.NgayTao, STK.SoTienBanDau INTO @KyHan, @LaiSuat, @NgayTao, @SoTienBanDau FROM SOTIETKIEM STK JOIN LOAIKYHAN LKH ON STK.MaKyHan = LKH.MaKyHan WHERE STK.MaSo = @MaSo;
				SET TongChi = TongChi + (- @SoTien - @SoTienBanDau * (1 + TIMESTAMPDIFF(DAY, @NgayTao, TIMESTAMPADD(MONTH, @KyHan, @NgayTao)) * @LaiSuat / 100 / 365));
                SET Counter = Counter + 1;
			END WHILE;
		ELSE
			WHILE (Counter < @SizeRut) DO
				SELECT SoTien, MaSo INTO @SoTien, @MaSo FROM PHIEU PH WHERE PH.NgayTao = NgayBaoCao AND PH.SoTien < 0 LIMIT Counter, 1;
				SELECT LKH.KyHan, LKH.LaiSuat, STK.NgayTao, STK.SoTienBanDau INTO @KyHan, @LaiSuat, @NgayTao, @SoTienBanDau FROM SOTIETKIEM STK JOIN LOAIKYHAN LKH ON STK.MaKyHan = LKH.MaKyHan WHERE STK.MaSo = @MaSo AND LKH.KyHan = KyHanBaoCao;
				SET TongChi = TongChi + @SoTienBanDau * (1 + TIMESTAMPDIFF(DAY, @NgayTao, TIMESTAMPADD(MONTH, @KyHan, @NgayTao)) * @LaiSuat / 100 / 365);
                SET Counter = Counter + 1;
			END WHILE;
        END IF;
        
        SET TongChi = IF (TongChi IS NULL, 0, TongChi);
        SET TongThu = IF (TongThu IS NULL, 0, TongThu);
        
        INSERT INTO BAOCAONGAY(Ngay, KyHan, TongThu, TongChi, ChenhLech) VALUES (NgayBaoCao, KyHanBaoCao, TongThu, TongChi, TongThu - TongChi);
        CALL KetThucCapNhatBaoCaoNgay();
        DROP TEMPORARY TABLE PHIEU;
    END IF;
END; 
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS CapNhatTienTrongBaoCao;
DELIMITER $$
CREATE PROCEDURE CapNhatTienTrongBaoCao(IN SoTien DECIMAL(15, 2), IN MaSo INT, IN NgayTao DATE)
BEGIN 
	IF (EXISTS (SELECT * FROM BAOCAONGAY WHERE Ngay = NgayTao)) THEN
    	CALL BatDauCapNhatBaoCaoNgay();
		SELECT LKH.KyHan, LKH.LaiSuat, STK.NgayTao, STK.SoTienBanDau INTO @KyHan, @LaiSuat, @NgayTao, @SoTienBanDau FROM SOTIETKIEM STK JOIN LOAIKYHAN LKH ON STK.MaKyHan = LKH.MaKyHan WHERE STK.MaSo = MaSo;
		IF (SoTien < 0) THEN
			UPDATE BAOCAONGAY SET TongChi = TongChi + (- SoTien - @SoTienBanDau * (1 + TIMESTAMPDIFF(DAY, @NgayTao, TIMESTAMPADD(MONTH, @KyHan, @NgayTao)) * @LaiSuat / 100 / 365)) WHERE Ngay = NgayTao AND KyHan = 0;
			UPDATE BAOCAONGAY SET TongChi = TongChi + (@SoTienBanDau * (1 + TIMESTAMPDIFF(DAY, @NgayTao, TIMESTAMPADD(MONTH, @KyHan, @NgayTao)) * @LaiSuat / 100 / 365))  WHERE Ngay = NgayTao AND KyHan = @KyHan;
		ELSE
			UPDATE BAOCAONGAY SET TongThu = TongThu + SoTien WHERE Ngay = NgayTao AND KyHan = 0;
		END IF;
		CALL KetThucCapNhatBaoCaoNgay();
    END IF;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS CapNhatBaoCaoNgayTaoPhieu;
DELIMITER $$
CREATE PROCEDURE CapNhatBaoCaoNgayTaoPhieu(IN SoTien DECIMAL(15, 2), IN MaSo INT, IN NgayTao DATE)
BEGIN 
	IF (EXISTS (SELECT * FROM BAOCAONGAY WHERE Ngay = NgayTao)) THEN
    	CALL BatDauCapNhatBaoCaoNgay();
		SELECT LKH.KyHan, LKH.LaiSuat, STK.NgayTao, STK.SoTienBanDau INTO @KyHan, @LaiSuat, @NgayTao, @SoTienBanDau FROM SOTIETKIEM STK JOIN LOAIKYHAN LKH ON STK.MaKyHan = LKH.MaKyHan WHERE STK.MaSo = MaSo;
		IF (SoTien < 0) THEN
			UPDATE BAOCAONGAY SET TongChi = TongChi + (- SoTien - @SoTienBanDau * (1 + TIMESTAMPDIFF(DAY, @NgayTao, TIMESTAMPADD(MONTH, @KyHan, @NgayTao)) * @LaiSuat / 100 / 365)) WHERE Ngay = NgayTao AND KyHan = 0;
			UPDATE BAOCAONGAY SET TongChi = TongChi + (@SoTienBanDau * (1 + TIMESTAMPDIFF(DAY, @NgayTao, TIMESTAMPADD(MONTH, @KyHan, @NgayTao)) * @LaiSuat / 100 / 365))  WHERE Ngay = NgayTao AND KyHan = @KyHan;
		ELSE
			UPDATE BAOCAONGAY SET TongThu = TongThu + SoTien WHERE Ngay = NgayTao AND KyHan = 0;
		END IF;
		CALL KetThucCapNhatBaoCaoNgay();
    END IF;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS CapNhatBaoCaoNgayXoaPhieu;
DELIMITER $$
CREATE PROCEDURE CapNhatBaoCaoNgayXoaPhieu(IN SoTien DECIMAL(15, 2), IN MaSo INT, IN NgayTao DATE)
BEGIN 
	IF (EXISTS (SELECT * FROM BAOCAONGAY WHERE Ngay = NgayTao)) THEN
    	CALL BatDauCapNhatBaoCaoNgay();
		SELECT LKH.KyHan, LKH.LaiSuat, STK.NgayTao, STK.SoTienBanDau INTO @KyHan, @LaiSuat, @NgayTao, @SoTienBanDau FROM SOTIETKIEM STK JOIN LOAIKYHAN LKH ON STK.MaKyHan = LKH.MaKyHan WHERE STK.MaSo = MaSo;
		IF (SoTien < 0) THEN
			UPDATE BAOCAONGAY SET TongChi = TongChi - (- SoTien - @SoTienBanDau * (1 + TIMESTAMPDIFF(DAY, @NgayTao, TIMESTAMPADD(MONTH, @KyHan, @NgayTao)) * @LaiSuat / 100 / 365)) WHERE Ngay = NgayTao AND KyHan = 0;
			UPDATE BAOCAONGAY SET TongChi = TongChi - (@SoTienBanDau * (1 + TIMESTAMPDIFF(DAY, @NgayTao, TIMESTAMPADD(MONTH, @KyHan, @NgayTao)) * @LaiSuat / 100 / 365))  WHERE Ngay = NgayTao AND KyHan = @KyHan;
		ELSE
			UPDATE BAOCAONGAY SET TongThu = TongThu - SoTien WHERE Ngay = NgayTao AND KyHan = 0;
		END IF;
		CALL KetThucCapNhatBaoCaoNgay();
    END IF;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS CapNhatBaoCaoNgayTaoSoTietKiem;
DELIMITER $$
CREATE PROCEDURE CapNhatBaoCaoNgayTaoSoTietKiem(IN SoTien DECIMAL(15, 2), IN NgayTao DATE, IN MaKyHan INT)
BEGIN
	CALL BatDauCapNhatBaoCaoNgay();
    UPDATE BAOCAONGAY
    SET TongThu = TongThu + SoTien
    WHERE Ngay = NgayTao AND KyHan = (SELECT KyHan FROM LOAIKYHAN LKH WHERE LKH.MaKyHan = MaKyHan LIMIT 1);
	CALL KetThucCapNhatBaoCaoNgay();
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS CapNhatBaoCaoNgayXoaSoTietKiem;
DELIMITER $$
CREATE PROCEDURE CapNhatBaoCaoNgayXoaSoTietKiem(IN SoTien DECIMAL(15, 2), IN NgayTao DATE, IN MaKyHan INT)
BEGIN
	CALL BatDauCapNhatBaoCaoNgay();
    UPDATE BAOCAONGAY
    SET TongThu = TongThu - SoTien
    WHERE Ngay = NgayTao AND KyHan = (SELECT KyHan FROM LOAIKYHAN LKH WHERE LKH.MaKyHan = MaKyHan LIMIT 1);
	CALL KetThucCapNhatBaoCaoNgay();
END;
$$
DELIMITER ;

/*==================================================================================FUNCTIONS=============================================================================*/
/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS BeforeInsertBaoCaoNgay;
DELIMITER $$
CREATE TRIGGER BeforeInsertBaoCaoNgay BEFORE INSERT ON BAOCAONGAY FOR EACH ROW
BEGIN
	SET NEW.ChenhLech = NEW.TongThu - NEW.TongChi;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeUpdateBaoCaoNgay;
DELIMITER $$
CREATE TRIGGER BeforeUpdateBaoCaoNgay BEFORE UPDATE ON BAOCAONGAY FOR EACH ROW
BEGIN
	IF (CoTheCapNhatBaoCaoNgay() = FALSE) THEN 
		CALL ThrowException('BC001');
    END IF;
	SET NEW.ChenhLech = NEW.TongThu - NEW.TongChi;
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/
