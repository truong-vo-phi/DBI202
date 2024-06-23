USE [FUH COMPANY]
GO
--############################################################
-- Nguyen Huu Vuong
--27.	Cho biết tổng số giờ làm của mỗi dự án. Thông tin yêu cầu: mã dự án, tên dự án, tổng số giờ làm
SELECT p.proNum, p.proName, SUM(w.workHours) AS N'Tổng số giờ làm'
FROM tblProject p
JOIN tblWorksOn w ON p.proNum = w.proNum
GROUP BY p.proNum, p.proName;
--28.	Cho biết dự án nào có số lượng thành viên là ít nhất. Thông tin yêu cầu: mã dự án, tên dự án, số lượng thành viên
SELECT p.proNum, p.proName, COUNT(w.proNum) as N'số lượng thành viên'
FROM tblProject p
JOIN tblWorksOn w ON p.proNum = w.proNum
GROUP BY p.proNum, p.proName
HAVING COUNT(w.proNum) = (
        SELECT MIN(SoLuongThanhVien)
        FROM (SELECT COUNT(w.proNum) AS SoLuongThanhVien
            FROM tblProject p
            JOIN tblWorksOn w ON p.proNum = w.proNum
            GROUP BY p.proNum
        ) AS SubQuery
    );
--29.	Cho biết dự án nào có số lượng thành viên là nhiều nhất. Thông tin yêu cầu: mã dự án, tên dự án, số lượng thành viên
SELECT p.proNum, p.proName, COUNT(w.proNum) as N'số lượng thành viên'
FROM tblProject p
JOIN tblWorksOn w ON p.proNum = w.proNum
GROUP BY p.proNum, p.proName
HAVING COUNT(w.proNum) = (
        SELECT MAX(SoLuongThanhVien)
        FROM (SELECT COUNT(w.proNum) AS SoLuongThanhVien
            FROM tblProject p
            JOIN tblWorksOn w ON p.proNum = w.proNum
            GROUP BY p.proNum
        ) AS SubQuery
    );
--30.	Cho biết dự án nào có tổng số giờ làm là ít nhất. Thông tin yêu cầu: mã dự án, tên dự án, tổng số giờ làm
SELECT p.proNum, p.proName, SUM(w.workHours) AS N'tổng số giờ làm'
FROM tblProject p
JOIN tblWorksOn w ON p.proNum = w.proNum
GROUP BY p.proNum, p.proName
HAVING SUM(w.workHours) = (
		SELECT MIN(TotalHours)
		FROM (SELECT SUM(w.workHours) AS TotalHours
			FROM tblProject p
			JOIN tblWorksOn w ON p.proNum = w.proNum
			GROUP BY p.proNum
			) AS SubQuery
	);
--31.	Cho biết dự án nào có tổng số giờ làm là nhiều nhất. Thông tin yêu cầu: mã dự án, tên dự án, tổng số giờ làm
SELECT p.proNum, p.proName, SUM(w.workHours) AS N'tổng số giờ làm'
FROM tblProject p
JOIN tblWorksOn w ON p.proNum = w.proNum
GROUP BY p.proNum, p.proName
HAVING SUM(w.workHours) = (
		SELECT MAX(TotalHours)
		FROM (SELECT SUM(w.workHours) AS TotalHours
			FROM tblProject p
			JOIN tblWorksOn w ON p.proNum = w.proNum
			GROUP BY p.proNum
			) AS SubQuery
	);
--32.	Cho biết số lượng phòng ban làm việc theo mỗi nơi làm việc. Thông tin yêu cầu: tên nơi làm việc, số lượng phòng 
SELECT l.locName, COUNT(dl.locNum) AS N'số lượng phòng '
FROM tblLocation l
JOIN tblDepLocation dl ON dl.locNum = l.locNum
JOIN tblDepartment d ON d.depNum = dl.depNum
GROUP BY l.locName
--33.	Cho biết số lượng chỗ làm việc theo mỗi phòng ban. Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng chỗ làm việc
SELECT d.depNum, d.depName, COUNT(dl.depNum) AS N'số lượng chỗ làm việc'
FROM tblDepartment d
JOIN tblDepLocation dl ON dl.depNum = d.depNum
JOIN tblLocation l ON l.locNum = dl.locNum
GROUP BY d.depNum, d.depName
--34.	Cho biết phòng ban nào có nhiều chỗ làm việc nhất. Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng chỗ làm việc
SELECT d.depNum, d.depName, COUNT(dl.depNum) AS N'số lượng chỗ làm việc'
FROM tblDepartment d
JOIN tblDepLocation dl ON dl.depNum = d.depNum
JOIN tblLocation l ON l.locNum = dl.locNum
GROUP BY d.depNum, d.depName
HAVING COUNT(dl.depNum) = (
		SELECT MAX(SoLuongChoLamViec)
		FROM (SELECT COUNT(dl.depNum) AS SoLuongChoLamViec
			FROM tblDepartment d
			JOIN tblDepLocation dl ON dl.depNum = d.depNum
			JOIN tblLocation l ON l.locNum = dl.locNum
			GROUP BY d.depNum, d.depName
			) AS Subquery
	);
--35.	Cho biết phòng ban nào có it chỗ làm việc nhất. Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng chỗ làm việc
SELECT d.depNum, d.depName, COUNT(dl.depNum) AS N'số lượng chỗ làm việc'
FROM tblDepartment d
JOIN tblDepLocation dl ON dl.depNum = d.depNum
JOIN tblLocation l ON l.locNum = dl.locNum
GROUP BY d.depNum, d.depName
HAVING COUNT(dl.depNum) = (
		SELECT MIN(SoLuongChoLamViec)
		FROM (SELECT COUNT(dl.depNum) AS SoLuongChoLamViec
			FROM tblDepartment d
			JOIN tblDepLocation dl ON dl.depNum = d.depNum
			JOIN tblLocation l ON l.locNum = dl.locNum
			GROUP BY d.depNum, d.depName
			) AS Subquery
	);
--36.	Cho biết địa điểm nào có nhiều phòng ban làm việc nhất. Thông tin yêu cầu: tên nơi làm việc, số lượng phòng ban
SELECT l.locName, COUNT(dl.locNum) AS N'số lượng phòng ban'
FROM tblLocation l
JOIN tblDepLocation dl ON dl.locNum = l.locNum
JOIN tblDepartment d ON d.depNum = dl.depNum
GROUP BY l.locName
HAVING COUNT(dl.locNum) = (
		SELECT MAX(SoLuongPhong)
		FROM (SELECT COUNT(dl.locNum) AS SoLuongPhong
			FROM tblLocation l
			JOIN tblDepLocation dl ON dl.locNum = l.locNum
			JOIN tblDepartment d ON d.depNum = dl.depNum
			GROUP BY l.locName 
			) AS Subquery
	);
--37.	Cho biết địa điểm nào có ít phòng ban làm việc nhất. Thông tin yêu cầu: tên nơi làm việc, số lượng phòng ban
SELECT l.locName, COUNT(dl.locNum) AS N'số lượng phòng ban'
FROM tblLocation l
JOIN tblDepLocation dl ON dl.locNum = l.locNum
JOIN tblDepartment d ON d.depNum = dl.depNum
GROUP BY l.locName
HAVING COUNT(dl.locNum) = (
		SELECT MIN(SoLuongPhong)
		FROM (SELECT COUNT(dl.locNum) AS SoLuongPhong
			FROM tblLocation l
			JOIN tblDepLocation dl ON dl.locNum = l.locNum
			JOIN tblDepartment d ON d.depNum = dl.depNum
			GROUP BY l.locName 
			) AS Subquery
	);
--38.	Cho biết nhân viên nào có nhiều người phụ thuộc nhất. Thông tin yêu cầu: mã số, họ tên nhân viên, số lượng người phụ thuộc
SELECT e.empSSN, e.empName, COUNT(d.empSSN) AS N'số lượng người phụ thuộc'
FROM tblEmployee e
LEFT JOIN tblDependent d ON e.empSSN = d.empSSN
GROUP BY e.empSSN, e.empName
HAVING COUNT(d.empSSN) = (
        SELECT MAX(SoLuongNguoiPhuThuoc)
        FROM (SELECT COUNT(d.empSSN) AS SoLuongNguoiPhuThuoc
            FROM tblEmployee e
            LEFT JOIN tblDependent d ON e.empSSN = d.empSSN
            GROUP BY e.empSSN
        ) AS Subquery
    );
--39.	Cho biết nhân viên nào có ít người phụ thuộc nhất. Thông tin yêu cầu: mã số, họ tên nhân viên, số lượng người phụ thuộc
SELECT e.empSSN, e.empName, COUNT(d.empSSN) AS N'số lượng người phụ thuộc'
FROM tblEmployee e
LEFT JOIN tblDependent d ON e.empSSN = d.empSSN
GROUP BY e.empSSN, e.empName
HAVING COUNT(d.empSSN) = (
        SELECT MIN(SoLuongNguoiPhuThuoc)
        FROM (SELECT COUNT(d.empSSN) AS SoLuongNguoiPhuThuoc
            FROM tblEmployee e
            LEFT JOIN tblDependent d ON e.empSSN = d.empSSN
            GROUP BY e.empSSN
        ) AS Subquery
    );