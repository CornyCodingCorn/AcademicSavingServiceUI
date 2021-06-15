/*==================================================================================PROCEDURES=============================================================================*/

DROP PROCEDURE IF EXISTS TongHopBaoCaoThang;
DELIMITER $$
CREATE PROCEDURE TongHopBaoCaoThang(IN NgayBaoCao DATE, IN KyHanBaoCao INT)
BEGIN
	DECLARE TongSoMo INT;
    DECLARE TongSoDong INT;
    DECLARE ThangBaoCao INT;
    DECLARE NamBaoCao INT;
    SET TongSoMo = 0;
    SET TongSoDong = 0;
    SET ThangBaoCao = MONTH(NgayBaoCao);
    SET NamBaoCao = YEAR(NgayBaoCao);
    
    IF (NOT EXISTS(SELECT * FROM BAOCAOTHANG WHERE Thang = ThangBaoCao AND Nam = NamBaoCao AND KyHan = KyHanBaoCao)) THEN 
		SET TongSoMo = (SELECT COUNT(*) FROM SOTIETKIEM WHERE MONTH(NgayTao) = ThangBaoCao AND YEAR(NgayTao) = NamBaoCao);
        SET TongSoDong = (SELECT COUNT(*) FROM SOTIETKIEM WHERE MONTH(NgayDongSo) = ThangBaoCao AND YEAR(NgayDongSo) = NamBaoCao);
        
        SET TongSoMo = IF (TongSoMo IS NULL, 0, TongSoMo);
        SET TongSoDong = IF (TongSoDong IS NULL, 0, TongSoDong);
        
        INSERT INTO BAOCAOTHANG(Thang, Nam, KyHan, SoMo, SoDong) VALUES(ThangBaoCao, NamBaoCao, KyHanBaoCao, TongSoMo, TongSoDong);
    END IF;
END; 
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS CapNhatBaoCaoThangTaoSoTietKiem;
DELIMITER $$
CREATE PROCEDURE CapNhatBaoCaoThangTaoSoTietKiem(IN NgayTao DATE, IN MaKyHan INT, IN NgayDongSo DATE)
BEGIN
	SELECT KyHan INTO @KyHan FROM LOAIKYHAN LKH WHERE LKH.MaKyHan = MaKyHan LIMIT 1;
	CALL BatDauCapNhatBaoCaoThang();
    
    UPDATE BAOCAOTHANG
    SET SoMo = SoMo + 1
    WHERE Thang = MONTH(NgayTao) AND Nam = YEAR(NgayTao) AND KyHan = @KyHan;
    
	IF (NgayDongSo IS NOT NULL) THEN
		UPDATE BAOCAOTHANG
		SET SoDong = SoDong + 1
		WHERE Thang = MONTH(NgayDongSo) AND Nam = YEAR(NgayDongSo) AND KyHan = @KyHan;
	END IF;
    
	CALL KetThucCapNhatBaoCaoThang();
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS CapNhatBaoCaoThangXoaSoTietKiem;
DELIMITER $$
CREATE PROCEDURE CapNhatBaoCaoThangXoaSoTietKiem(IN NgayTao DATE, IN MaKyHan INT, IN NgayDongSo DATE)
BEGIN
	SELECT KyHan INTO @KyHan FROM LOAIKYHAN LKH WHERE LKH.MaKyHan = MaKyHan LIMIT 1;
	CALL BatDauCapNhatBaoCaoThang();
    
    UPDATE BAOCAOTHANG
    SET SoMo = SoMo - 1
    WHERE Thang = MONTH(NgayTao) AND Nam = YEAR(NgayTao) AND KyHan = @KyHan;
    
    IF (NgayDongSo IS NOT NULL) THEN
		UPDATE BAOCAOTHANG
		SET SoDong = SoDong - 1
		WHERE Thang = MONTH(NgayDongSo) AND Nam = YEAR(NgayDongSo) AND KyHan = @KyHan;
	END IF;
    
	CALL KetThucCapNhatBaoCaoThang();
END;
$$
DELIMITER ;


/*==================================================================================FUNCTIONS=============================================================================*/
/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS BeforeInsertBaoCaoThang;
DELIMITER $$
CREATE TRIGGER BeforeInsertBaoCaoThang BEFORE INSERT ON BAOCAOTHANG FOR EACH ROW
BEGIN
	SET NEW.ChenhLech = NEW.SoMo - NEW.SoDong;
END;
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeUpdateBaoCaoThang;
DELIMITER $$
CREATE TRIGGER BeforeUpdateBaoCaoThang BEFORE UPDATE ON BAOCAOTHANG FOR EACH ROW
BEGIN
	IF (CoTheCapNhatBaoCaoThang() = FALSE) THEN 
		CALL ThrowException('BC001');
    END IF;
	SET NEW.ChenhLech = NEW.SoMo - NEW.SoDong;
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/