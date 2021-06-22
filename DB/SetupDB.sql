DROP DATABASE IF EXISTS AcademicSavingService;
CREATE DATABASE AcademicSavingService;
USE AcademicSavingService;

CREATE TABLE QUYDINH (
	MaQD INT NOT NULL AUTO_INCREMENT,
	SoTienNapNhoNhat DECIMAL(15, 2) NOT NULL,
    SoTienMoTaiKhoanNhoNhat DECIMAL(15, 2) NOT NULL,
    SoNgayToiThieu TINYINT NOT NULL,
    NgayTao DATETIME NOT NULL DEFAULT '0/0/0',
    
    PRIMARY KEY(MaQD),
    CHECK(SoNgayToiThieu >= 0),
    CHECK(SoTienMoTaiKhoanNhoNhat >= 0),
    CHECK(SoTienNapNhoNhat >= 0)
);

CREATE TABLE LOAIKYHAN (
	MaKyHan INT NOT NULL AUTO_INCREMENT,
    KyHan TINYINT NOT NULL,
    LaiSuat FLOAT NOT NULL,
    NgayTao DATE NOT NULL DEFAULT '0/0/0',
    NgayNgungSuDung DATE,
    
    PRIMARY KEY(MaKyHan),
    CHECK(KyHan >= 0),
    CHECK(LaiSuat >= 0),
    CHECK(NgayNgungSuDung >= NgayTao)
)  CHARACTER SET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE KHACHHANG (
	MaKH INT NOT NULL AUTO_INCREMENT,
    HoTen VARCHAR (30) NOT NULL,
	CMND VARCHAR(15) NOT NULL,
    SDT VARCHAR(15),
    NgayDangKy DATE NOT NULL DEFAULT '0/0/0',
    DiaChi TEXT NOT NULL,
    AnhDaiDien VARCHAR(255) NOT NULL DEFAULT '',
    
    PRIMARY KEY(MaKH)
) CHARACTER SET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE SOTIETKIEM (
	MaSo INT NOT NULL AUTO_INCREMENT,
    MaKH INT NOT NULL,
    NgayTao DATE NOT NULL DEFAULT '0/0/0',
    NgayDongSo DATE,
    MaKyHan INT NOT NULL,
    SoTienBanDau DECIMAL(15, 2) NOT NULL,
    SoDu DECIMAL(15, 2) NOT NULL DEFAULT 0,
    SoDuLanCapNhatCuoi DECIMAL(15, 2) NOT NULL DEFAULT 0,
	LanCapNhatCuoi DATE,
    
    FOREIGN KEY(MaKH) REFERENCES KHACHHANG(MaKH),
    FOREIGN KEY(MaKyHan) REFERENCES LOAIKYHAN(MaKyHan),
    CHECK (SoDu >= 0),
    CHECK (SoDuLanCapNhatCuoi >= 0),
    PRIMARY KEY(MaSo)
)  CHARACTER SET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PHIEURUT (
	MaPhieu INT NOT NULL AUTO_INCREMENT,
    NgayTao DATE NOT NULL DEFAULT '0/0/0',
    SoTien DECIMAL(15, 2) NOT NULL,
    GhiChu TEXT,
    MaSo INT NOT NULL,
    SoDuTruoc DECIMAL(15, 2),
    LanCapNhatCuoiTruoc DATE,
    
    CHECK (SoTien > 0),
    FOREIGN KEY(MaSo) REFERENCES SOTIETKIEM(MaSo),
    PRIMARY KEY(MaPhieu)
) CHARACTER SET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PHIEUGUI (
	MaPhieu INT NOT NULL AUTO_INCREMENT,
    NgayTao DATE NOT NULL DEFAULT '0/0/0',
    SoTien DECIMAL(15, 2) NOT NULL,
    GhiChu TEXT,
    MaSo INT NOT NULL,
    
    CHECK (SoTien >= 0),
    FOREIGN KEY(MaSo) REFERENCES SOTIETKIEM(MaSo),
    PRIMARY KEY(MaPhieu)
) CHARACTER SET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE BAOCAONGAY (
	Ngay DATE NOT NULL,
    KyHan INT NOT NULL,
    
    TongThu DECIMAL(15, 2) NOT NULL,
    TongChi DECIMAL(15, 2) NOT NULL,
    ChenhLech DECIMAL(15, 2) NOT NULL DEFAULT 0,
    
    PRIMARY KEY(Ngay, KyHan),
    CHECK(TongThu >= 0),
    CHECK(TongChi >= 0)
);

CREATE TABLE BAOCAOTHANG (
	Thang TINYINT NOT NULL,
    Nam INT NOT NULL,
    KyHan INT NOT NULL,
    
    SoMo INT NOT NULL,
    SoDong  INT NOT NULL,
    ChenhLech INT NOT NULL DEFAULT 0,
    
    PRIMARY KEY(Thang, Nam, KyHan),
    CHECK(SoMo >= 0),
    CHECK(SoDong >= 0)
);

CREATE TABLE GLOBALTABLE (
	DangCapNhatSTK BOOL NOT NULL DEFAULT FALSE,
    DangCapNhatPH BOOL NOT NULL DEFAULT FALSE,
    DangCapNhatLKH BOOL NOT NULL DEFAULT FALSE,
    DangCapNhatBCN BOOL NOT NULL DEFAULT FALSE,
    DangCapNhatBCT BOOL NOT NULL DEFAULT FALSE,
    DangCapNhatUQ BOOL NOT NULL DEFAULT FALSE,
    ForceDelete BOOL NOT NULL DEFAULT FALSE
);
INSERT INTO GLOBALTABLE VALUES ();

CREATE TABLE ERRORTABLE (
	MaLoi VARCHAR(5),
    GhiChu TEXT,
    
    PRIMARY KEY(MaLoi)
) CHARACTER SET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SET PERSIST information_schema_stats_expiry = 0;

/*==================================================================================FUNCTIONS=============================================================================*/

DROP FUNCTION IF EXISTS LaySoTienNapNhoNhat;
DELIMITER $$
CREATE FUNCTION LaySoTienNapNhoNhat(NgayKiemTra DATE) RETURNS BIGINT
DETERMINISTIC 
BEGIN
	SELECT SoTienNapNhoNhat INTO @SoTien FROM QuyDinh WHERE NgayTao <= NgayKiemTra ORDER BY NgayTao DESC LIMIT 1;
	IF (@SoTien IS NULL) THEN
		CALL ThrowException('QD004');
    END IF;
	RETURN @SoTien;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS LaySoTienMoTaiKhoanNhoNhat;
DELIMITER $$
CREATE FUNCTION LaySoTienMoTaiKhoanNhoNhat(NgayKiemTra DATE) RETURNS BIGINT
DETERMINISTIC 
BEGIN
	SELECT SoTienMoTaiKhoanNhoNhat INTO @SoTien FROM QuyDinh WHERE NgayTao <= NgayKiemTra ORDER BY MaQD DESC LIMIT 1;
    IF (@SoTien IS NULL) THEN
		CALL ThrowException('QD004');
    END IF;
	RETURN @SoTien;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS LaySoNgayKhongKyHanNhoNhat;
DELIMITER $$
CREATE FUNCTION LaySoNgayKhongKyHanNhoNhat(NgayKiemTra DATE) RETURNS BIGINT
DETERMINISTIC 
BEGIN
	SELECT SoNgayToiThieu INTO @SoTien FROM QuyDinh WHERE NgayTao <= NgayKiemTra ORDER BY NgayTao DESC LIMIT 1;
	IF (@SoTien IS NULL) THEN
		CALL ThrowException('QD004');
    END IF;
	RETURN @SoTien;
END$$
DELIMITER ;

/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS AutofillQuyDinh;
DELIMITER $$
CREATE TRIGGER AutofillQuyDinh BEFORE INSERT ON QuyDinh FOR EACH ROW
BEGIN
	IF (NEW.NgayTao = '0/0/0') THEN
		SET NEW.NgayTao = NOW();
	END IF;
    IF (EXISTS (SELECT * FROM QUYDINH WHERE NgayTao > NEW.NgayTao)) THEN
		CALL ThrowException('QD003');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS AfterInsertQuyDinh;
DELIMITER $$
CREATE TRIGGER AfterInsertQuyDinh AFTER INSERT ON QUYDINH FOR EACH ROW
BEGIN
    IF (EXISTS(SELECT * FROM QUYDINH WHERE MaQD > NEW.MaQD)) THEN
        CALL ThrowException('FU004');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeUpdateQuyDinh;
DELIMITER $$
CREATE TRIGGER BeforeUpdateQuyDinh BEFORE UPDATE ON QUYDINH FOR EACH ROW
BEGIN
	CALL ThrowException('QD001');
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeDeleteQuyDinh;
DELIMITER $$
CREATE TRIGGER BeforeDeleteQuyDinh BEFORE DELETE ON QUYDINH FOR EACH ROW
BEGIN
	DECLARE Result BOOL;
    SET Result = EXISTS(SELECT * FROM SOTIETKIEM WHERE NgayTao >= OLD.NgayTao);
    SET Result = Result OR EXISTS(SELECT * FROM PHIEUGUI WHERE NgayTao >= OLD.NgayTao);
    SET Result = Result OR EXISTS(SELECT * FROM PHIEURUT WHERE NgayTao >= OLD.NgayTao);
    IF (Result = TRUE) THEN
		CALL ThrowException('QD002');
    END IF;
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/

/*=================================================================================PROCEDURES=============================================================================*/

DROP PROCEDURE IF EXISTS NgungSuDungKyHan;
DELIMITER $$
CREATE PROCEDURE NgungSuDungKyHan(IN KyHanNgungSuDung TINYINT, IN NgayNgungSuDungMoi DATE)
BEGIN
	CALL BatDauCapNhatLoaiKyHan();
	UPDATE LoaiKyHan
    SET NgayNgungSuDung = NgayNgungSuDungMoi
    WHERE KyHan = KyHanNgungSuDung AND NgayNgungSuDung IS NULL;
    CALL KetThucCapNhatLoaiKyHan();
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS ThemKyHan;
DELIMITER $$
CREATE PROCEDURE ThemKyHan(IN KyHan TINYINT, IN LaiSuat FLOAT, IN NgayTao DATE, IN NgayNgungSuDung DATE)
BEGIN
	IF (NgayTao = '0/0/0') THEN
		SET NgayTao = NOW();
	END IF;
	IF ((SELECT LKH.NgayTao FROM LoaiKyHan LKH WHERE LKH.KyHan = KyHan ORDER BY LKH.NgayTao DESC LIMIT 1) < NgayTao) THEN
		CALL NgungSuDungKyHan(KyHan, NgayTao);
    END IF;
	INSERT INTO LoaiKyHan (KyHan, LaiSuat, NgayTao, NgayNgungSuDung) VALUES(KyHan, LaiSuat, NgayTao, NgayNgungSuDung);
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS LayKyHanVaLaiSuat;
DELIMITER $$
CREATE PROCEDURE LayKyHanVaLaiSuat(IN NgayKiemTra DATE)
BEGIN
	PREPARE QueryStr FROM 'SELECT LKH.KyHan, LaiSuat FROM LOAIKYHAN LKH JOIN (SELECT MAX(MaKyHan) AS MaKyHan FROM LOAIKYHAN LKH2 WHERE NgayTao <= ? AND (NgayNgungSuDung > ? OR NgayNgungSuDung IS NULL) GROUP BY KyHan) KQ ON LKH.MaKyHan = KQ.MaKyHan;';
	SET @NgayKiemTra = NgayKiemTra;
	EXECUTE QueryStr USING @NgayKiemTra, @NgayKiemTra;
    DEALLOCATE PREPARE QueryStr;
END;
$$
DELIMITER ;

/*==================================================================================FUNCTIONS=============================================================================*/

DROP FUNCTION IF EXISTS LayLaiSuatPhuHopCuaKyHan;
DELIMITER $$
CREATE FUNCTION LayLaiSuatPhuHopCuaKyHan(KyHanCanTim INT, NgayCanTim DATE) RETURNS FLOAT DETERMINISTIC
BEGIN
	RETURN (SELECT MaKyHan FROM LOAIKYHAN WHERE KyHan = KyHanCanTim AND NgayTao <= NgayCanTim AND (NgayNgungSuDung IS NULL OR NgayNgungSuDung > NgayCanTim) ORDER BY NgayTao DESC LIMIT 1);
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS LaiSuatKhongKyHan;
DELIMITER $$
CREATE FUNCTION LaiSuatKhongKyHan() RETURNS FLOAT
DETERMINISTIC
BEGIN
	SELECT LaiSuat INTO @LaiSuat FROM LoaiKyHan WHERE KyHan = 0 LIMIT 1;
    RETURN @LaiSuat;
END
$$
DELIMITER ;

DROP FUNCTION IF EXISTS KiemTraKyHan;
DELIMITER $$
CREATE FUNCTION KiemTraKyHan(TimKyHan INT, NgayTim DATE) RETURNS BOOL
DETERMINISTIC
BEGIN
	SELECT NgayNgungSuDung, NgayTao INTO @NgayNgungSuDung, @NgayTao FROM LoaiKyHan WHERE MaKyHan = TimKyHan AND NgayTao <= NgayTim ORDER BY NgayTao DESC LIMIT 1;
    IF (@NgayTao > NgayTim) THEN
		RETURN FALSE;
	ELSEIF (@NgayNgungSuDung IS NULL OR @NgayNgungSuDung > NgayTim) THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS LayLaiSuatKhongKyHanTrongKhoangThoiGian;
DELIMITER $$
CREATE FUNCTION LayLaiSuatKhongKyHanTrongKhoangThoiGian(NgayBatDau DATE, NgayKetThuc DATE) RETURNS FLOAT DETERMINISTIC
BEGIN
	DECLARE Counter, _size INT;
    DECLARE _laiSuatHienTai FLOAT;
    DECLARE _tongLaiSuat FLOAT;
    DECLARE _ngayHienTai DATE;
    DECLARE _ngayTuongLai DATE;
    DECLARE _laiSuatTrongTuongLai FLOAT;

	IF (NgayBatDau >= NgayKetThuc) THEN RETURN 0; END IF;
    SET _laiSuatHienTai = (SELECT LaiSuat FROM LOAIKYHAN WHERE NgayTao <= NgayBatDau AND KyHan = 0 ORDER BY NgayTao DESC LIMIT 1);
    SELECT COUNT(*) INTO _size FROM LOAIKYHAN WHERE NgayTao > NgayBatDau AND KyHan = 0 AND NgayTao <= NgayKetThuc;
    
    IF (_laiSuatHienTai IS NULL) THEN
		SET _laiSuatHienTai = 0;
    END IF;
    
    SET _tongLaiSuat = 0;
    SET _ngayHienTai = NgayBatDau;
    SET Counter = 0;
    WHILE (Counter < _size) DO
		SELECT LaiSuat, NgayTao INTO _laiSuatTrongTuongLai, _ngayTuongLai FROM LOAIKYHAN WHERE  NgayTao > NgayBatDau AND KyHan = 0 AND NgayTao <= NgayKetThuc LIMIT Counter, 1;
        SET _tongLaiSuat = _tongLaiSuat + (_laiSuatHienTai * TIMESTAMPDIFF(DAY, _ngayHienTai, _ngayTuongLai));
        SET _laiSuatHienTai = _laiSuatTrongTuongLai;
        SET _ngayHienTai = _ngayTuongLai;
        SET Counter = Counter + 1;
    END WHILE;
    SET _tongLaiSuat = _tongLaiSuat + (_laiSuatHienTai * TIMESTAMPDIFF(DAY, _ngayHienTai, NgayKetThuc));
    RETURN (_tongLaiSuat / 36500);
END;
$$
DELIMITER ;

/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS LoaiKyHanAfterInsert;
DELIMITER $$
CREATE TRIGGER LoaiKyHanAfterInsert AFTER INSERT ON LOAIKYHAN FOR EACH ROW
BEGIN
    IF (EXISTS(SELECT * FROM LOAIKYHAN WHERE MaKyHan > NEW.MaKyHan)) THEN
        CALL ThrowException('FU005');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS LoaiKyHanBeforeInsert;
DELIMITER $$
CREATE TRIGGER LoaiKyHanBeforeInsert BEFORE INSERT ON LOAIKYHAN FOR EACH ROW
BEGIN
    DECLARE  _throwException BOOL;
    DECLARE  _ngayNgungSuDung DATE;
    SET _throwException = FALSE;

	IF (NEW.KyHan = 0) THEN
	    IF (NEW.NgayNgungSuDung IS NOT NULL) THEN
            CALL ThrowException('KY001');
        ELSE
            SELECT NgayNgungSuDung INTO _ngayNgungSuDung FROM LOAIKYHAN WHERE KyHan = 0 AND NgayTao <= NEW.NgayTao ORDER BY MaKyHan DESC LIMIT 1;
            IF (_ngayNgungSuDung IS NOT NULL AND _ngayNgungSuDung != NEW.NgayTao) THEN
                CALL ThrowException('KY001');
            END IF;
	    END IF;
    END IF;
	SET _throwException = EXISTS (SELECT * FROM LOAIKYHAN WHERE KyHan = NEW.KyHan AND NgayTao > NEW.NgayTao);
    SET _throwException = _throwException OR EXISTS (SELECT * FROM LOAIKYHAN WHERE KyHan = NEW.KyHan AND (NgayNgungSuDung IS NULL OR NgayNgungSuDung > NEW.NgayTao));
	IF (_throwException) THEN
		CALL ThrowException('KY002');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS LoaiKyHanBeforeUpdate;
DELIMITER $$
CREATE TRIGGER LoaiKyHanBeforeUpdate BEFORE UPDATE ON LOAIKYHAN FOR EACH ROW
BEGIN
	IF (NOT CoTheCapNhatLoaiKyHan() AND (NEW.MaKyHan != OLD.MaKyHan OR NEW.NgayTao != OLD.NgayTao OR NEW.KyHan != OLD.KyHan)) THEN
		CALL ThrowException('KY004');
    END IF;
    IF (NEW.LaiSuat != OLD.LaiSuat AND EXISTS(SELECT * FROM SOTIETKIEM STK WHERE STK.MaKyHan = NEW.MaKyHan)) THEN
        CALL ThrowException('KY005');
    END IF;
	IF (NEW.NgayNgungSuDung != OLD.NgayNgungSuDung AND EXISTS(SELECT * FROM SOTIETKIEM STK WHERE STK.MaKyHan = NEW.MaKyHan AND STK.NgayTao >= OLD.NgayNgungSuDung)) THEN
        CALL ThrowException('KY006');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS LoaiKyHanBeforeDelete;
DELIMITER $$
CREATE TRIGGER LoaiKyHanBeforeDelete BEFORE DELETE ON LOAIKYHAN FOR EACH ROW
BEGIN
    DECLARE _errorCode TEXT;
    SET _errorCode = '';

    IF (OLD.KyHan = 0) THEN
        IF (EXISTS (SELECT * FROM SOTIETKIEM WHERE NgayTao >= OLD.NgayTao)) THEN
    	    CALL ThrowException('KY003');
        END IF;
    END IF;
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/

/*==================================================================================FUNCTIONS=============================================================================*/
/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS KhachHangInsertTrigger;
DELIMITER $$
CREATE TRIGGER KhachHangInsertTrigger BEFORE INSERT
ON KhachHang FOR EACH ROW
BEGIN
	IF (NEW.NgayDangKy = '0/0/0') THEN
    	SET NEW.NgayDangKy = CURRENT_DATE;
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS KhachHangAfterInsert;
DELIMITER $$
CREATE TRIGGER KhachHangAfterInsert AFTER INSERT ON KHACHHANG FOR EACH ROW
BEGIN
    IF (EXISTS(SELECT * FROM KHACHHANG WHERE MaKH > NEW.MaKH)) THEN
        CALL ThrowException('FU001');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS KhachHangBeforeUpdate;
DELIMITER $$
CREATE TRIGGER KhachHangBeforeUpdate BEFORE UPDATE ON KHACHHANG FOR EACH ROW
BEGIN
    IF (NEW.NgayDangKy != OLD.NgayDangKy) THEN
        IF (EXISTS(SELECT * FROM SOTIETKIEM WHERE NgayTao < NEW.NgayDangKy)) THEN
            CALL ThrowException('KH001');
        END IF;
    END IF;
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/

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
CREATE PROCEDURE LaySoTienVoiNgay (IN NgayTao DATE, IN LanCapNhatCuoi DATE, IN NgayDongSo DATE, IN MaKyHan INT, IN MaSo INT, IN SoDuLanCapNhatCuoi DECIMAL(15, 2), IN NgayCanUpdate DATE, OUT SoDuDung DECIMAL(15, 2), OUT NgayUpdate DATE)
BEGIN
	DECLARE _counter, _kyHan, _size INT;
	DECLARE _ngayDaoHan, _nextUpdateDate, _createDate DATE;
	DECLARE _interest FLOAT;
	DECLARE _money DECIMAL(15, 2);
  	SET _counter = 0;

	IF (NgayCanUpdate > CURRENT_DATE()) THEN
		CALL ThrowException('TK004');
	END IF;
	IF (NgayDongSo IS NULL) THEN
		IF (LanCapNhatCuoi >= NgayCanUpdate) THEN
			SET SoDuDung = SoDuLanCapNhatCuoi;
	        SET NgayUpdate = LanCapNhatCuoi;
		ELSE
		    SET LanCapNhatCuoi = IF (LanCapNhatCuoi IS NULL, NgayTao, LanCapNhatCuoi);
			SELECT KyHan INTO _kyHan FROM LOAIKYHAN LKH WHERE LKH.MaKyHan = MaKyHan;
			SET _ngayDaoHan = TIMESTAMPADD(MONTH, _kyHan, NgayTao);
	        SET SoDuDung = SoDuLanCapNhatCuoi;
	  		IF (NgayCanUpdate >= _ngayDaoHan) THEN
				IF (LanCapNhatCuoi < _ngayDaoHan) THEN
					SET _nextUpdateDate = IF(NgayCanUpdate < _ngayDaoHan, NgayCanUpdate, _ngayDaoHan);
					SET _interest = (SELECT LaiSuat FROM LOAIKYHAN LKH WHERE MaKyHan = LKH.MaKyHan);
					SET SoDuDung = SoDuDung * (1 + (_interest / (100 * 365)) * TIMESTAMPDIFF(DAY, LanCapNhatCuoi, _nextUpdateDate));
					SET LanCapNhatCuoi = _nextUpdateDate;
				END IF;

				SET SoDuDung = SoDuDung * (1 + LayLaiSuatKhongKyHanTrongKhoangThoiGian(LanCapNhatCuoi, NgayCanUpdate));
	    		SELECT COUNT(*) INTO _size FROM PHIEUGUI PG WHERE PG.NgayTao <= NgayCanUpdate AND PG.NgayTao > LanCapNhatCuoi AND PG.MaSo = MaSo;
	   			WHILE (_counter < _size) DO
					SELECT PG.SoTien, PG.NgayTao INTO _money, _createDate FROM PHIEUGUI PG WHERE  PG.NgayTao <= NgayCanUpdate AND PG.NgayTao > LanCapNhatCuoi AND PG.MaSo = MaSo ORDER BY MaPhieu LIMIT _counter, 1;
					SET SoDuDung = SoDuDung + (_money * (1 + LayLaiSuatKhongKyHanTrongKhoangThoiGian(_createDate, NgayCanUpdate)));
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
        CALL LaySoTienVoiNgay(NgayTao, LanCapNhatCuoi, NgayDongSo, MaKyHan, MaSo, SoDuLanCapNhatCuoi, NgayCanUpdate, SoDuDung, NgayUpdate);
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
	        NEW.NgayTao != OLD.NgayTao OR
	        NEW.MaKyHan != OLD.MaKyHan) THEN
		    CALL ThrowException('TK003');
        END IF;
    END IF;

    IF (NEW.MaKH != OLD.MaKH) THEN
        IF (NEW.NgayTao < (SELECT NgayDangKy FROM KHACHHANG WHERE MaKH = NEW.MaKH)) THEN
            CALL ThrowException('TK008');
        END IF;
    END IF;

	IF (NEW.SoTienBanDau != OLD.SoTienBanDau) THEN
        IF (KiemTraKyHan(NEW.MaKyHan, NEW.NgayTao) = FALSE) THEN
	    	CALL ThrowException('TK002');
	    END IF;
	    IF (EXISTS(SELECT * FROM PHIEURUT PR WHERE PR.MaSo = NEW.MaSo)) THEN
            CALL ThrowException('TK005');
        END IF;
        IF (NEW.SoTienBanDau < LaySoTienMoTaiKhoanNhoNhat(NEW.NgayTao)) THEN
            CALL ThrowException('TK001');
        END IF;
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
	            NEW.NgayDongSo, NEW.MaKyHan, NEW.MaSo,
	            NEW.SoDuLanCapNhatCuoi, CURRENT_DATE(), SoDuDung, NgayDung);
            SET NEW.SoDu = SoDuDung;
        END IF;
    END IF;

    IF (NEW.SoDuLanCapNhatCuoi != OLD.SoDuLanCapNhatCuoi OR
        NEW.NgayTao != OLD.NgayTao OR
        NEW.SoTienBanDau != OLD.SoTienBanDau) THEN
        CALL CapNhatBaoCaoNgayXoaSoTietKiem(OLD.SoTienBanDau, OLD.NgayTao, OLD.MaKyHan);
        CALL CapNhatBaoCaoThangXoaSoTietKiem(OLD.NgayTao, OLD.MaKyHan, OLD.NgayDongSo);

        CALL CapNhatBaoCaoNgayTaoSoTietKiem(NEW.SoTienBanDau, NEW.NgayTao, NEW.MaKyHan);
        CALL CapNhatBaoCaoThangTaoSoTietKiem(NEW.NgayTao, NEW.MaKyHan, NEW.NgayDongSo);
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS SoTietKiemAfterInsert;
DELIMITER $$
CREATE TRIGGER SoTietKiemAfterInsert AFTER INSERT ON SOTIETKIEM FOR EACH ROW
BEGIN
    IF (EXISTS(SELECT * FROM SOTIETKIEM WHERE MaSo > NEW.MaSo)) THEN
        CALL ThrowException('FU006');
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
    IF (NEW.NgayTao < (SELECT NgayDangKy FROM KHACHHANG WHERE MaKH = NEW.MaKH)) THEN
        CALL ThrowException('TK008');
    END IF;
    IF (NOT EXISTS(SELECT * FROM QUYDINH WHERE quydinh.NgayTao < NEW.NgayTao)) THEN
        CALL ThrowException('TK007');
    END IF;
	IF (NEW.SoTienBanDau < LaySoTienMoTaiKhoanNhoNhat(NEW.NgayTao)) THEN CALL ThrowException('TK001'); END IF;
    IF (KiemTraKyHan(NEW.MaKyHan, NEW.NgayTao) = FALSE) THEN
		CALL ThrowException('TK002');
	END IF; 
	SET NEW.SoDu = NEW.SoTienBanDau;
    SET NEW.SoDuLanCapNhatCuoi = NEW.SoTienBanDau;

	CALL LaySoTienVoiNgay(NEW.NgayTao, NEW.LanCapNhatCuoi,
	    NEW.NgayDongSo, NEW.MaKyHan, NEW.MaSo,
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

/*===================================================================================SCHEDULER==============================================================================*/

DROP EVENT IF EXISTS UpdateBalance;
DELIMITER $$
CREATE EVENT UpdateBalance ON SCHEDULE EVERY 1 DAY STARTS CONCAT(TIMESTAMPADD(DAY, 1, CURRENT_DATE()), ' ' ,'00:20:00') ON COMPLETION PRESERVE ENABLE DO
BEGIN
    DECLARE _size, _counter, _maSo INT;
    DECLARE _soDuDung DECIMAL(15, 2);

    SELECT COUNT(*) INTO _size FROM SOTIETKIEM WHERE NgayDongSo IS NULL;
    SET _counter = 0;
    WHILE(_counter < _size) DO
        SELECT MaSo INTO _maSo FROM SOTIETKIEM WHERE NgayDongSo IS NULL ORDER BY MaSo LIMIT _counter, 1;
        CALL LaySoTienVoiNgayQuery(_maSo, CURRENT_DATE(), _soDuDung, @Dummy);

        UPDATE SOTIETKIEM
        SET SoDu = _soDuDung
        WHERE MaSo = _maSo;

        SET _counter = _counter + 1;
    END WHILE;
END;
$$
DELIMITER ;

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

/*==================================================================================PROCEDURE=============================================================================*/
/*==================================================================================FUNCTIONS=============================================================================*/
/*===================================================================================TRIGGERS==============================================================================*/

DROP TRIGGER IF EXISTS  AfterInsertPhieuGui;
DELIMITER $$
CREATE TRIGGER AfterInsertPhieuGui AFTER INSERT ON PHIEUGUI FOR EACH ROW
BEGIN
    DECLARE SoDuDUng DECIMAL(15, 2);

    IF (EXISTS(SELECT * FROM PHIEUGUI WHERE MaPhieu > NEW.MaPhieu)) THEN
        CALL ThrowException('FU002');
    END IF;

    CALL LaySoTienVoiNgayQuery(NEW.MaSo, CURRENT_DATE(), SoDuDung, @Dummy);
    CALL BatDauCapNhatSoTietKiem();
	UPDATE SOTIETKIEM
	SET SoDu = SoDuDung
	WHERE MaSo = NEW.MaSo;
	CALL KetThucCapNhatSoTietKiem();
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeInsertPhieuGui;
DELIMITER $$
CREATE TRIGGER BeforeInsertPhieuGui BEFORE INSERT ON PHIEUGUI FOR EACH ROW
BEGIN
    DECLARE NgayTao, NgayDongSo, LanCapNhatCuoi DATE;
    DECLARE KyHan, Size INT;

	IF (NEW.NgayTao = '0/0/0') THEN SET NEW.NgayTao = NOW(); END IF;
    SELECT STK.NgayTao, LKH.KyHan, STK.NgayDongSo, STK.LanCapNhatCuoi, COUNT(*) INTO NgayTao, KyHan, NgayDongSo, LanCapNhatCuoi, Size
    FROM SOTIETKIEM STK JOIN LOAIKYHAN LKH ON STK.MaKH = LKH.MaKyHan
    WHERE MaSo = NEW.MaSo;
    
    IF (Size = 0 OR NgayDongSo IS NOT NULL) THEN CALL ThrowException('PH001'); END IF;
    IF (NEW.NgayTao < NgayTao) THEN CALL ThrowException('PH003'); END IF;
    IF (NEW.NgayTao < LanCapNhatCuoi) THEN CALL ThrowException('PG004'); END IF;

    IF (KyHan = 0) THEN
        IF (NEW.NgayTao < TIMESTAMPADD(DAY, LaySoNgayKhongKyHanNhoNhat(NgayTao), NgayTao)) THEN
			CALL ThrowException('PG005');
        END IF;
    ELSE
        IF (NEW.NgayTao < TIMESTAMPADD(MONTH, KyHan, NgayTao)) THEN
            CALL ThrowException('PG003');
        END IF;
    END IF;
    
    IF (NEW.SoTien < LaySoTienNapNhoNhat(NEW.NgayTao)) THEN
		CALL ThrowException('PG001');
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeDeletePhieuGui;
DELIMITER $$
CREATE TRIGGER BeforeDeletePhieuGui BEFORE DELETE ON PHIEUGUI FOR EACH ROW
BEGIN
    DECLARE _isThrowException BOOL;
    DECLARE _lastUpdate DATE;

	IF (NOT CanForceDelete()) THEN
		SELECT LanCapNhatCuoi INTO _lastUpdate FROM SOTIETKIEM WHERE MaSo = OLD.MaSo;
		SET _isThrowException = _lastUpdate > OLD.NgayTao;
		IF (_isThrowException) THEN
			CALL ThrowException('PH002');
		END IF;
		CALL CapNhatBaoCaoNgayXoaPhieu(OLD.SoTien, OLD.MaSo, OLD.NgayTao);
	END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS AfterDeletePhieuGui;
DELIMITER $$
CREATE TRIGGER AfterDeletePhieuGui AFTER DELETE ON PHIEUGUI FOR EACH ROW
BEGIN
    DECLARE SoDuDung DECIMAL(15, 2);

    CALL LaySoTienVoiNgayQuery(OLD.MaSo, CURRENT_DATE(), SoDuDung, @Dummy);
    CALL BatDauCapNhatSoTietKiem();
	UPDATE SOTIETKIEM
	SET SoDu = SoDuDung
	WHERE MaSo = OLD.MaSo;
	CALL KetThucCapNhatSoTietKiem();
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeUpdatePhieuGui;
DELIMITER $$
CREATE TRIGGER BeforeUpdatePhieuGui BEFORE UPDATE ON PHIEUGUI FOR EACH ROW
BEGIN
    DECLARE NgayTaoSo DATE;
    DECLARE KyHanSo INT;

	IF (NEW.MaPhieu != OLD.MaPhieu OR NEW.MaSo != OLD.MaSo) THEN
		CALL ThrowException('PH005');
	END IF;

    IF ((NEW.SoTien != OLD.SoTien OR NEW.NgayTao != OLD.NgayTao) AND (SELECT LanCapNhatCuoi FROM SOTIETKIEM WHERE MaSo = NEW.MaSo) > NEW.NgayTao) THEN
		CALL ThrowException('PH005');
	ELSE
		IF (NEW.SoTien < LaySoTienNapNhoNhat(NEW.NgayTao)) THEN
			CALL ThrowException('PG001');
		END IF;
        SELECT STK.NgayTao, KyHan INTO NgayTaoSo, KyHanSo FROM SOTIETKIEM STK JOIN LOAIKYHAN LKH ON STK.MaKyHan = LKH.MaKyHan WHERE STK.MaSo = NEW.MaSo;
		IF (NgayTaoSo > NEW.NgayTao) THEN
            CALL ThrowException('PH003');
        END IF;
		IF (TIMESTAMPADD(MONTH, KyHanSo, NgayTaoSo) > NEW.NgayTao) THEN
            CALL ThrowException('PG003');
        END IF;
        
        CALL CapNhatBaoCaoNgayXoaPhieu(OLD.SoTien, OLD.MaSo, OLD.NgayTao);
		CALL CapNhatBaoCaoNgayTaoPhieu(NEW.SoTien, NEW.MaSo, NEW.NgayTao);
    END IF;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS AfterUpdatePhieuGui;
DELIMITER $$
CREATE TRIGGER AfterUpdatePhieuGui AFTER UPDATE ON PHIEUGUI FOR EACH ROW
BEGIN
    DECLARE SoDuDung DECIMAL(15, 2);
    IF (NEW.SoTien != OLD.SoTien OR NEW.NgayTao != OLD.NgayTao) THEN
        CALL LaySoTienVoiNgayQuery(OLD.MaSo, CURRENT_DATE(), SoDuDung, @Dummy);
        CALL BatDauCapNhatSoTietKiem();
	    UPDATE SOTIETKIEM
	    SET SoDu = SoDuDung
	    WHERE MaSo = OLD.MaSo;
	    CALL KetThucCapNhatSoTietKiem();
    END IF;
END;
$$
DELIMITER ;

/*===================================================================================QUERRIES==============================================================================*/

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

/*==================================================================================PROCEDURE=============================================================================*/

DROP PROCEDURE IF EXISTS TongHopBaoCaoNgay;
DELIMITER $$
CREATE PROCEDURE TongHopBaoCaoNgay(IN NgayBaoCao DATE, IN KyHanBaoCao INT)
BEGIN
	DECLARE TongThu, TongChi, TongTienGui, TongTienBanDau, SoTienPhieu, MaSoPhieu, SoTienBanDauSo DECIMAL(15,2);
    DECLARE Counter, SizeRut, KyHanSo INT;
	DECLARE LaiSuatSo FLOAT;
	DECLARE NgayTaoSo DATE;

	IF (NOT EXISTS(SELECT * FROM BAOCAONGAY WHERE Ngay = NgayBaoCao AND KyHan = KyHanBaoCao)) THEN
    	CALL BatDauCapNhatBaoCaoNgay();
		SELECT SUM(STK.SoTienBanDau) INTO TongTienBanDau FROM SOTIETKIEM STK WHERE STK.NgayTao = NgayBaoCao AND (SELECT LKH.KyHan FROM LOAIKYHAN LKH WHERE LKH.MaKyHan = STK.MaKyHan) = KyHanBaoCao;
        SET TongThu = IF (TongTienBanDau IS NULL, 0, TongTienBanDau);

		SELECT COUNT(*) INTO SizeRut FROM PHIEURUT PH WHERE PH.NgayTao = NgayBaoCao;
        SET TongChi = 0;
        SET Counter = 0;
        IF (KyHanBaoCao = 0) THEN
			SELECT SUM(SoTien) INTO TongTienGui FROm PHIEUGUI PH WHERE PH.NgayTao = NgayBaoCao;
            SET TongThu = TongThu + IF (TongTienGui IS NULL, 0, TongTienGui);
			WHILE (Counter < SizeRut) DO
				SELECT SoTien, MaSo INTO SoTienPhieu, MaSoPhieu FROM PHIEURUT PH WHERE PH.NgayTao = NgayBaoCao LIMIT Counter, 1;
				SELECT LKH.KyHan, LKH.LaiSuat, STK.NgayTao, STK.SoTienBanDau INTO KyHanSo, LaiSuatSo, NgayTaoSo, SoTienBanDauSo FROM SOTIETKIEM STK JOIN LOAIKYHAN LKH ON STK.MaKyHan = LKH.MaKyHan WHERE STK.MaSo = MaSoPhieu;
				IF (KyHanSo = 0) THEN
                    SET TongChi = TongChi + SoTienPhieu;
				ELSE
                    SET TongChi = TongChi + (SoTienPhieu - SoTienBanDauSo * (1 + TIMESTAMPDIFF(DAY, NgayTaoSo, TIMESTAMPADD(MONTH, KyHanSo, NgayTaoSo)) * ((LaiSuatSo / 100) / 365)));
                END IF;
                SET Counter = Counter + 1;
			END WHILE;
		ELSE
			WHILE (Counter < SizeRut) DO
				SELECT SoTien, MaSo INTO SoTienPhieu, MaSoPhieu FROM PHIEURUT PH WHERE PH.NgayTao = NgayBaoCao LIMIT Counter, 1;
				SELECT LKH.KyHan, LKH.LaiSuat, STK.NgayTao, STK.SoTienBanDau INTO KyHanSo, LaiSuatSo, NgayTaoSo, SoTienBanDauSo FROM SOTIETKIEM STK JOIN LOAIKYHAN LKH ON STK.MaKyHan = LKH.MaKyHan WHERE STK.MaSo = MaSoPhieu AND LKH.KyHan = KyHanBaoCao;
				SET TongChi = TongChi + SoTienBanDauSo * (1 + TIMESTAMPDIFF(DAY, NgayTaoSo, TIMESTAMPADD(MONTH, KyHanSo, NgayTaoSo)) * ((LaiSuatSo / 100) / 365));
                SET Counter = Counter + 1;
			END WHILE;
        END IF;
        
        SET TongChi = IF (TongChi IS NULL, 0, TongChi);
        SET TongThu = IF (TongThu IS NULL, 0, TongThu);

        INSERT INTO BAOCAONGAY(Ngay, KyHan, TongThu, TongChi, ChenhLech) VALUES (NgayBaoCao, KyHanBaoCao, TongThu, TongChi, TongThu - TongChi);
        CALL KetThucCapNhatBaoCaoNgay();
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
    DECLARE KyHanSo INT;
    DECLARE NgayTaoSo DATE;
    DECLARE LaiSuatSo FLOAT;
    DECLARE SoTienBanDau, SoTienCoKyHan DECIMAL(15, 2);

	IF (EXISTS (SELECT * FROM BAOCAONGAY WHERE Ngay = NgayTao)) THEN
    	CALL BatDauCapNhatBaoCaoNgay();
		SELECT LKH.KyHan, LKH.LaiSuat, STK.NgayTao, STK.SoTienBanDau INTO KyHanSo, LaiSuatSo, NgayTaoSo, SoTienBanDau FROM SOTIETKIEM STK JOIN LOAIKYHAN LKH ON STK.MaKyHan = LKH.MaKyHan WHERE STK.MaSo = MaSo;
		IF (SoTien < 0) THEN
		    SET SoTien = -SoTien;
		    IF (KyHanSo != 0) THEN
                SET SoTienCoKyHan = SoTienBanDau * (1 + TIMESTAMPDIFF(DAY, NgayTaoSo, TIMESTAMPADD(MONTH, KyHanSo, NgayTaoSo)) * LaiSuatSo / 36500);
		        UPDATE BAOCAONGAY SET TongChi = TongChi + SoTienCoKyHan  WHERE Ngay = NgayTao AND KyHan = KyHanSo;
		        UPDATE BAOCAONGAY SET TongChi = TongChi + (SoTien - SoTienCoKyHan) WHERE Ngay = NgayTao AND KyHan = 0;
		    ELSE
		        UPDATE BAOCAONGAY SET TongChi = TongChi + SoTien WHERE Ngay = NgayTao AND KyHan = 0;
		    END IF;
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
    DECLARE KyHanSo INT;
    DECLARE NgayTaoSo DATE;
    DECLARE LaiSuatSo FLOAT;
    DECLARE SoTienBanDau, SoTienCoKyHan DECIMAL(15, 2);

	IF (EXISTS (SELECT * FROM BAOCAONGAY WHERE Ngay = NgayTao)) THEN
    	CALL BatDauCapNhatBaoCaoNgay();
		SELECT LKH.KyHan, LKH.LaiSuat, STK.NgayTao, STK.SoTienBanDau INTO KyHanSo, LaiSuatSo, NgayTaoSo, SoTienBanDau FROM SOTIETKIEM STK JOIN LOAIKYHAN LKH ON STK.MaKyHan = LKH.MaKyHan WHERE STK.MaSo = MaSo;
		IF (SoTien < 0) THEN
		    SET SoTien = -SoTien;
		    IF (KyHanSo != 0) THEN
                SET SoTienCoKyHan = SoTienBanDau * (1 + TIMESTAMPDIFF(DAY, NgayTaoSo, TIMESTAMPADD(MONTH, KyHanSo, NgayTaoSo)) * LaiSuatSo / 36500);
		        UPDATE BAOCAONGAY SET TongChi = TongChi - SoTienCoKyHan  WHERE Ngay = NgayTao AND KyHan = KyHanSo;
		        UPDATE BAOCAONGAY SET TongChi = TongChi - (SoTien - SoTienCoKyHan) WHERE Ngay = NgayTao AND KyHan = 0;
		    ELSE
		        UPDATE BAOCAONGAY SET TongChi = TongChi - SoTien WHERE Ngay = NgayTao AND KyHan = 0;
		    END IF;
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
$$
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

/*==================================================================================FUNCTIONS=============================================================================*/

DROP FUNCTION IF EXISTS LayGhiChuLoi;
DELIMITER $$
CREATE FUNCTION LayGhiChuLoi(MaLoiCanTim VARCHAR(5)) RETURNS TEXT
DETERMINISTIC 
BEGIN
	RETURN (SELECT ET.GhiChu FROM ErrorTable ET WHERE ET.MaLoi = MaLoiCanTim  LIMIT 1);
END;
$$
DELIMITER ;

/*===================================================================================TRIGGERS==============================================================================*/
/*===================================================================================QUERRIES==============================================================================*/

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

/*===================================================================================DATA==============================================================================*/
CALL ForceDeleteAllSoTietKiem();
TRUNCATE TABLE ErrorTable;
DELETE FROM QUYDINH;
DELETE FROM LoaiKyHan;
DELETE FROM KHACHHANG;
DELETE FROM PHIEUGUI;
DELETE FROM PHIEURUT;
DELETE FROM SOTIETKIEM;
DELETE FROM BAOCAONGAY;
DELETE FROM BAOCAOTHANG;

ALTER TABLE KHACHHANG AUTO_INCREMENT = 1;

ALTER TABLE SOTIETKIEM AUTO_INCREMENT = 1;
ALTER TABLE LOAIKYHAN AUTO_INCREMENT = 1;

ALTER TABLE PHIEUGUI AUTO_INCREMENT = 1;
ALTER TABLE PHIEURUT AUTO_INCREMENT = 1;

ALTER TABLE QUYDINH AUTO_INCREMENT = 1;

/*========== Error Table ==========*/
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('TK000', 'Thao tác với sổ tiêt kiệm thành công');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('TK001', 'Số tiền tạo tài khoản ít hơn số tiền tối thiểu trong quy định');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('TK002', 'Loại kỳ hạn này không tồn tại hoặc không còn được sử dụng');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('TK003', 'Không được update sổ tiêt kiệm');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('TK004', 'Gọi update tới ngày trong quá khứ hay trong tương lai');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('TK005', 'Chi được update khi không có phiếu rút chỉ tới sổ này');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('TK006', 'Có phiếu tồn tại sau trước ngày được chọn');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('TK007', 'Không có quy định tồn tại trước ngày tạo');

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PG000', 'Gửi tiền thành công');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PG001', 'Số tiền gửi nhỏ hơn số tiền cho phép');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PG002', 'Thêm phiếu gửi không thành công');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PG003', 'Không thể gửi thêm tiền trước kỳ hạn hoặc trước ngày tối thiểu quy định');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PG004', 'Không thể gửi thêm tiền trước ngày rút gần nhất');

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PR000', 'Rút tiền thành công');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PR001', 'Không thể rút tiền trước kỳ hạn hoặc không thể rút tiền trước thời gian tối thiểu cho không kỳ hạn');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PR002', 'Rút tiền loại có kỳ hạn phải rút hết');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PR003', 'Tài khoản không đủ tiền để rút');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PR004', 'Thêm phiếu rút tiền không thành công');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PR005', 'Không thể rút tiền trước ngày rút gần nhất');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PR006', 'Không thể rút tiền do có phiếu gửi tồn tại sau khi sổ đã đóng');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PR007', 'Không thể update do có phiếu rút tồn tại sau phiếu này');

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PH001', 'Tài khoản đã đóng hoặc không tồn tại');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PH002', 'Phải xóa theo thứ tự trong cùng ngày');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PH003', 'Chỉ được tạo phiếu sau khi tạo tài khoản');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PH004', 'Chỉ chủ tài khoản tiết kiệm hoặc những người được ủy quyền gưi/rút tiền');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PH005', 'Không được cập nhật phiếu');

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('QD000', 'Thêm/Xóa quy định thành công');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('QD001', 'Không được sửa quy định');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('QD002', 'Có tài khoản tiết kiệm hoặc phiểu sử dụng quy định này');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('QD003', 'Không được thêm quy định vào quá khứ');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('QD004', 'Thời gian truy xuất quy định không hợp lệ');

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('KY000', 'Thêm xóa kỳ hạn thành công');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('KY001', 'Thêm kỳ hạn không kỳ hạn không hợp lý');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('KY002', 'Phải ngưng sử dụng loại kỳ hạn cùng kỳ hạn trước rồi mới được thêm vào');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('KY003', 'Không thể xóa vì có tài khoản tiết kiệm được tạo sau kỳ hạn này');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('KY004', 'Không cập nhât loại kỳ hạn');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('KY005', 'Không thể cập nhật loại kỳ hạn khi có sổ sử dụng');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('KY006', 'Không thể ngưng sử dụng loại kỳ hạn trước khi một sổ sử dụng nó được tạo');

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('UQ001', 'Không được cập nhật Ủy quyền');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('UQ002', 'Uy quyền cho khách hàng này đã tồn tại và chưa ngưng hoạt động');

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('BC001', 'Không cập nhât báo cáo');

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('FU001', 'Không được insert primary key nhỏ hơn primary key lớn nhất');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('FU002', 'Không được insert primary key nhỏ hơn primary key lớn nhất phiếu gửi');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('FU003', 'Không được insert primary key nhỏ hơn primary key lớn nhất phiếu rút');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('FU004', 'Không được insert primary key nhỏ hơn primary key lớn nhất quy định');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('FU005', 'Không được insert primary key nhỏ hơn primary key lớn nhất loại kỳ hạn');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('FU006', 'Không được insert primary key nhỏ hơn primary key lớn nhất sổ tiết kiệm');

SELECT * FROM ErrorTable;

/*==========Quy định==========*/
INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(100000, 500000, 10, '2016/01/01');
INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(100000, 500000, 11, '2016/07/01');

INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(100000, 600000, 12, '2017/01/01');
INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(200000, 800000, 14, '2017/07/01');

INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(200000, 1000000, 14, '2018/01/01');

INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(200000, 1000000, 15, '2019/01/01');

INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(100000, 1000000, 14, '2020/01/01');

INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(100000, 1000000, 15, '2021/01/01');

SELECT * FROM QuyDinh;

/*==========Loại kỳ hạn==========*/

-- Không kỳ hạn
CALL ThemKyHan(0, 0.1, '2016/01/01', NULL);
CALL ThemKyHan(0, 0.12, '2016/04/01', NULL);
CALL ThemKyHan(0, 0.14, '2016/07/01', NULL);

CALL ThemKyHan(0, 0.13, '2017/01/01', NULL);
CALL ThemKyHan(0, 0.12, '2017/07/01', NULL);
CALL ThemKyHan(0, 0.13, '2017/10/01', NULL);

CALL ThemKyHan(0, 0.11, '2018/01/01', NULL);
CALL ThemKyHan(0, 0.1, '2018/04/01', NULL);
CALL ThemKyHan(0, 0.13, '2018/07/01', NULL);
CALL ThemKyHan(0, 0.12, '2018/10/01', NULL);

CALL ThemKyHan(0, 0.13, '2019/04/01', NULL);
CALL ThemKyHan(0, 0.14, '2019/07/01', NULL);

CALL ThemKyHan(0, 0.15, '2020/01/01', NULL);
CALL ThemKyHan(0, 0.12, '2020/04/01', NULL);
CALL ThemKyHan(0, 0.14, '2020/10/01', NULL);

CALL ThemKyHan(0, 0.1, '2021/01/01', NULL);

-- 1 tháng
CALL ThemKyHan(1, 3, '2016/01/01', NULL);
CALL ThemKyHan(1, 2.9, '2016/07/01', NULL);

CALL ThemKyHan(1, 3, '2017/01/01', NULL);
CALL ThemKyHan(1, 3.1, '2017/07/01', NULL);

CALL ThemKyHan(1, 3.2, '2018/01/01', NULL);
CALL ThemKyHan(1, 3.3, '2018/07/01', NULL);

CALL ThemKyHan(1, 3.6, '2019/01/01', NULL);
CALL ThemKyHan(1, 3.4, '2019/07/01', NULL);

CALL ThemKyHan(1, 3.6, '2020/01/01', NULL);
CALL ThemKyHan(1, 3.9, '2020/07/01', NULL);

CALL ThemKyHan(1, 3.5, '2021/01/01', NULL);

-- 3 tháng
CALL ThemKyHan(3, 3.1, '2016/01/01', NULL);

CALL ThemKyHan(3, 3.2, '2017/01/01', NULL);
CALL ThemKyHan(3, 3.3, '2017/07/01', NULL);

CALL ThemKyHan(3, 3.35, '2018/01/01', NULL);
CALL ThemKyHan(3, 3.45, '2018/07/01', NULL);

CALL ThemKyHan(3, 3.8, '2019/01/01', NULL);
CALL ThemKyHan(3, 3.5, '2019/07/01', NULL);

CALL ThemKyHan(3, 3.8, '2020/01/01', NULL);
CALL ThemKyHan(3, 4, '2020/07/01', NULL);

CALL ThemKyHan(3, 3.7, '2021/01/01', NULL);

-- 6 tháng
CALL ThemKyHan(6, 4.5, '2016/01/01', NULL);
CALL ThemKyHan(6, 4.8, '2016/07/01', NULL);

CALL ThemKyHan(6, 5, '2017/01/01', NULL);
CALL ThemKyHan(6, 5.1, '2017/07/01', NULL);

CALL ThemKyHan(6, 5.2, '2018/01/01', NULL);
CALL ThemKyHan(6, 5.5, '2018/07/01', NULL);

CALL ThemKyHan(6, 5.3, '2019/01/01', NULL);
CALL ThemKyHan(6, 5.7, '2019/07/01', NULL);

CALL ThemKyHan(6, 5.6, '2020/01/01', NULL);
CALL ThemKyHan(6, 5.3, '2020/07/01', NULL);

CALL ThemKyHan(6, 5, '2021/01/01', NULL);

-- 9 tháng
CALL ThemKyHan(9, 5.6, '2018/01/01', NULL);
CALL ThemKyHan(9, 5.9, '2019/01/01', '2020/01/01');

-- 12 tháng = 1 năm
CALL ThemKyHan(12, 5.1 ,'2016/01/01', NULL);
CALL ThemKyHan(12, 5.5, '2016/07/01', NULL);

CALL ThemKyHan(12, 5.7, '2017/07/01', NULL);

CALL ThemKyHan(12, 5.8, '2018/01/01', NULL);
CALL ThemKyHan(12, 6, '2018/07/01', NULL);

CALL ThemKyHan(12, 6.1, '2019/07/01', NULL);

CALL ThemKyHan(12, 6.4, '2020/01/01', NULL);

CALL ThemKyHan(12, 6.3, '2021/01/01', NULL);

SELECT * FROM LoaiKyHan;

/*==========Khách hàng==========*/
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Phạm Hà Liên', '0831126759', '149 Nguyễn Tri Phương, Phường 8, Quận 5, Thành phố Hồ Chí Minh', '038337899317', '2016/01/01', 'Images/1');
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Đoàn Nhã Lý', '0433960399', '64 Nguyễn Thời Trung, Phường 6, Quận 5, Thành phố Hồ Chí Minh', '057760171219', '2016/01/01', 'Images/2');
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Nguyễn Quang Hải', '0966643448', '4 Lý Thường Kiệt, Phường 12, Quận 5, Thành phố Hồ Chí Minh', '067268027033', '2016/01/01', 'Images/3');
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Trầm Kiên Bình', '0289223796', '832 Huỳnh Tấn Phát, Phú Thuận, Quận 7, Thành phố Hồ Chí Minh', '096570502795', '2016/01/01', 'Images/4');

INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Thân Công Hậu', '0892522397', '15 Lâm Văn Bền, Tân Quy, Quận 7, Thành phố Hồ Chí Minh', '085842907170', '2016/01/01', 'Images/5');
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Nguyễn Trọng Vinh', '0755423139', '34 Bá Trạc, Phường 2, Quận 8, Thành phố Hồ Chí Minh', '013671098619', '2016/01/01', 'Images/6');
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Vũ Bảo Trúc', '0732349970', '870 Tạ Quang Bửu, Phường 5, Quận 8, Thành phố Hồ Chí Minh', '047424607765', '2016/01/01', 'Images/7');

INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Đặng Thành Châu', '0459068869', '94 Ngô Quyền, Phường 5, Quận 10, Phường 6, Quận 10, Thành phố Hồ Chí Minh', '067327095361', '2016/01/01', 'Images/8');
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Dương Mỹ Vân', '0452190962', '16 Lê Hồng Phong, Phường 12, Quận 10, Thành phố Hồ Chí Minh', '032505244096', '2016/01/01', 'Images/9');

INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Chu Kim Toàn', '0970238418', '88 Hà Huy Giáp, Thạnh Lộc, Quận 12, Thành phố Hồ Chí Minh', '029865643209', '2016/01/01', 'Images/10');
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Dương Khắc Thành', '0112019039', '181 Nguyễn Thị Đặng, Tân Thới Hiệp, Quận 12, Thành phố Hồ Chí Minh', '069921609940', '2016/01/01', 'Images/11');
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Phạm Chí Công', '0480047194', '98a2 Nguyễn Thị Đặng, Hiệp Thành, Quận 12, Thành phố Hồ Chí Minh', '057077252279', '2016/01/01', 'Images/12');

INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Phạm Thanh Đan', '0317657970', '54 Hà Huy Giáp, Thạnh Lộc, Quận 12, Thành phố Hồ Chí Minh', '046064694856', '2016/01/01', 'Images/13');
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Hoàng Phượng Loan', '0127187121', '219C Lê Quang Sung, Phường 6, Quận 6, Thành phố Hồ Chí Minh', '079787412158', '2016/01/01', 'Images/14');

INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Đinh Minh Trí', '0700019229', 'Hẻm 942 Kha Vạn Cân, Trường Thọ, Thủ Đức, Thành phố Hồ Chí Minh', '082654211937', '2016/01/01', 'Images/15');
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Nguyễn Xuân Khoa', '0359736526', '252 Đô Ngọc Vân, Linh Đông, Thủ Đức, Thành phố Hồ Chí Minh', '035719129304', '2016/01/01', 'Images/16');
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NgayDangKy, AnhDaiDien)
VALUES('Huỳnh Hải Phong', '0433233328', '146 Hoàng Diệu 2, Phường Linh Trung, Thủ Đức, Thành phố Hồ Chí Minh', '041898885155', '2016/01/01', 'Images/17');

SELECT * FROM KHACHHANG;

/*==========Sổ tiết kiệm==========*/
-- 2016
CALL ThemSoTietKiem(17, 12, 1000000, '2016/01/03');
CALL ThemSoTietKiem(12, 1, 5000000, '2016/01/15');
CALL ThemSoTietKiem(1, 0, 2000000, '2016/02/15');
CALL ThemSoTietKiem(9, 3, 4000000, '2016/03/15');
CALL ThemSoTietKiem(5, 3, 5000000, '2016/03/23');
CALL ThemSoTietKiem(2, 3, 9000000, '2016/04/07');
CALL ThemSoTietKiem(7, 1, 5000000, '2016/09/05');
CALL ThemSoTietKiem(3, 6, 9000000, '2016/09/15');
CALL ThemSoTietKiem(15, 3, 7000000, '2016/10/12');
CALL ThemSoTietKiem(16, 3, 8000000, '2016/12/15');

-- 2017
CALL ThemSoTietKiem(9, 12, 1000000, '2017/01/01');
CALL ThemSoTietKiem(16, 12, 10000000, '2017/02/05');
CALL ThemSoTietKiem(4, 6, 1000000, '2017/02/25');
CALL ThemSoTietKiem(11, 3, 1000000, '2017/03/07');
CALL ThemSoTietKiem(10, 1, 9000000, '2017/04/20');
CALL ThemSoTietKiem(8, 6, 4000000, '2017/07/16');
CALL ThemSoTietKiem(12, 3, 5000000, '2017/08/08');
CALL ThemSoTietKiem(11, 0, 7000000, '2017/09/03');
CALL ThemSoTietKiem(4, 6, 1000000, '2017/09/29');
CALL ThemSoTietKiem(16, 1, 1000000, '2017/12/30');

-- 2018
CALL ThemSoTietKiem(12, 0, 2000000, '2018/02/09');
CALL ThemSoTietKiem(10, 3, 6000000, '2018/04/05');
CALL ThemSoTietKiem(12, 9, 1000000, '2018/05/07');
CALL ThemSoTietKiem(9, 3, 10000000, '2018/05/16');
CALL ThemSoTietKiem(13, 3, 5000000, '2018/08/23');
CALL ThemSoTietKiem(5, 6, 4000000, '2018/09/12');
CALL ThemSoTietKiem(3, 0, 6000000, '2018/09/21');
CALL ThemSoTietKiem(11, 9, 3000000, '2018/10/04');
CALL ThemSoTietKiem(14, 12, 1000000, '2018/10/09');
CALL ThemSoTietKiem(2, 9, 1000000, '2018/12/11');

-- 2019
CALL ThemSoTietKiem(7, 3, 9000000, '2019/03/07');
CALL ThemSoTietKiem(6, 12, 10000000, '2019/06/29');
CALL ThemSoTietKiem(9, 3, 7000000, '2019/07/08');
CALL ThemSoTietKiem(12, 12, 9000000, '2019/07/18');
CALL ThemSoTietKiem(1, 1, 6000000, '2019/09/17');
CALL ThemSoTietKiem(4, 6, 3000000, '2019/09/24');
CALL ThemSoTietKiem(15, 3, 9000000, '2019/10/19');
CALL ThemSoTietKiem(14, 1, 3000000, '2019/11/01');
CALL ThemSoTietKiem(16, 0, 8000000, '2019/12/14');
CALL ThemSoTietKiem(17, 0, 5000000, '2019/12/20');

-- 2020
CALL ThemSoTietKiem(17, 1, 1000000, '2020/01/24');
CALL ThemSoTietKiem(8, 6, 6000000, '2020/04/11');
CALL ThemSoTietKiem(13, 3, 1000000, '2020/06/25');
CALL ThemSoTietKiem(3, 1, 9000000, '2020/07/11');
CALL ThemSoTietKiem(1, 12, 3000000, '2020/07/14');
CALL ThemSoTietKiem(15, 1, 8000000, '2020/08/01');
CALL ThemSoTietKiem(8, 6, 4000000, '2020/11/05');
CALL ThemSoTietKiem(11, 6, 3000000, '2020/11/22');
CALL ThemSoTietKiem(15, 0, 2000000, '2020/12/01');

-- 2021
CALL ThemSoTietKiem(1, 12, 8000000, '2021/01/09');
CALL ThemSoTietKiem(8, 3, 9000000, '2021/01/14');
CALL ThemSoTietKiem(7, 0, 5000000, '2021/02/11');
CALL ThemSoTietKiem(17, 1, 9000000, '2021/03/22');

SELECT * FROM SOTIETKIEM;

/*========== Phiếu ==========*/
-- 2016
CALL ThemPhieu(2, 100000, 'Some things', '2016/02/15');
CALL ThemPhieu(2, 800000, 'Some things', '2016/03/15');
CALL ThemPhieu(2, 900000, 'Some things', '2016/05/15');
CALL RutHetTien(2, 'The end game', '2016/06/15');

CALL ThemPhieu(3, 100000, 'Some things', '2016/03/15');
CALL ThemPhieu(3, 200000, 'Some things', '2016/04/15');
CALL ThemPhieu(3, 1000000, 'Some things', '2016/05/15');
CALL ThemPhieu(3, -700000, 'Some things', '2016/05/15');
CALL ThemPhieu(3, 100000, 'Some things', '2016/06/15');
CALL ThemPhieu(3, -900000, 'Some things', '2016/07/15');
CALL RutHetTien(3, 'The end game', '2016/08/15');

CALL ThemPhieu(4, 400000, 'Some things', '2016/06/15');
CALL RutHetTien(4, 'The end game', '2016/07/15');

CALL ThemPhieu(5, 700000, 'Some things', '2016/06/15');
CALL ThemPhieu(5, 300000, 'Some things', '2016/07/15');
CALL ThemPhieu(5, 600000, 'Some things', '2016/08/15');
CALL ThemPhieu(5, 700000, 'Some things', '2016/09/15');
CALL ThemPhieu(5, 200000, 'Some things', '2016/10/15');
CALL ThemPhieu(5, 400000, 'Some things', '2016/11/15');
CALL ThemPhieu(5, 800000, 'Some things', '2016/12/15');

CALL ThemPhieu(6, 300000, 'Some things', '2016/07/15');
CALL ThemPhieu(6, 300000, 'Some things', '2016/08/15');
CALL ThemPhieu(6, 400000, 'Some things', '2016/09/15');
CALL RutHetTien(6, 'The end game', '2017/10/15');

CALL ThemPhieu(7, 1000000, 'Some things', '2016/10/15');
CALL ThemPhieu(7, 400000, 'Some things', '2016/11/15');
CALL RutHetTien(7, 'The end game', '2017/12/15');

-- 2017
CALL RutHetTien(1, 'The end game', '2017/01/15');

CALL RutHetTien(5, 'The end game', '2017/01/15');

CALL ThemPhieu(8, 900000, 'Some things', '2017/03/15');
CALL ThemPhieu(8, 500000, 'Some things', '2017/04/15');
CALL ThemPhieu(8, 200000, 'Some things', '2017/05/15');
CALL RutHetTien(8, 'The end game', '2017/06/15');

CALL ThemPhieu(9, 400000, 'Some things', '2017/01/15');
CALL RutHetTien(9, 'The end game', '2017/02/15');

CALL ThemPhieu(10, 100000, 'Some things', '2017/04/15');
CALL ThemPhieu(10, 500000, 'Some things', '2017/05/15');
CALL RutHetTien(10, 'The end game', '2017/06/15');

CALL ThemPhieu(13, 600000, 'Some things', '2017/09/15');
CALL ThemPhieu(13, 500000, 'Some things', '2017/10/15');
CALL ThemPhieu(13, 400000, 'Some things', '2017/11/15');
CALL RutHetTien(13, 'The end game', '2017/12/15');

CALL RutHetTien(14, 'The end game', '2017/06/15');

CALL ThemPhieu(15, 1000000, 'Some things', '2017/06/15');
CALL ThemPhieu(15, 600000, 'Some things', '2017/07/15');
CALL ThemPhieu(15, 900000, 'Some things', '2017/08/15');
CALL ThemPhieu(15, 300000, 'Some things', '2017/09/15');
CALL RutHetTien(15, 'The end game', '2017/10/15');

CALL ThemPhieu(17, 1000000, 'Some things', '2017/12/15');

CALL ThemPhieu(18, -300000, 'Some things', '2017/10/15');
CALL ThemPhieu(18, 400000, 'Some things', '2017/11/15');
CALL ThemPhieu(18, 700000, 'Some things', '2017/12/15');

-- 2018
CALL ThemPhieu(11, 300000, 'Some things', '2018/01/15');
CALL RutHetTien(11, 'The end game', '2018/02/15');

CALL ThemPhieu(12, 300000, 'Some things', '2018/02/15');
CALL ThemPhieu(12, 200000, 'Some things', '2018/03/15');
CALL ThemPhieu(12, 500000, 'Some things', '2018/04/15');
CALL ThemPhieu(12, 500000, 'Some things', '2018/05/15');
CALL ThemPhieu(12, 800000, 'Some things', '2018/06/15');
CALL RutHetTien(12, 'The end game', '2018/07/15');

CALL ThemPhieu(16, 500000, 'Some things', '2018/02/15');
CALL ThemPhieu(16, 200000, 'Some things', '2018/03/15');
CALL ThemPhieu(16, 800000, 'Some things', '2018/04/15');
CALL ThemPhieu(16, 800000, 'Some things', '2018/05/15');
CALL RutHetTien(16, 'The end game', '2018/06/15');

CALL ThemPhieu(17, 700000, 'Some things', '2018/01/15');
CALL RutHetTien(17, 'The end game', '2018/02/15');

CALL ThemPhieu(18, 200000, 'Some things', '2018/01/15');
CALL ThemPhieu(18, -300000, 'Some things', '2018/02/15');
CALL ThemPhieu(18, 300000, 'Some things', '2018/03/15');
CALL ThemPhieu(18, -500000, 'Some things', '2018/04/15');
CALL ThemPhieu(18, -700000, 'Some things', '2018/05/15');
CALL RutHetTien(18, 'The end game', '2018/06/15');

CALL ThemPhieu(19, 800000, 'Some things', '2018/04/15');
CALL ThemPhieu(19, 300000, 'Some things', '2018/05/15');
CALL ThemPhieu(19, 900000, 'Some things', '2018/06/15');
CALL ThemPhieu(19, 400000, 'Some things', '2018/07/15');
CALL ThemPhieu(19, 700000, 'Some things', '2018/08/15');
CALL ThemPhieu(19, 200000, 'Some things', '2018/09/15');
CALL RutHetTien(19, 'The end game', '2018/10/15');

CALL ThemPhieu(20, 800000, 'Some things', '2018/02/15');
CALL ThemPhieu(20, 900000, 'Some things', '2018/03/15');
CALL RutHetTien(20, 'The end game', '2018/04/15');

CALL ThemPhieu(21, 800000, 'Some things', '2018/03/15');
CALL ThemPhieu(21, 900000, 'Some things', '2018/04/15');
CALL ThemPhieu(21, 400000, 'Some things', '2018/05/15');
CALL RutHetTien(21, 'The end game', '2018/06/15');

CALL RutHetTien(22, 'The end game', '2018/07/15');

CALL ThemPhieu(24, 900000, 'Some things', '2018/09/15');
CALL ThemPhieu(24, 800000, 'Some things', '2018/10/15');
CALL ThemPhieu(24, 400000, 'Some things', '2018/11/15');
CALL RutHetTien(24, 'The end game', '2018/12/15');

CALL ThemPhieu(25, 300000, 'Some things', '2018/12/15');

CALL ThemPhieu(27, 600000, 'Some things', '2018/10/15');
CALL ThemPhieu(27, 400000, 'Some things', '2018/11/15');
CALL ThemPhieu(27, 200000, 'Some things', '2018/12/15');

-- 2019
CALL ThemPhieu(23, 200000, 'Some things', '2019/03/15');
CALL RutHetTien(23, 'The end game', '2019/04/15');

CALL ThemPhieu(25, 200000, 'Some things', '2019/01/15');
CALL RutHetTien(25, 'The end game', '2019/02/15');

CALL ThemPhieu(26, 900000, 'Some things', '2019/03/15');
CALL ThemPhieu(26, 900000, 'Some things', '2019/04/15');
CALL RutHetTien(26, 'The end game', '2019/05/15');

CALL ThemPhieu(27, 800000, 'Some things', '2019/01/15');
CALL ThemPhieu(27, -200000, 'Some things', '2019/01/15');
CALL ThemPhieu(27, -1000000, 'Some things', '2019/02/15');
CALL ThemPhieu(27, 200000, 'Some things', '2019/03/15');
CALL ThemPhieu(27, -200000, 'Some things', '2019/04/15');
CALL ThemPhieu(27, 700000, 'Some things', '2019/05/15');
CALL RutHetTien(27, 'The end game', '2019/06/15');

CALL ThemPhieu(28, 200000, 'Some things', '2019/07/15');
CALL ThemPhieu(28, 800000, 'Some things', '2019/08/15');
CALL ThemPhieu(28, 500000, 'Some things', '2019/09/15');
CALL ThemPhieu(28, 200000, 'Some things', '2019/10/15');
CALL RutHetTien(28, 'The end game', '2019/11/15');

CALL ThemPhieu(29, 200000, 'Some things', '2019/10/15');
CALL ThemPhieu(29, 600000, 'Some things', '2019/11/15');
CALL ThemPhieu(29, 300000, 'Some things', '2019/12/15');

CALL ThemPhieu(30, 600000, 'Some things', '2019/10/15');
CALL ThemPhieu(30, 400000, 'Some things', '2019/11/15');
CALL RutHetTien(30, 'The end game', '2019/12/15');

CALL ThemPhieu(31, 800000, 'Some things', '2019/06/15');
CALL RutHetTien(31, 'The end game', '2019/07/15');

CALL ThemPhieu(35, 300000, 'Some things', '2019/10/15');
CALL RutHetTien(35, 'The end game', '2019/11/15');

CALL RutHetTien(38, 'The end game', '2019/12/15');

-- 2020
CALL ThemPhieu(29, 300000, 'Some things', '2020/01/15');
CALL RutHetTien(29, 'The end game', '2020/02/15');

CALL ThemPhieu(32, 700000, 'Some things', '2020/07/15');
CALL ThemPhieu(32, 900000, 'Some things', '2020/08/15');
CALL ThemPhieu(32, 600000, 'Some things', '2020/09/15');
CALL ThemPhieu(32, 1000000, 'Some things', '2020/10/15');
CALL ThemPhieu(32, 900000, 'Some things', '2020/11/15');
CALL ThemPhieu(32, 400000, 'Some things', '2020/12/15');

CALL ThemPhieu(33, 900000, 'Some things', '2020/10/15');
CALL ThemPhieu(33, 1000000, 'Some things', '2020/11/15');
CALL RutHetTien(33, 'The end game', '2020/12/15');

CALL ThemPhieu(34, 800000, 'Some things', '2020/08/15');
CALL ThemPhieu(34, 100000, 'Some things', '2020/09/15');
CALL ThemPhieu(34, 100000, 'Some things', '2020/10/15');
CALL RutHetTien(34, 'The end game', '2020/11/15');

CALL ThemPhieu(36, 200000, 'Some things', '2020/04/15');
CALL ThemPhieu(36, 800000, 'Some things', '2020/05/15');
CALL ThemPhieu(36, 400000, 'Some things', '2020/06/15');
CALL RutHetTien(36, 'The end game', '2020/07/15');

CALL ThemPhieu(37, 500000, 'Some things', '2020/02/15');
CALL RutHetTien(37, 'The end game', '2020/03/15');

CALL ThemPhieu(39, 900000, 'Some things', '2020/01/15');
CALL ThemPhieu(39, -1000000, 'Some things', '2020/01/15');
CALL ThemPhieu(39, -600000, 'Some things', '2020/02/15');
CALL ThemPhieu(39, 600000, 'Some things', '2020/03/15');
CALL ThemPhieu(39, 400000, 'Some things', '2020/04/15');
CALL ThemPhieu(39, -100000, 'Some things', '2020/05/15');
CALL ThemPhieu(39, 100000, 'Some things', '2020/06/15');
CALL RutHetTien(39, 'The end game', '2020/07/15');

CALL ThemPhieu(40, -300000, 'Some things', '2020/01/15');
CALL RutHetTien(40, 'The end game', '2020/02/15');

CALL ThemPhieu(41, 100000, 'Some things', '2020/03/15');
CALL ThemPhieu(41, 300000, 'Some things', '2020/04/15');
CALL ThemPhieu(41, 800000, 'Some things', '2020/05/15');
CALL ThemPhieu(41, 200000, 'Some things', '2020/06/15');
CALL RutHetTien(41, 'The end game', '2020/07/15');

CALL ThemPhieu(42, 200000, 'Some things', '2020/10/15');
CALL ThemPhieu(42, 400000, 'Some things', '2020/11/15');
CALL ThemPhieu(42, 800000, 'Some things', '2020/12/15');

CALL ThemPhieu(43, 500000, 'Some things', '2020/10/15');
CALL ThemPhieu(43, 1000000, 'Some things', '2020/11/15');
CALL ThemPhieu(43, 400000, 'Some things', '2020/12/15');

CALL ThemPhieu(44, 200000, 'Some things', '2020/08/15');
CALL RutHetTien(44, 'The end game', '2020/09/15');

CALL ThemPhieu(46, 300000, 'Some things', '2020/10/15');
CALL ThemPhieu(46, 800000, 'Some things', '2020/10/15');
CALL ThemPhieu(46, 1000000, 'Some things', '2020/11/15');
CALL ThemPhieu(46, 600000, 'Some things', '2020/12/15');

-- 2021
CALL RutHetTien(32, 'The end game', '2021/01/15');

CALL ThemPhieu(42, 600000, 'Some things', '2021/01/15');
CALL RutHetTien(42, 'The end game', '2021/02/15');

CALL ThemPhieu(43, 1000000, 'Some things', '2021/01/15');
CALL ThemPhieu(43, 700000, 'Some things', '2021/02/15');
CALL ThemPhieu(43, 200000, 'Some things', '2021/03/15');
CALL ThemPhieu(43, 800000, 'Some things', '2021/04/15');
CALL RutHetTien(43, 'The end game', '2021/05/15');

CALL RutHetTien(46, 'The end game', '2021/01/15');

CALL ThemPhieu(47, 900000, 'Some things', '2021/05/15');

CALL ThemPhieu(49, 100000, 'Some things', '2021/01/15');
CALL ThemPhieu(49, 800000, 'Some things', '2021/02/15');
CALL ThemPhieu(49, -700000, 'Some things', '2021/03/15');
CALL RutHetTien(49, 'The end game', '2021/04/15');

CALL ThemPhieu(51, 900000, 'Some things', '2021/04/15');
CALL ThemPhieu(51, 400000, 'Some things', '2021/05/15');

CALL ThemPhieu(52, -600000, 'Some things', '2021/03/15');
CALL ThemPhieu(52, 900000, 'Some things', '2021/04/15');
CALL ThemPhieu(52, -100000, 'Some things', '2021/05/15');

CALL ThemPhieu(53, 1000000, 'Some things', '2021/05/15');

SELECT * FROM PHIEUGUI;
SELECT * FROM PHIEURUT;

/*========== Báo cáo ngày ==========*/
CALL TongHopBaoCaoNgay('2016/01/15', 0);
CALL TongHopBaoCaoNgay('2016/02/15', 0);
CALL TongHopBaoCaoNgay('2016/03/15', 0);
CALL TongHopBaoCaoNgay('2016/04/15', 0);
CALL TongHopBaoCaoNgay('2016/05/15', 0);
CALL TongHopBaoCaoNgay('2016/06/15', 1);
CALL TongHopBaoCaoNgay('2016/07/15', 0);
CALL TongHopBaoCaoNgay('2016/08/15', 0);
CALL TongHopBaoCaoNgay('2016/09/15', 0);
CALL TongHopBaoCaoNgay('2016/10/15', 0);
CALL TongHopBaoCaoNgay('2016/11/15', 0);
CALL TongHopBaoCaoNgay('2016/12/15', 0);

CALL TongHopBaoCaoNgay('2017/01/15', 12);
CALL TongHopBaoCaoNgay('2017/02/15', 0);
CALL TongHopBaoCaoNgay('2017/03/15', 0);
CALL TongHopBaoCaoNgay('2017/04/15', 0);
CALL TongHopBaoCaoNgay('2017/05/15', 0);
CALL TongHopBaoCaoNgay('2017/06/15', 0);
CALL TongHopBaoCaoNgay('2017/07/15', 0);
CALL TongHopBaoCaoNgay('2017/08/15', 0);
CALL TongHopBaoCaoNgay('2017/09/15', 0);
CALL TongHopBaoCaoNgay('2017/10/15', 0);
CALL TongHopBaoCaoNgay('2017/11/15', 0);
CALL TongHopBaoCaoNgay('2017/12/15', 0);

CALL TongHopBaoCaoNgay('2018/01/15', 0);
CALL TongHopBaoCaoNgay('2018/02/15', 12);
CALL TongHopBaoCaoNgay('2018/03/15', 0);
CALL TongHopBaoCaoNgay('2018/04/15', 0);
CALL TongHopBaoCaoNgay('2018/05/15', 0);
CALL TongHopBaoCaoNgay('2018/06/15', 6);
CALL TongHopBaoCaoNgay('2018/07/15', 12);
CALL TongHopBaoCaoNgay('2018/08/15', 0);
CALL TongHopBaoCaoNgay('2018/09/15', 0);
CALL TongHopBaoCaoNgay('2018/10/15', 6);
CALL TongHopBaoCaoNgay('2018/11/15', 0);
CALL TongHopBaoCaoNgay('2018/12/15', 3);

CALL TongHopBaoCaoNgay('2019/01/15', 0);
CALL TongHopBaoCaoNgay('2019/02/15', 3);
CALL TongHopBaoCaoNgay('2019/03/15', 0);
CALL TongHopBaoCaoNgay('2019/04/15', 9);
CALL TongHopBaoCaoNgay('2019/05/15', 6);
CALL TongHopBaoCaoNgay('2019/06/15', 0);
CALL TongHopBaoCaoNgay('2019/07/15', 3);
CALL TongHopBaoCaoNgay('2019/08/15', 0);
CALL TongHopBaoCaoNgay('2019/09/15', 0);
CALL TongHopBaoCaoNgay('2019/10/15', 0);
CALL TongHopBaoCaoNgay('2019/11/15', 9);
CALL TongHopBaoCaoNgay('2019/12/15', 9);

CALL TongHopBaoCaoNgay('2020/01/15', 0);
CALL TongHopBaoCaoNgay('2020/02/15', 12);
CALL TongHopBaoCaoNgay('2020/03/15', 3);
CALL TongHopBaoCaoNgay('2020/04/15', 0);
CALL TongHopBaoCaoNgay('2020/05/15', 0);
CALL TongHopBaoCaoNgay('2020/06/15', 0);
CALL TongHopBaoCaoNgay('2020/07/15', 6);
CALL TongHopBaoCaoNgay('2020/08/15', 0);
CALL TongHopBaoCaoNgay('2020/09/15', 1);
CALL TongHopBaoCaoNgay('2020/10/15', 0);
CALL TongHopBaoCaoNgay('2020/11/15', 12);
CALL TongHopBaoCaoNgay('2020/12/15', 3);

CALL TongHopBaoCaoNgay('2021/01/15', 12);
CALL TongHopBaoCaoNgay('2021/02/15', 6);
CALL TongHopBaoCaoNgay('2021/03/15', 0);
CALL TongHopBaoCaoNgay('2021/04/15', 0);
CALL TongHopBaoCaoNgay('2021/05/15', 3);

SELECT * FROM BAOCAONGAY;

/*========== Báo cáo tháng ==========*/
CALL TongHopBaoCaoThang('2016/01/15', 0);
CALL TongHopBaoCaoThang('2016/02/15', 1);
CALL TongHopBaoCaoThang('2016/03/15', 3);
CALL TongHopBaoCaoThang('2016/04/15', 0);
CALL TongHopBaoCaoThang('2016/05/15', 1);
CALL TongHopBaoCaoThang('2016/06/15', 3);
CALL TongHopBaoCaoThang('2016/07/15', 1);
CALL TongHopBaoCaoThang('2016/08/15', 1);
CALL TongHopBaoCaoThang('2016/09/15', 6);
CALL TongHopBaoCaoThang('2016/10/15', 0);
CALL TongHopBaoCaoThang('2016/11/15', 3);
CALL TongHopBaoCaoThang('2016/12/15', 1);
                       
CALL TongHopBaoCaoThang('2017/01/15', 6);
CALL TongHopBaoCaoThang('2017/02/15', 12);
CALL TongHopBaoCaoThang('2017/03/15', 3);
CALL TongHopBaoCaoThang('2017/04/15', 0);
CALL TongHopBaoCaoThang('2017/05/15', 1);
CALL TongHopBaoCaoThang('2017/06/15', 0);
CALL TongHopBaoCaoThang('2017/07/15', 0);
CALL TongHopBaoCaoThang('2017/08/15', 3);
CALL TongHopBaoCaoThang('2017/09/15', 6);
CALL TongHopBaoCaoThang('2017/10/15', 1);
CALL TongHopBaoCaoThang('2017/11/15', 0);
CALL TongHopBaoCaoThang('2017/12/15', 12);
                       
CALL TongHopBaoCaoThang('2018/01/15', 1);
CALL TongHopBaoCaoThang('2018/02/15', 12);
CALL TongHopBaoCaoThang('2018/03/15', 6);
CALL TongHopBaoCaoThang('2018/04/15', 3);
CALL TongHopBaoCaoThang('2018/05/15', 1);
CALL TongHopBaoCaoThang('2018/06/15', 1);
CALL TongHopBaoCaoThang('2018/07/15', 6);
CALL TongHopBaoCaoThang('2018/08/15', 12);
CALL TongHopBaoCaoThang('2018/09/15', 3);
CALL TongHopBaoCaoThang('2018/10/15', 1);
CALL TongHopBaoCaoThang('2018/11/15', 1);
CALL TongHopBaoCaoThang('2018/12/15', 3);
                       
CALL TongHopBaoCaoThang('2019/01/15', 9);
CALL TongHopBaoCaoThang('2019/02/15', 3);
CALL TongHopBaoCaoThang('2019/03/15', 9);
CALL TongHopBaoCaoThang('2019/04/15', 6);
CALL TongHopBaoCaoThang('2019/05/15', 0);
CALL TongHopBaoCaoThang('2019/06/15', 1);
CALL TongHopBaoCaoThang('2019/07/15', 12);
CALL TongHopBaoCaoThang('2019/08/15', 0);
CALL TongHopBaoCaoThang('2019/09/15', 9);
CALL TongHopBaoCaoThang('2019/10/15', 1);
CALL TongHopBaoCaoThang('2019/11/15', 1);
CALL TongHopBaoCaoThang('2019/12/15', 3);
                       
CALL TongHopBaoCaoThang('2020/01/15', 3);
CALL TongHopBaoCaoThang('2020/02/15', 6);
CALL TongHopBaoCaoThang('2020/03/15', 1);
CALL TongHopBaoCaoThang('2020/04/15', 9);
CALL TongHopBaoCaoThang('2020/05/15', 12);
CALL TongHopBaoCaoThang('2020/06/15', 1);
CALL TongHopBaoCaoThang('2020/07/15', 3);
CALL TongHopBaoCaoThang('2020/08/15', 0);
CALL TongHopBaoCaoThang('2020/09/15', 9);
CALL TongHopBaoCaoThang('2020/10/15', 0);
CALL TongHopBaoCaoThang('2020/11/15', 6);
CALL TongHopBaoCaoThang('2020/12/15', 1);
                       
CALL TongHopBaoCaoThang('2021/01/15', 12);
CALL TongHopBaoCaoThang('2021/02/15', 1);
CALL TongHopBaoCaoThang('2021/03/15', 3);
CALL TongHopBaoCaoThang('2021/04/15', 6);
CALL TongHopBaoCaoThang('2021/05/15', 0);

SELECT * FROM BAOCAOTHANG;