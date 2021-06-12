DROP PROCEDURE IF EXISTS DeleteAllRow_SoTietKiem;
DELIMITER $$
CREATE PROCEDURE DeleteAllRow_SoTietKiem()
BEGIN
	DELETE FROM SoTietKiem WHERE MaSo > 0;
    ALTER TABLE SoTietKiem AUTO_INCREMENT = 1;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS DeleteAllRow_KhachHang;
DELIMITER $$
CREATE PROCEDURE DeleteAllRow_KhachHang()
BEGIN
	DELETE FROM KhachHang WHERE MaSo > 0;
    ALTER TABLE KhachHang AUTO_INCREMENT = 1;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS DeleteAllRow_Phieu;
DELIMITER $$
CREATE PROCEDURE DeleteAllRow_Phieu()
BEGIN
	DELETE FROM Phieu WHERE MaSo > 0;
    ALTER TABLE Phieu AUTO_INCREMENT = 1;
END;
$$
DELIMITER ;