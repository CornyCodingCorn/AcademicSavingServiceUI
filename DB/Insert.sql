-- Thời gian từ 2016 đến 2021
-- Thay đổi quy định 6 - 12 tháng 1 lần
-- Tạo sổ tiết kiệm mới mỗi 3 tháng
-- Thêm cái phiếu rút và gửi tiền
-- 1 triệu : 1000000
/*========== Error Table ==========*/
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

/*==========Quy định==========*/
DELETE FROM QUYDINH;

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
DELETE FROM LoaiKyHan;

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

/*==========Chi nhánh==========*/
DELETE FROM CHINHANH;

INSERT INTO CHINHANH(TenCN, DiaChi, SDT) VALUE ('Chi nhánh TP.HCM Quận 1 NKKN', '54-56 Nam Kỳ Khởi Nghĩa, Quận 1, Thành phố Hồ Chí Minh', '02839147841');
INSERT INTO CHINHANH(TenCN, DiaChi, SDT) VALUE ('Chi nhanh TP.HCM Quận 1 LTT', '231-233 Lê Thánh Tôn, Phường Bến Thành, Quận 1, Thành phố Hồ Chí Minh', '02854042568');
INSERT INTO CHINHANH(TenCN, DiaChi, SDT) VALUE ('Chi nhanh TP.HCM Quận 1 VVK', '428 Võ Văn Kiệt, Phường Cô Giang, Quận 1, Thành phố Hồ Chí Minh', '02838968726');

INSERT INTO CHINHANH(TenCN, DiaChi, SDT) VALUE ('Chi nhánh TP.HCM Quận Gò Vấp NO', '3 Nguyễn Oanh, Phường 17, Gò Vấp, Thành phố Hồ Chí Minh', '02343571175');

INSERT INTO CHINHANH(TenCN, DiaChi, SDT) VALUE ('Chi nhanh TP.HCM Quận Thủ Đức VVN', '192 Võ Văn Ngân, Bình Thọ, Thủ Đức, Thành phố Hồ Chí Minh', '02437264363');
INSERT INTO CHINHANH(TenCN, DiaChi, SDT) VALUE ('Chi nhanh TP.HCM Quận Thủ Đức DXH', '116 Đỗ Xuân Hợp, Phước Long B, Quận 9, Thành phố Hồ Chí Minh', '02438226060');

SELECT * FROM CHINHANH;

/*==========Giờ làm việc==========*/
DELETE FROM GIOLAMVIEC;

INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('MON', 1, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('TUE', 1, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('WEN', 1, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('THU', 1, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('FRI', 1, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('SAT', 1, '7:30:00', '11:30:00', '13:00:00', '15:00:00');

INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('MON', 2, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('TUE', 2, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('WEN', 2, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('THU', 2, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('FRI', 2, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('SAT', 2, '7:30:00', '11:30:00', '13:00:00', '15:00:00');

INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('MON', 3, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('TUE', 3, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('WEN', 3, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('THU', 3, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('FRI', 3, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('SAT', 3, '7:30:00', '11:30:00', '13:00:00', '15:00:00');

INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('MON', 4, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('TUE', 4, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('WEN', 4, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('THU', 4, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('FRI', 4, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('SAT', 4, '7:30:00', '11:30:00', '13:00:00', '15:00:00');

INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('MON', 5, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('TUE', 5, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('WEN', 5, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('THU', 5, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('FRI', 5, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('SAT', 5, '7:30:00', '11:30:00', '13:00:00', '15:00:00');

INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('MON', 6, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('TUE', 6, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('WEN', 6, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('THU', 6, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('FRI', 6, '7:30:00', '11:30:00', '13:00:00', '17:00:00');
INSERT INTO GIOLAMVIEC(NgayLamViec, MaCN, GioLamCaSang, GioNghiCaSang, GioLamCaChieu, GioNghiCaChieu) 
VALUE ('SAT', 6, '7:30:00', '11:30:00', '13:00:00', '15:00:00');

SELECT * FROM GIOLAMVIEC;

/*==========Nhân viên==========*/
DELETE FROM NHANVIEN;

INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Đào Việt Thắng', '0342853438', '160 Pasteur, Bến Nghé, Quận 1, Thành phố Hồ Chí Minh', '034048979668', '2016/01/01', 1);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Quách Xuân Kiên', '0130552752', '138 Nam Kỳ Khởi Nghĩa, Bến Nghé, Quận 1, Thành phố Hồ Chí Minh', '033934996725', '2016/01/01', 1);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Đặng Ðông Phương', '0439807477', '220 Đường Nguyễn Thị Minh Khai, Phường 6, Quận 3, Thành phố Hồ Chí Minh', '063499136887', '2016/01/01', 1);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Phan Phương Anh', '0240785823', '12 Nguyễn Cảnh Chân, Quận 1, Thành phố Hồ Chí Minh', '077589558324', '2016/01/01', 1);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Lý Bảo Thúy', '0854626125', '42 Cô Bắc, Phường Cầu Ông Lãnh, Quận 1, Thành phố Hồ Chí Minh', '049696350382', '2016/01/01', 1);

INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Ngư Hùng Phong', '0377554779', '48 Võ Văn Tần, Phường 6, Quận 3, Thành phố Hồ Chí Minh', '051053442803', '2016/01/01', 2);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Quang Ngọc Mai', '0700242677', '260 Võ Văn Tần, Phường 5, Quận 3, Thành phố Hồ Chí Minh', '025583866727', '2016/01/01', 2);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Lý Hồng Diệp', '0129042204', '28 Phạm Ngọc Thạch, Phường 6, Quận 3, Thành phố Hồ Chí Minh', '041208702172', '2016/01/01', 2);

INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Liễu Thục Trinh', '0425927765', '584 Âu Cơ, Phường 10, Tân Bình, Thành phố Hồ Chí Minh', '045640118617', '2016/01/01', 3);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Nguyễn Ngọc Hoàn', '0869101786', '10 Hoàng Diệu, Phường 12, Quận 4, Thành phố Hồ Chí Minh', '064691003847', '2016/01/01', 3);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Thủy Giang Thanh', '0379664658', 'Hẻm 200 Xóm Chiếu, Phường 14, Quận 4, Thành phố Hồ Chí Minh', '038294118438', '2016/01/01', 3);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Ngư Thanh Hà', '0244118812', '37 Vĩnh Khánh, Phường 8, Quận 4, Thành phố Hồ Chí Minh', '086726357482', '2016/01/01', 3);

INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Vũ Thăng Long', '0847134099', '379 Thống Nhất, Phường 11, Gò Vấp, Thành phố Hồ Chí Minh', '098682368807', '2016/01/01', 4);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Võ Minh Kiệt', '0901211603', '2 Nguyễn Văn Lượng, Phường 10, Gò Vấp, Thành phố Hồ Chí Minh', '039503405671', '2016/01/01', 4);

INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Đỗ Nguyệt Lan', '0319969614', ' 21 Đường Số 3, Hiệp Bình Phước, Thủ Đức, Thành phố Hồ Chí Minh', '012049221386', '2016/01/01', 5);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Trương Hải Sơn', '0778688264', '62 Đường Số 3, Trường Thọ, Thủ Đức, Thành phố Hồ Chí Minh', '028481963276', '2016/01/01', 5);

INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Mạc Hữu Cương', '0540937700', '40 Đặng Văn Bi, Bình Thọ, Thủ Đức, Thành phố Hồ Chí Minh', '086222134743', '2016/01/01', 6);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Đặng Hồng Hà', '0569921817', '26 Kha Vạn Cân, Linh Đông, Thủ Đức, Thành phố Hồ Chí Minh', '062626264556', '2016/01/01', 6);
INSERT INTO NHANVIEN(HoTen, SDT, DiaChi, CMND, NgayVaoLam, NoiLamViec)
VALUES('Dương Ái Khanh', '0698656091', '141 Thống Nhất, Bình Thọ, Thủ Đức, Thành phố Hồ Chí Minh', '076673102852', '2016/01/01', 6);

SELECT * FROM NHANVIEN;

/*==========Khách hàng==========*/
DELETE FROM KHACHHANG;

INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Phạm Hà Liên', '0831126759', '149 Nguyễn Tri Phương, Phường 8, Quận 5, Thành phố Hồ Chí Minh', '038337899317', 1);
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Đoàn Nhã Lý', '0433960399', '64 Nguyễn Thời Trung, Phường 6, Quận 5, Thành phố Hồ Chí Minh', '057760171219', 1);
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Nguyễn Quang Hải', '0966643448', '4 Lý Thường Kiệt, Phường 12, Quận 5, Thành phố Hồ Chí Minh', '067268027033', 1);
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Trầm Kiên Bình', '0289223796', '832 Huỳnh Tấn Phát, Phú Thuận, Quận 7, Thành phố Hồ Chí Minh', '096570502795', 1);

INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Thân Công Hậu', '0892522397', '15 Lâm Văn Bền, Tân Quy, Quận 7, Thành phố Hồ Chí Minh', '085842907170', 2);
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Nguyễn Trọng Vinh', '0755423139', '34 Bá Trạc, Phường 2, Quận 8, Thành phố Hồ Chí Minh', '013671098619', 2);
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Vũ Bảo Trúc', '0732349970', '870 Tạ Quang Bửu, Phường 5, Quận 8, Thành phố Hồ Chí Minh', '047424607765', 2);

INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Đặng Thành Châu', '0459068869', '94 Ngô Quyền, Phường 5, Quận 10, Phường 6, Quận 10, Thành phố Hồ Chí Minh', '067327095361', 3);
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Dương Mỹ Vân', '0452190962', '16 Lê Hồng Phong, Phường 12, Quận 10, Thành phố Hồ Chí Minh', '032505244096', 3);

INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Chu Kim Toàn', '0970238418', '88 Hà Huy Giáp, Thạnh Lộc, Quận 12, Thành phố Hồ Chí Minh', '029865643209', 4);
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Dương Khắc Thành', '0112019039', '181 Nguyễn Thị Đặng, Tân Thới Hiệp, Quận 12, Thành phố Hồ Chí Minh', '069921609940', 4);
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Phạm Chí Công', '0480047194', '98a2 Nguyễn Thị Đặng, Hiệp Thành, Quận 12, Thành phố Hồ Chí Minh', '057077252279', 4);

INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Phạm Thanh Đan', '0317657970', '54 Hà Huy Giáp, Thạnh Lộc, Quận 12, Thành phố Hồ Chí Minh', '046064694856', 5);
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Hoàng Phượng Loan', '0127187121', '219C Lê Quang Sung, Phường 6, Quận 6, Thành phố Hồ Chí Minh', '079787412158', 5);

INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Đinh Minh Trí', '0700019229', 'Hẻm 942 Kha Vạn Cân, Trường Thọ, Thủ Đức, Thành phố Hồ Chí Minh', '082654211937', 6);
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Nguyễn Xuân Khoa', '0359736526', '252 Đô Ngọc Vân, Linh Đông, Thủ Đức, Thành phố Hồ Chí Minh', '035719129304', 6);
INSERT INTO KHACHHANG(HoTen, SDT, DiaChi, CMND, NoiDangKy)
VALUES('Huỳnh Hải Phong', '0433233328', '146 Hoàng Diệu 2, Phường Linh Trung, Thủ Đức, Thành phố Hồ Chí Minh', '041898885155', 6);

SELECT * FROM KHACHHANG;

/*==========Sổ tiết kiệm==========*/
DELETE FROM SOTIETKIEM;

CALL ThemSoTietKiem(1, 0,  1000000, '2016/01/15');
CALL ThemSoTietKiem(1, 12,  1000000, '2017/01/01');

CALL ThemSoTietKiem(2, 0,  1000000, '2016/04/15');
CALL ThemSoTietKiem(3, 6,  1000000, '2016/09/15');
CALL ThemSoTietKiem(4, 6,  1000000, '2017/04/15');

CALL ThemSoTietKiem(5, 0,  1000000, '2016/05/15');
CALL ThemSoTietKiem(5, 6,  1000000, '2018/09/15');

CALL ThemSoTietKiem(6, 12,  1000000, '2019/11/15');
CALL ThemSoTietKiem(7, 3,  1000000, '2016/08/15');
CALL ThemSoTietKiem(8, 6,  1000000, '2020/04/15');
CALL ThemSoTietKiem(9, 3,  1000000, '2016/03/15');
CALL ThemSoTietKiem(10, 1,  1000000, '2017/01/15');
CALL ThemSoTietKiem(11, 1,  1000000, '2017/01/15');

CALL ThemSoTietKiem(12, 0,  1000000, '2018/02/15');
CALL ThemSoTietKiem(12, 1,  1000000, '2016/01/15');
CALL ThemSoTietKiem(12, 3,  1000000, '2017/08/15');
CALL ThemSoTietKiem(12, 9,  1000000, '2018/05/15');

CALL ThemSoTietKiem(13, 3,  1000000, '2018/08/15');
CALL ThemSoTietKiem(14, 12,  1000000, '2019/11/15');
CALL ThemSoTietKiem(15, 6,  1000000, '2020/12/15');
CALL ThemSoTietKiem(16, 3,  1000000, '2016/12/15');
CALL ThemSoTietKiem(17, 1,  1000000, '2020/01/15');

SELECT * FROM SOTIETKIEM;

/*==========Ủy quyền==========*/
DELETE FROM UYQUYEN;

INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(1, 1, '2016/01/15', '2016/10/01');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(1, 2, '2017/01/01', '2018/01/01');

INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(2, 3, '2016/04/15', '2016/10/01');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(3, 4, '2016/09/15', '2017/05/30');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(4, 5, '2017/04/15', '2017/10/15');

INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(5, 6, '2016/05/15', '2017/01/01');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(5, 7, '2018/09/15', '2019/06/15');

INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(6, 8, '2019/11/15', '2020/11/15');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(7, 9, '2016/08/15', '2017/02/15');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(8, 10, '2020/04/15', '2020/11/15');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(9, 11, '2016/03/15', '2016/07/15');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(10, 12, '2017/01/15', '2017/04/15');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(11, 13, '2017/01/15', '2017/03/15');

INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(12, 14, '2018/02/15', '2018/06/15');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(12, 15, '2016/01/15', '2016/05/15');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(12, 16, '2017/08/15', '2018/02/15');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(12, 17, '2018/05/15', '2019/05/15');

INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(13, 18, '2018/08/15', '2019/02/15');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(14, 19, '2019/11/15', '2020/12/15');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(15, 20, '2020/12/15', NULL);
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(16, 21, '2016/12/15', '2017/12/15');
INSERT INTO UYQUYEN(MAKH, MASO, NGAYTAO, NGAYNGUNGSUDUNG)
VALUES(17, 22, '2020/01/15', '2020/04/15');

SELECT * FROM UYQUYEN;

/*========== Phiếu ==========*/
DELETE FROM PHIEU;

-- (IN MaSo INT, IN SoTien DECIMAL(15, 2), IN MaKH INT, IN MaNV INT, IN GhiChu TEXT, IN NgayTao DATE)
-- (IN MaSo INT, IN MaKH INT, IN MaNV INT, IN GhiChu TEXT, IN NgayTao DATE)

CALL ThemPhieu(1, 100000, 1, 2, 'Some things', '2016/03/01');
CALL ThemPhieu(1, 100000, 1, 1, 'Some things', '2016/05/07');
CALL ThemPhieu(1, 500000, 1, 1, 'Some things', '2016/06/01');
CALL ThemPhieu(1, -100000, 1, 1, 'Some things', '2016/06/15');
CALL RutHetTien(1, 1, 2, 'The end game', '2016/10/01');

CALL RutHetTien(2, 1, 3, 'The end game', '2018/01/01');

CALL ThemPhieu(3, 100000, 2, 2, 'Some things', '2016/04/20');
CALL ThemPhieu(3, -100000, 2, 1, 'Some things', '2016/05/07');
CALL RutHetTien(3, 2, 4, 'The end game', '2016/10/01');

CALL ThemPhieu(4, 100000, 3, 2, 'Some things', '2017/04/20');
CALL RutHetTien(4, 3, 2, 'The end game', '2017/05/30');

CALL RutHetTien(5, 4, 4, 'The end game', '2017/10/15');

CALL ThemPhieu(6, 400000, 5, 8, 'Some things', '2016/05/15');
CALL ThemPhieu(6, -100000, 5, 8, 'Some things', '2016/07/15');
CALL RutHetTien(6, 5, 6, 'The end game', '2017/01/01');

CALL ThemPhieu(7, 200000, 5, 7, 'Some things', '2019/04/15');
CALL RutHetTien(7, 5, 5, 'The end game', '2019/06/15');

CALL RutHetTien(8, 6, 7, 'The end game', '2020/11/15');
CALL RutHetTien(9, 7, 6, 'The end game', '2017/02/15');
CALL RutHetTien(10, 8, 12, 'The end game', '2020/11/15');
CALL RutHetTien(11, 9, 4, 'The end game', '2016/7/15');
CALL RutHetTien(12, 10, 14, 'The end game', '2017/04/15');
CALL RutHetTien(13, 11, 9, 'The end game', '2017/03/15');

CALL ThemPhieu(14, 200000, 12, 7, 'Some things', '2018/03/15');
CALL RutHetTien(14, 12, 2, 'The end game', '2018/06/15');

CALL ThemPhieu(15, 200000, 12, 4, 'Some things', '2016/02/15');
CALL RutHetTien(15, 12, 2, 'The end game', '2016/05/15');

CALL RutHetTien(16, 12, 2, 'The end game', '2018/02/15');

CALL RutHetTien(17, 13, 2, 'The end game', '2019/02/15');
CALL RutHetTien(18, 13, 2, 'The end game', '2019/02/15');
CALL RutHetTien(19, 14, 9, 'The end game', '2019/05/15');

CALL RutHetTien(21, 16, 5, 'The end game', '2017/12/15');

CALL ThemPhieu(22, 200000, 1, 4, 'Some things', '2020/03/15');
CALL RutHetTien(22, 2, 2, 'The end game', '2020/04/15');

SELECT * FROM PHIEU;

/*========== Báo cáo ngày ==========*/

CALL TongHopBaoCaoNgay('2016/04/20', 0);
CALL TongHopBaoCaoNgay('2017/10/15', 1);
CALL TongHopBaoCaoNgay('2017/12/15', 3);
CALL TongHopBaoCaoNgay('2020/04/15', 6);
CALL TongHopBaoCaoNgay('2019/02/15', 9);
CALL TongHopBaoCaoNgay('2020/11/15', 12);

SELECT * FROM BAOCAONGAY;

/*========== Báo cáo tháng ==========*/

CALL TongHopBaoCaoThang('2018/06/07', 0);
CALL TongHopBaoCaoThang('2018/06/07', 1);
CALL TongHopBaoCaoThang('2017/09/07', 3);
CALL TongHopBaoCaoThang('2018/03/07', 6);
CALL TongHopBaoCaoThang('2019/06/07', 9);
CALL TongHopBaoCaoThang('2020/03/07', 12);

SELECT * FROM BAOCAOTHANG;