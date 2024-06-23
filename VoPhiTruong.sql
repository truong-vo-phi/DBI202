USE [FUH COMPANY]
GO

-- Vo Phi Truong

-- 40.	Cho biết nhân viên nào không có người phụ thuộc. 
-- Thông tin yêu cầu: mã số nhân viên, họ tên nhân viên, tên phòng ban của nhân viên

SELECT e.empSSN, e.empName, d.depName
FROM tblEmployee e
JOIN tblDepartment d ON e.depNum = d.depNum
LEFT JOIN tblDependent dep ON e.empSSN = dep.empSSN
WHERE dep.empSSN IS NULL;

-- 41.	Cho biết phòng ban nào không có người phụ thuộc. 
-- Thông tin yêu cầu: mã số phòng ban, tên phòng ban

SELECT DISTINCT d.depNum, d.depName
FROM tblDepartment d
where depNum != ALL (
	SELECT DISTINCT d.depNum
	FROM tblDepartment d
	JOIN tblEmployee e ON d.depNum = e.depNum
	JOIN tblDependent dep ON e.empSSN = dep.empSSN
)

-- 42.	Cho biết những nhân viên nào chưa hề tham gia vào bất kỳ dự án nào. 
-- Thông tin yêu cầu: mã số, tên nhân viên, tên phòng ban của nhân viên

SELECT e.empSSN, e.empName, d.depName
FROM tblEmployee e
LEFT JOIN tblDepartment d ON e.depNum = d.depNum
LEFT JOIN tblWorksOn w ON e.empSSN = w.empSSN
WHERE w.proNum IS NULL;

-- 43.	Cho biết phòng ban không có nhân viên nào tham gia (bất kỳ) dự án. 
-- Thông tin yêu cầu: mã số phòng ban, tên phòng ban

SELECT d.depNum, d.depName
FROM tblDepartment d
LEFT JOIN (
    SELECT DISTINCT e.depNum
    FROM tblEmployee e
    JOIN tblWorksOn w ON e.empSSN = w.empSSN
) AS activeDepartments ON d.depNum = activeDepartments.depNum
WHERE activeDepartments.depNum IS NULL;


-- 44.	Cho biết phòng ban không có nhân viên nào tham gia vào dự án có tên là ProjectA. 
-- Thông tin yêu cầu: mã số phòng ban, tên phòng ban

SELECT d.depNum, d.depName
FROM tblDepartment d
LEFT JOIN (
    SELECT DISTINCT e.depNum
    FROM tblEmployee e
    JOIN tblWorksOn w ON e.empSSN = w.empSSN
    JOIN tblProject p ON w.proNum = p.proNum
    WHERE p.proName = 'ProjectA'
) AS activeDepartments ON d.depNum = activeDepartments.depNum
WHERE activeDepartments.depNum IS NULL;

-- 45.	Cho biết số lượng dự án được quản lý theo mỗi phòng ban. 
-- Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng dự án

SELECT d.depNum, d.depName, COUNT(p.proNum) AS projectCount
FROM tblDepartment d
LEFT JOIN tblProject p ON d.depNum = p.depNum
GROUP BY d.depNum, d.depName;

--46.	Cho biết phòng ban nào quản lý ít dự án nhất. 
-- Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng dự án

SELECT TOP 1 d.depNum as 'Mã phòng ban', d.depName AS 'Tên phòng ban', COUNT(DISTINCT p.proNum) AS projectCount
FROM tblDepartment d
LEFT JOIN tblProject p ON d.depNum = p.depNum
GROUP BY d.depNum, d.depName
ORDER BY projectCount ASC;

--47.	Cho biết phòng ban nào quản lý nhiều dự án nhất. 
-- Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng dự án

SELECT TOP 1 d.depNum as 'Mã phòng ban', d.depName AS 'Tên phòng ban', COUNT(DISTINCT p.proNum) AS projectCount
FROM tblDepartment d
LEFT JOIN tblProject p ON d.depNum = p.depNum
GROUP BY d.depNum, d.depName
ORDER BY projectCount DESC;

--48.	Cho biết những phòng ban nào có nhiểu hơn 5 nhân viên đang quản lý dự án gì. 
-- Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng nhân viên của phòng ban, tên dự án quản lý

SELECT d.depNum AS 'Mã phòng ban', d.depName AS 'Tên phòng ban', COUNT(DISTINCT e.empSSN) AS 'Số lượng nhân viên của phòng ban', p.proName AS 'Tên dự án quản lý'
FROM tblDepartment d
JOIN tblEmployee e ON d.depNum = e.depNum
JOIN tblWorksOn w ON e.empSSN = w.empSSN
JOIN tblProject p ON w.proNum = p.proNum
GROUP BY d.depNum, d.depName, p.proName
Having d.depNum = ANY (
	SELECT d.depNum
	FROM tblDepartment d
	JOIN tblEmployee e ON d.depNum = e.depNum
	GROUP BY d.depNum 
	HAVING COUNT(DISTINCT e.empSSN) >= 5
)

--49.	Cho biết những nhân viên thuộc phòng có tên là Phòng nghiên cứu, và không có người phụ thuộc.
-- Thông tin yêu cầu: mã nhân viên,họ tên nhân viên

SELECT e.empSSN AS 'Mã nhân viên', e.empName AS 'Họ tên nhân viên', e.depNum
FROM tblEmployee e
JOIN tblDepartment d ON e.depNum = d.depNum
LEFT JOIN tblDependent dp ON e.empSSN = dp.empSSN
WHERE d.depName = N'Phòng Nghiên cứu và phát triển' AND dp.empSSN IS NULL;

-- 50.	Cho biết tổng số giờ làm của các nhân viên, mà các nhân viên này không có người phụ thuộc.
-- Thông tin yêu cầu: mã nhân viên,họ tên nhân viên, tổng số giờ làm

SELECT e.empSSN AS 'Mã nhân viên', e.empName AS 'Họ tên nhân viên', SUM(w.workHours) AS 'Tổng số giờ làm'
FROM tblEmployee e
LEFT JOIN tblDependent dep ON e.empSSN = dep.empSSN
LEFT JOIN tblWorksOn w ON e.empSSN = w.empSSN
WHERE dep.empSSN IS NULL
GROUP BY e.empSSN, e.empName;

--51.	Cho biết tổng số giờ làm của các nhân viên, mà các nhân viên này có nhiều hơn 3 người phụ thuộc.
-- Thông tin yêu cầu: mã nhân viên,họ tên nhân viên, số lượng người phụ thuộc, tổng số giờ làm

SELECT e.empSSN AS 'Mã nhân viên', e.empName AS 'Họ tên nhân viên', COUNT(dep.empSSN) AS 'Số lượng người phụ thuộc', SUM(w.workHours) AS 'Tổng số giờ làm'
FROM tblEmployee e
JOIN tblDependent dep ON e.empSSN = dep.empSSN
LEFT JOIN tblWorksOn w ON e.empSSN = w.empSSN
GROUP BY e.empSSN, e.empName
HAVING COUNT(e.depNum) > 3;


-- 52.	Cho biết tổng số giờ làm việc của các nhân viên hiện đang dưới quyền giám sát (bị quản lý bởi) của nhân viên Mai Duy An.
-- Thông tin yêu cầu: mã nhân viên, họ tên nhân viên, tổng số giờ làm

SELECT e.empSSN AS 'Mã nhân viên', e.empName AS 'Họ tên nhân viên', SUM(w.workHours) AS 'Tổng số giờ làm'
FROM tblEmployee e
JOIN tblEmployee s ON e.supervisorSSN = s.empSSN
JOIN tblWorksOn w ON e.empSSN = w.empSSN
WHERE s.empName = 'Mai Duy An'
GROUP BY e.empSSN, e.empName;

