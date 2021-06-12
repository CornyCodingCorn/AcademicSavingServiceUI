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