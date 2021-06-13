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

    IF (SoTien >= 0) THEN
		INSERT INTO PHIEUGUI(MaSo, SoTien, MaUQ, MaNV, GhiChu, NgayTao) VALUES(MaSo, SoTien, @MaUQ, MaNV, GhiCHu, NgayTao);
	ELSE
		INSERT INTO PHIEURUT(MaSo, SoTien, MaUQ, MaNV, GhiChu, NgayTao) VALUES(MaSo, -SoTien, @MaUQ, MaNV, GhiCHu, NgayTao);
	END IF;
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
/*===================================================================================QUERRIES==============================================================================*/