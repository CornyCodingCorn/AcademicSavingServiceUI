-- Used to throw error like throw std::exception in C++ --
DROP PROCEDURE IF EXISTS ThrowException;
DELIMITER $$
CREATE PROCEDURE ThrowException (IN MaLoi VARCHAR(5))
BEGIN
 	SET @Message = CONCAT(MaLoi, ': ', LayGhiChuLoi(MaLoi));
	SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = @Message;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS ThrowMessage;
DELIMITER $$
CREATE PROCEDURE ThrowMessage (IN Note TEXT)
BEGIN
	SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = Note;
END;
$$
DELIMITER ;

/*===========================================================================SO TIET KIEM=======================================================================*/

DROP FUNCTION IF EXISTS CoTheCapNhatSoTietKiem;
DELIMITER $$
CREATE FUNCTION CoTheCapNhatSoTietKiem() RETURNS BOOL DETERMINISTIC
BEGIN
	RETURN (SELECT DangCapNhatSTK FROM GLOBALTABLE LIMIT 1);
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS BatDauCapNhatSoTietKiem;
DELIMITER $$
CREATE PROCEDURE BatDauCapNhatSoTietKiem()
BEGIN
	UPDATE GLOBALTABLE
    SET DangCapNhatSTK = TRUE;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS KetThucCapNhatSoTietKiem;
DELIMITER $$
CREATE PROCEDURE KetThucCapNhatSoTietKiem()
BEGIN
	UPDATE GLOBALTABLE
    SET DangCapNhatSTK = FALSE;
END;
$$
DELIMITER ;

/*===========================================================================LOAI KY HAN=======================================================================*/

DROP FUNCTION IF EXISTS CoTheCapNhatLoaiKyHan;
DELIMITER $$
CREATE FUNCTION CoTheCapNhatLoaiKyHan() RETURNS BOOL DETERMINISTIC
BEGIN
	RETURN (SELECT DangCapNhatLKH FROM GLOBALTABLE LIMIT 1);
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS BatDauCapNhatLoaiKyHan;
DELIMITER $$
CREATE PROCEDURE BatDauCapNhatLoaiKyHan()
BEGIN
	UPDATE GLOBALTABLE
    SET DangCapNhatLKH = TRUE;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS KetThucCapNhatLoaiKyHan;
DELIMITER $$
CREATE PROCEDURE KetThucCapNhatLoaiKyHan()
BEGIN
	UPDATE GLOBALTABLE
    SET DangCapNhatLKH = FALSE;
END;
$$
DELIMITER ;

/*===========================================================================BAO CAO NGAY=======================================================================*/

DROP FUNCTION IF EXISTS CoTheCapNhatBaoCaoNgay;
DELIMITER $$
CREATE FUNCTION CoTheCapNhatBaoCaoNgay() RETURNS BOOL DETERMINISTIC
BEGIN
	RETURN (SELECT DangCapNhatBCN FROM GLOBALTABLE LIMIT 1);
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS BatDauCapNhatBaoCaoNgay;
DELIMITER $$
CREATE PROCEDURE BatDauCapNhatBaoCaoNgay()
BEGIN
	UPDATE GLOBALTABLE
    SET DangCapNhatBCN = TRUE;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS KetThucCapNhatBaoCaoNgay;
DELIMITER $$
CREATE PROCEDURE KetThucCapNhatBaoCaoNgay()
BEGIN
	UPDATE GLOBALTABLE
    SET DangCapNhatBCN = FALSE;
END;
$$
DELIMITER ;

/*===========================================================================BAO CAO THANG=======================================================================*/

DROP FUNCTION IF EXISTS CoTheCapNhatBaoCaoThang;
DELIMITER $$
CREATE FUNCTION CoTheCapNhatBaoCaoThang() RETURNS BOOL DETERMINISTIC
BEGIN
	RETURN (SELECT DangCapNhatBCT FROM GLOBALTABLE LIMIT 1);
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS BatDauCapNhatBaoCaoThang;
DELIMITER $$
CREATE PROCEDURE BatDauCapNhatBaoCaoThang()
BEGIN
	UPDATE GLOBALTABLE
    SET DangCapNhatBCT = TRUE;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS KetThucCapNhatBaoCaoThang;
DELIMITER $$
CREATE PROCEDURE KetThucCapNhatBaoCaoThang()
BEGIN
	UPDATE GLOBALTABLE
    SET DangCapNhatBCT = FALSE;
END;
$$
DELIMITER ;

/*===========================================================================UY QUYEN=======================================================================*/

DROP FUNCTION IF EXISTS CoTheCapNhatUyQuyen;
DELIMITER $$
CREATE FUNCTION CoTheCapNhatUyQuyen() RETURNS BOOL DETERMINISTIC
BEGIN
	RETURN (SELECT DangCapNhatUQ FROM GLOBALTABLE LIMIT 1);
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS BatDauCapNhatUyQuyen;
DELIMITER $$
CREATE PROCEDURE BatDauCapNhatUyQuyen()
BEGIN
	UPDATE GLOBALTABLE
    SET DangCapNhatUQ = TRUE;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS KetThucCapNhatUyQuyen;
DELIMITER $$
CREATE PROCEDURE KetThucCapNhatUyQuyen()
BEGIN
	UPDATE GLOBALTABLE
    SET DangCapNhatUQ = FALSE;
END;
$$
DELIMITER ;

/*===========================================================================FOR DELETE=======================================================================*/

DROP FUNCTION IF EXISTS CanForceDelete;
DELIMITER $$
CREATE FUNCTION CanForceDelete() RETURNS BOOL DETERMINISTIC
BEGIN
	RETURN (SELECT ForceDelete FROM GLOBALTABLE LIMIT 1);
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS StartForceDelete;
DELIMITER $$
CREATE PROCEDURE StartForceDelete()
BEGIN
	UPDATE GLOBALTABLE
    SET ForceDelete = TRUE;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS EndForceDelete;
DELIMITER $$
CREATE PROCEDURE EndForceDelete()
BEGIN
	UPDATE GLOBALTABLE
    SET ForceDelete = FALSE;
END;
$$
DELIMITER ;