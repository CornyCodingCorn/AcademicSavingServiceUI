/*==================================================================================PROCEDURE=============================================================================*/

DROP PROCEDURE IF EXISTS ThemPhieu;
DELIMITER $$
CREATE PROCEDURE ThemPhieu(IN MaSo INT, IN SoTien DECIMAL(15, 2), IN GhiChu TEXT, IN NgayTao DATE)
BEGIN
	IF (NgayTao = '0/0/0') THEN
		SET NgayTao = NOW();
    END IF;

    IF (SoTien >= 0) THEN
		INSERT INTO PHIEUGUI(MaSo, SoTien, GhiChu, NgayTao) VALUES(MaSo, SoTien, GhiCHu, NgayTao);
	ELSE
		INSERT INTO PHIEURUT(MaSo, SoTien, GhiChu, NgayTao) VALUES(MaSo, -SoTien, GhiCHu, NgayTao);
	END IF;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS ThemPhieuVaReturn;
DELIMITER $$
CREATE PROCEDURE ThemPhieuVaReturn(IN MaSo INT, IN SoTien DECIMAL(15, 2), IN GhiChu TEXT, IN NgayTao DATE)
BEGIN 
	CALL ThemPhieu(MaSo, SoTien, GhiChu, NgayTao);
	SET @Str = 'SELECT * FROM ';
    IF (SoTien >= 0) THEN
		SET @Str = CONCAT(@Str, 'PHIEUGUI ORDER BY MaPhieu DESC LIMIT 0, 1');
	ELSE
		SET @Str = CONCAT(@Str, 'PHIEURUT ORDER BY MaPhieu DESC LIMIT 0, 1');
	END IF;
    PREPARE Stmt FROM @Str;
	EXECUTE Stmt;
    DEALLOCATE PREPARE Stmt;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS RutHetTien;
DELIMITER $$
CREATE PROCEDURE RutHetTien(IN MaSo INT, IN GhiChu TEXT, IN NgayTao DATE)
BEGIN
    DECLARE SoDuDung DECIMAL(15, 2);
    DECLARE NgayDung DATE;

    CALL LaySoTienVoiNgayQuery(MaSo, NgayTao, SoDuDung, NgayDung);
    CALL ThemPhieu(MaSo, -SoDuDung, GhiChu, NgayTao);
END;
$$
DELIMITER ;

/*==================================================================================FUNCTIONS=============================================================================*/
/*===================================================================================TRIGGERS==============================================================================*/
/*===================================================================================QUERRIES==============================================================================*/