/*==================================================================================PROCEDURES=============================================================================*/

DROP PROCEDURE IF EXISTS NgungSuDungUyQuyen;
DELIMITER $$
CREATE PROCEDURE NgungSuDungUyQuyen (IN MaKH INT, IN MaSo INT, IN NgayNgungSuDung DATE)
BEGIN
	CALL BatDauCapNhatUyQuyen();
    UPDATE UYQUYEN UQ
    SET UQ.NgayNgungSuDung = NgayNgungSuDung
    WHERE UQ.MaKH = MaKH AND UQ.MaSo = MaSo AND UQ.NgayNgungSuDung IS NULL;
    CALL KetThucCapNhatUyQuyen();
END;
$$
DELIMITER ;

/*==================================================================================FUNCTIONS=============================================================================*/
/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS BeforeUpdateUyQuyen;
DELIMITER $$
CREATE TRIGGER BeforeUpdateUyQuyen BEFORE UPDATE ON UYQUYEN FOR EACH ROW
BEGIN
	IF (CoTheCapNhatUyQuyen() = FALSE) THEN
		CALL ThrowException('UQ001');
	END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeInsertUyQuyen;
DELIMITER $$
CREATE TRIGGER BeforeInsertUyQuyen BEFORE INSERT ON UYQUYEN FOR EACH ROW
BEGIN
    IF (EXISTS (SELECT * FROM UYQUYEN WHERE MaSo = NEW.MaSo AND MaKH = NEW.MaKH AND NgayTao >= NEW.NgayTao))THEN
		CALL ThrowException('UQ002');
    END IF;
    IF (EXISTS (SELECT * FROM UYQUYEN WHERE MaSo = NEW.MaSo AND MaKH = NEW.MaKH AND NgayTao < NEW.NgayTao AND (NgayNgungSuDung <= NEW.NgayTao OR NgayNgungSuDung IS NULL))) THEN
		CALL ThrowException('UQ001');
    END IF;
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/

SELECT * FROM UYQUYEN;
INSERT INTO UYQUYEN(MaKH, MaSo, NgayTao) VALUES(2, 33, '2020/12/2');
CALL NgungSuDungUyQuyen(2, 33, '2020/12/3');