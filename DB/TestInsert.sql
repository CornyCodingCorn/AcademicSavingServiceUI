/*=================================================================================Error_And_Description============================================================================*/
-- Tất cả các script chạy bình thường

/*====================Lệnh_Insert=======================*/
-- ErrorTable : bình thường
-- QuiDinh : bình thường
-- ChiNhanh : bình thường
-- GIOLAMVIEC : bình thường
-- NHANVIEN : bình thường
-- KHACHHANG : bình thường
-- UYQUYEN : thiếu trigger
/*====================Các_Functions--===================*/
-- LayGhiChuLoi : bình thường
-- LaySoTienNapNhoNhat : bình thường
-- LaySoTienMoTaiKhoanNhoNhat : bình thường
-- LaySoNgayKhongKyHanNhoNhat : bình thường
-- LayLaiSuatPhuHopCuaKyHan : trả về MaKyHan *** chú ý dữ liệu trả về
-- LaiSuatKhongKyHan : bình thường
-- KiemTraKyHan : bình thường
-- LayLaiSuatKhongKyHanTrongKhoangThoiGian : bình thường
-- CoTheCapNhatLoaiKyHan :
-- BatDauCapNhatLoaiKyHan : 
-- KetThucCapNhatLoaiKyHan :
-- CoTheCapNhatSoTietKiem : 
-- BatDauCapNhatSoTietKiem :
-- KetThucCapNhatSoTietKiem :

/*====================Các_Triggers_Và_Procedures======================*/
/*=====GLOBAL=====*/
-- ThrowException : bình thường
-- ThrowMessage : 
-- BatDauCapNhatLoaiKyHan : bình thường
-- KetThucCapNhatLoaiKyHan : bình thường
-- BatDauCapNhatLoaiKyHan : bình thường
-- KetThucCapNhatLoaiKyHan : bình thường

/*=====QuiDinh=====*/
-- AutofillQuyDinh : bình thường
-- BeforeUpdateQuyDinh : bình thường
-- BeforeDeleteQuyDinh :

/*=====LoaiKyHan=====*/
-- ThemKyHan : bình thường
-- NgungSuDungKyHan : bình thường
-- LoaiKyHanBeforeInsert : bình thường
-- LoaiKyHanBeforeUpdate : bình thường
-- LoaiKyHanBeforeDelete : 

/*=====KhachHang=====*/
-- KhachHangInsertTrigger : bình thường

/*=====SoTietKiem=====*/
-- UpdateSoTietKiem : bình thường
-- ThemSoTietKiem : không báo lỗi khi loại kỳ hạn không hợp lí *** cần kiểm tra
-- SoTietKiemBeforeUpdate :
-- SoTietKiemInsert : 
-- SoTietKiemDelete :

/*=====Phieu=====*/
-- ThemPhieu : bình thường
-- RutHetTien : bình thường
-- BeforeInsertPhieu : bình thường
-- BeforeDeletePhieu :
-- BeforeUpdatePhieu :

/*=====BaoCaoNgay=====*/
-- TongHopBaoCaoNgay : bình thường

/*=====BaoCaoThang=====*/
-- TongHopBaoCaoThang : bình thường

/*===================================================================================ErrorTable==============================================================================*/
TRUNCATE TABLE ErrorTable;

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('TK000', 'Thao tác với sổ tiêt kiệm thành công');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('TK001', 'Số tiền tạo tài khoản ít hơn số tiền tối thiểu trong quy định');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('TK002', 'Loại kỳ hạn này không tồn tại hoặc không còn được sử dụng');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('TK003', 'Không được update sổ tiêt kiệm');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('TK004', 'Gọi update tới ngày trong quá khứ hay trong tương lai');

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PG000', 'Gửi tiền thành công');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PG001', 'Số tiền gửi nhỏ hơn số tiền cho phép');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PG002', 'Thêm phiếu gửi không thành công');

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PR000', 'Rút tiền thành công');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PR001', 'Không thể rút tiền trước kỳ hạn hoặc không thể rút tiền trước thời gian tối thiểu cho không kỳ hạn');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PR002', 'Rút tiền loại có kỳ hạn phải rút hết');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PR003', 'Tài khoản không đủ tiền để rút');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PR004', 'Thêm phiếu rút tiền không thành công');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PR005', 'Không thể gửi thêm tiền trước kỳ hạn');

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PH001', 'Tài khoản đã đóng hoặc không tồn tại');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PH002', 'Phải xóa theo thứ tự trong cùng ngày');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PH003', 'Chỉ được tạo phiếu sau khi tạo tài khoản');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PH004', 'Chỉ chủ tài khoản tiết kiệm hoặc những người được ủy quyền gưi/rút tiền');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PH005', 'Không được cập nhật phiếu');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('PH006', 'Mã ủy quyền trong phiếu không hợp lệ');

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('QD000', 'Thêm/Xóa quy định thành công');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('QD001', 'Không được sửa quy định');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('QD002', 'Có tài khoản tiết kiệm hoặc phiểu sử dụng quy định này');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('QD003', 'Không được thêm quy định vào quá khứ');

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('KY000', 'Thêm xóa kỳ hạn thành công');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('KY001', 'Thêm kỳ hạn không kỳ hạn không hợp lý');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('KY002', 'Phải ngưng sử dụng loại kỳ hạn cùng kỳ hạn trước rồi mới được thêm vào');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('KY003', 'Không thể xóa vì có tài khoản tiết kiệm được tạo sau kỳ hạn này');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('KY004', 'Không cập nhât loại kỳ hạn');

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('UQ001', 'Không được cập nhật Ủy quyền');
INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('UQ002', 'Uy quyền cho khách hàng này đã tồn tại và chưa ngưng hoạt động');

INSERT INTO ErrorTable (MaLoi, GhiChu) VALUES('BC001', 'Không cập nhât báo cáo');

SELECT * FROM ErrorTable;
-- Bình thường

SELECT MALOI, LayGhiChuLoi(MALOI)
FROM ErrorTable;
-- Test Function : bình thường 

/*===================================================================================QuiDinh==============================================================================*/
TRUNCATE TABLE QUYDINH;

INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(90000, 900000, 14, '2020/02/07');
INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(10000, 1000000, 10, '2021/06/04');
INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(100000, 1000000, 15, '2021/06/06');
INSERT INTO QUYDINH (SoTienNapNhoNhat, SoTienMoTaiKhoanNhoNhat, SoNgayToiThieu, NgayTao)
VALUES(90000, 900000, 14, '2021/06/07');

SELECT * FROM QUYDINH;
-- Bình thường // Đã thử trường hợp tạo qui định trong quá khứ

UPDATE QUYDINH
SET SoTienNapNhoNhat = 1000
WHERE quydinh.NgayTao = '2020/02/07';
-- Test Trigger : bình thường

SELECT NgayTao, LaySoNgayKhongKyHanNhoNhat(NgayTao), LaySoTienMoTaiKhoanNhoNhat(NgayTao), LaySoTienNapNhoNhat(NgayTao)
FROM QUYDINH;
-- Test Function : bình thường 

/*===================================================================================LoaiKyHan==============================================================================*/
DELETE FROM LOAIKYHAN;

CALL ThemKyHan(6, 5, '2020/01/01', '2021/02/03');
CALL ThemKyHan(6, 5, '2021/04/01', '2021/08/03');
CALL ThemKyHan(3, 5, '2021/01/01', '2021/02/03');
CALL ThemKyHan(0, 1.1, '2021/01/07', NULL);
CALL ThemKyHan(0, 2.2, '2021/02/07', NULL);
CALL ThemKyHan(0, 3.3, '2021/03/07', NULL);
CALL ThemKyHan(0, 4.5, '2021/05/07', NULL);
-- bình thường

CALL NgungSuDungKyHan(0, '2021/06/06');
-- bình thường

UPDATE LOAIKYHAN
SET LaiSuat = 6
WHERE MaKyHan = 8;
-- kiểm tra trigger


SELECT * FROM LOAIKYHAN;

-- '2020/01/01' '2021/02/03'
SELECT MaKyHan, LayLaiSuatPhuHopCuaKyHan(KyHan, '2020/04/01'), -- Trả về MaKyHan ?
		LaiSuatKhongKyHan(), -- bình thường
		KiemTraKyHan(MaKyHan, '2021/04/01'), -- bình thường
		LayLaiSuatKhongKyHanTrongKhoangThoiGian('2020-01-01','2021-02-03') -- bình thường
FROM LoaiKyHan;

SELECT MaKyHan, NgayTao, NgayNgungSuDung ,KiemTraKyHan(MaKyHan, '2021/04/01')
FROM LoaiKyHan;

/*===================================================================================ChiNhanh==============================================================================*/
INSERT INTO CHINHANH(TenCN, DiaChi, SDT) VALUE ('Chi nhanh TP.HCM', '06 duong Luong The Vinh, Quan 7, Thanh Pho Ho Chi Minh', '093999999999');
INSERT INTO CHINHANH(TenCN, DiaChi, SDT) VALUE ('Chi nhanh TP.DaLat', '06 duong Gi Do, Quan GD, Thanh Pho Da Lat', '093912312939');
INSERT INTO CHINHANH(TenCN, DiaChi, SDT) VALUE ('Chi nhanh Fresno', '94 Edgewater Street Fresno, CA 93706', '873931029999');
INSERT INTO CHINHANH(TenCN, DiaChi, SDT) VALUE ('Chi nhanh Bloomfield', '887 Wagon DriveWest Bloomfield, MI 48322', '091278129819');
INSERT INTO CHINHANH(TenCN, DiaChi, SDT) VALUE ('Chi nhanh Goodlettsville', '566 Longbranch Avenue Goodlettsville, TN 37072', '091321398989');

SELECT * FROM CHINHANH;
-- bình thường

/*===================================================================================GioLamViec==============================================================================*/
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('MON', 1, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('MON', 2, '7:00:00', '12:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('WEN', 3, '7:20:00', '11:30:00', '12:00:00', '19:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('SAT', 4, '7:00:00', '10:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('SUN', 5, '8:00:00', '10:00:00', '13:00:00', '14:00:00');

SELECT * FROM GIOLAMVIEC;
-- bình thường

/*===================================================================================NhanVien==============================================================================*/
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Phuc Nguyen', '093840000', 'Quan 7 Ho Chi Minh', '000000001', '2001/01/01', 1);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Do Phi Long', '094206900', 'Quan 8 Ho Chi Minh', '000000022', '2012/01/02', 2);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Nguyen Bao Duy', '093840000', 'Quan 9 Ho Chi Minh', '0000211001', '2000/02/29', 3);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Hoang Phuc', '098940205', 'Quan 1 Ho Chi Minh', '0210011001', '2020/02/29', 4);

SELECT * FROM NHANVIEN;
-- bình thường

/*===================================================================================KhachHang==============================================================================*/
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Nguyen Ngoc Tuan', '093840000', 'Quan 7 Ho Chi Minh', '000030001', 1);
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Vu Thi Thanh Truc', '094206900', 'Quan 8 Ho Chi Minh', '000050022', 1);
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Do Viet Huy', '093840000', 'Quan 9 Ho Chi Minh', '0020211001', 3);

SELECT * FROM KHACHHANG;
-- bình thường // đã thử trigger KhachHangInsertTrigger

/*===================================================================================SoTietKiem==============================================================================*/
CALL ThemSoTietKiem(1, 6,  1000000, '2021/4/1');
CALL ThemSoTietKiem(1, 6,  1, '2021/4/1');
-- bình thường // đã thử trigger SoTietKiemInsert

CALL ThemSoTietKiem(1, NULL,  2000000, '2021/2/1');
INSERT INTO SOTIETKIEM (MAKH, NGAYTAO, MAKYHAN, SOTIENBANDAU)
VALUE (1, '2021/2/1', NULL, 1000000);
-- không báo lỗi khi loại kỳ hạn không hợp lí

CALL UpdateSoTietKiem(1, '2021/5/5');
-- bình thường
Select * From LOAIKYHAN WHERE KyHan = 2 AND NgayTao <= '2021/02/01';
SELECT * FROM SOTIETKIEM;

/*===================================================================================UyQuyen==============================================================================*/
DELETE FROM UYQUYEN;

INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(1, 1, '2001/01/01', '2021/01/01');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(2, 5, '2001/02/01', '2012/01/02');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(3, 6, '2001/01/01', '2000/02/29');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(1, 5, '2001/01/01', '2021/01/01');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(1, 6, '2001/01/01', '2021/01/01');

SELECT * FROM UYQUYEN;
-- bình thường

/*===================================================================================Phieu==============================================================================*/
DELETE FROM PHIEU;
CALL ThemPhieu(6, 100000, 1, 2, 'Yeah send this to the prison', '2021/05/06');
CALL ThemPhieu(6, 100000, 1, 2, 'Yeah send this to the prison', '2021/05/10');
CALL RutHetTien(6, 1, 2, 'Yeah on second throught', '2021/05/11');
-- bình thường
CALL ThemPhieu(7, 100000, 1, 2, 'Yeah send this to the prison', '2021/05/05');
CALL ThemPhieu(7, 100000, 1, 2, 'Yeah send this to the prison', '2021/05/05');
CALL RutHetTien(7, 1, 2, 'Yeah on second throught', '2021/05/05');

SELECT * FROM PHIEU;

/*===================================================================================BaoCaoNgay==============================================================================*/
CALL TongHopBaoCaoNgay('2021/05/11', 0);
CALL TongHopBaoCaoNgay('2021/05/05', 0);
SELECT * FROM BAOCAONGAY;

/*===================================================================================BaoCaoThang==============================================================================*/
CALL TongHopBaoCaoThang('2021/05/05', 0);
SELECT * FROM BAOCAOTHANG;