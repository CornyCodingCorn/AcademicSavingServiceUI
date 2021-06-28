-- Thời gian từ 2016 đến 2021
-- Thay đổi quy định 6 - 12 tháng 1 lần
-- Tạo sổ tiết kiệm mới mỗi 3 tháng
-- Thêm cái phiếu rút và gửi tiền
-- 1 triệu : 1000000

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
-- ThemSoTietKiem(IN MaKH INT, IN KyHan TINYINT, IN SoTienBanDau DECIMAL(15, 2), IN NgayTao DATE)
-- 2016
CALL ThemSoTietKiem(17, 12, 1000000, '2016/01/03'); --
CALL ThemSoTietKiem(12, 1, 5000000, '2016/01/15'); --
CALL ThemSoTietKiem(1, 0, 2000000, '2016/02/15'); --
CALL ThemSoTietKiem(9, 3, 4000000, '2016/03/15'); --
CALL ThemSoTietKiem(5, 3, 5000000, '2016/03/23'); --
CALL ThemSoTietKiem(2, 3, 9000000, '2016/04/07'); --
CALL ThemSoTietKiem(7, 1, 5000000, '2016/09/05'); --
CALL ThemSoTietKiem(3, 6, 9000000, '2016/09/15'); --
CALL ThemSoTietKiem(15, 3, 7000000, '2016/10/12'); --
CALL ThemSoTietKiem(16, 3, 8000000, '2016/12/15'); -- 10

-- 2017
CALL ThemSoTietKiem(9, 12, 1000000, '2017/01/01'); --
CALL ThemSoTietKiem(16, 12, 10000000, '2017/02/05'); --
CALL ThemSoTietKiem(4, 6, 1000000, '2017/02/25'); --
CALL ThemSoTietKiem(11, 3, 1000000, '2017/03/07'); --
CALL ThemSoTietKiem(10, 1, 9000000, '2017/04/20'); --
CALL ThemSoTietKiem(8, 6, 4000000, '2017/07/16'); --
CALL ThemSoTietKiem(12, 3, 5000000, '2017/08/08'); --
CALL ThemSoTietKiem(11, 0, 7000000, '2017/09/03'); --
CALL ThemSoTietKiem(4, 6, 1000000, '2017/09/29'); --
CALL ThemSoTietKiem(16, 1, 1000000, '2017/12/30'); -- 20

-- 2018
CALL ThemSoTietKiem(12, 0, 2000000, '2018/02/09'); --
CALL ThemSoTietKiem(10, 3, 6000000, '2018/04/05');  --
CALL ThemSoTietKiem(12, 9, 1000000, '2018/05/07'); --
CALL ThemSoTietKiem(9, 3, 10000000, '2018/05/16'); --
CALL ThemSoTietKiem(13, 3, 5000000, '2018/08/23'); --
CALL ThemSoTietKiem(5, 6, 4000000, '2018/09/12'); --
CALL ThemSoTietKiem(3, 0, 6000000, '2018/09/21'); --
CALL ThemSoTietKiem(11, 9, 3000000, '2018/10/04'); --
CALL ThemSoTietKiem(14, 12, 1000000, '2018/10/09'); --
CALL ThemSoTietKiem(2, 9, 1000000, '2018/12/11'); -- 30

-- 2019
CALL ThemSoTietKiem(7, 3, 9000000, '2019/03/07'); --
CALL ThemSoTietKiem(6, 12, 10000000, '2019/06/29'); --
CALL ThemSoTietKiem(9, 3, 7000000, '2019/07/08'); --
CALL ThemSoTietKiem(12, 12, 9000000, '2019/07/18'); --
CALL ThemSoTietKiem(1, 1, 6000000, '2019/09/17'); --
CALL ThemSoTietKiem(4, 6, 3000000, '2019/09/24'); --
CALL ThemSoTietKiem(15, 3, 9000000, '2019/10/19'); --
CALL ThemSoTietKiem(14, 1, 3000000, '2019/11/01'); --
CALL ThemSoTietKiem(16, 0, 8000000, '2019/12/14'); --
CALL ThemSoTietKiem(17, 0, 5000000, '2019/12/20'); -- 40

-- 2020
CALL ThemSoTietKiem(17, 1, 1000000, '2020/01/24'); --
CALL ThemSoTietKiem(8, 6, 6000000, '2020/04/11'); --
CALL ThemSoTietKiem(13, 3, 1000000, '2020/06/25'); --
CALL ThemSoTietKiem(3, 1, 9000000, '2020/07/11'); --
CALL ThemSoTietKiem(1, 12, 3000000, '2020/07/14'); --
CALL ThemSoTietKiem(15, 1, 8000000, '2020/08/01'); --
CALL ThemSoTietKiem(8, 6, 4000000, '2020/11/05'); --
CALL ThemSoTietKiem(11, 6, 3000000, '2020/11/22'); --
CALL ThemSoTietKiem(15, 0, 2000000, '2020/12/01'); -- 49

-- 2021
CALL ThemSoTietKiem(1, 12, 8000000, '2021/01/09'); --
CALL ThemSoTietKiem(8, 3, 9000000, '2021/01/14'); --
CALL ThemSoTietKiem(7, 0, 5000000, '2021/02/11'); --
CALL ThemSoTietKiem(17, 1, 9000000, '2021/03/22'); --

SELECT * FROM SOTIETKIEM;

/*========== Phiếu ==========*/
-- ThemPhieu(IN MaSo INT, IN SoTien DECIMAL(15, 2), IN MaKH INT, IN MaNV INT, IN GhiChu TEXT, IN NgayTao DATE)
-- RutHetTien(IN MaSo INT, IN MaKH INT, IN MaNV INT, IN GhiChu TEXT, IN NgayTao DATE)
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

CALL ThemPhieu(35, 300000, 'Some things', '2019/10/19');
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