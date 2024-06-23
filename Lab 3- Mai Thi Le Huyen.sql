USE FUH_COMPANY

--14.  Cho biết số lượng người phụ thuộc theo giới tính. Thông tin yêu cầu: giới tính, số lượng người phụ thuộc
SELECT depSex AS 'Giới tính', COUNT(empSSN) AS 'Số người phụ thuộc '
FROM Dependent
GROUP BY depSex
SELECT 
    (SELECT COUNT(*) FROM Dependent WHERE depSex = 'M') AS 'Số người phụ thuộc là Nam',
    (SELECT COUNT(*) FROM Dependent WHERE depSex = 'F') AS 'Số người phụ thuộc là Nữ'

-- 15.	Cho biết số lượng người phụ thuộc theo mối liên hệ với nhân viên. Thông tin yêu cầu: mối liên hệ, số lượng người phụ thuộc

SELECT depRelationship AS 'Mối quan hệ', COUNT(empSSN) AS 'Số lượng người phụ thuộc'
FROM Dependent
GROUP BY depRelationship


-- 16.	Cho biết số lượng người phụ thuộc theo mỗi phòng ban. Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng người phụ thuộc
SELECT d.depNum AS 'Mã phòng ban', d.depName AS 'Tên phòng ban', COUNT(dep.empSSN) AS 'Số lượng người phụ thuộc'
FROM Department d
INNER JOIN Employee e ON d.depNum = e.depNum
INNER JOIN Dependent dep ON e.empSSN = dep.empSSN
GROUP BY d.depNum, d.depName

SELECT d.depNum AS DepartmentNum, d.depName AS DepartmentName, COUNT(dep.empSSN) AS DependentCount
FROM Department d
LEFT JOIN Employee e ON d.depNum = e.depNum
LEFT JOIN Dependent dep ON e.empSSN = dep.empSSN
GROUP BY d.depNum, d.depName

--17.	Cho biết phòng ban nào có số lượng người phụ thuộc là ít nhất. Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng người phụ thuộc
SELECT d.depNum AS'Mã phòng ban', d.depName AS 'Tên phòng ban', COUNT(de.empSSN) AS 'Số lượng người phụ thuộc'
FROM Department d
INNER JOIN Employee e ON d.depNum = e.depNum
INNER JOIN Dependent de ON e.empSSN = de.empSSN
GROUP BY d.depNum, d.depName
HAVING COUNT(de.empSSN) = (
    SELECT MIN(DependentCount)
    FROM (
        SELECT COUNT(de.empSSN) AS DependentCount
        FROM Department d
        JOIN Employee e ON d.depNum = e.depNum
        JOIN Dependent de ON e.empSSN = de.empSSN
        GROUP BY d.depNum
    ) AS SubQuery
)
--18.	Cho biết phòng ban nào có số lượng người phụ thuộc là nhiều nhất. Thông tin yêu cầu: mã phòng ban, tên phòng ban, số lượng người phụ thuộc
SELECT d.depNum AS'Mã phòng ban', d.depName AS 'Tên phòng ban', COUNT(de.empSSN) AS 'Số lượng người phụ thuộc'
FROM Department d
INNER JOIN Employee e ON d.depNum = e.depNum
INNER JOIN Dependent de ON e.empSSN = de.empSSN
GROUP BY d.depNum, d.depName
HAVING COUNT(de.empSSN) = (
    SELECT MAX(DependentCount)
    FROM (
        SELECT COUNT(de.empSSN) AS DependentCount
        FROM Department d
        INNER JOIN Employee e ON d.depNum = e.depNum
        INNER JOIN Dependent de ON e.empSSN = de.empSSN
        GROUP BY d.depNum
    ) AS SubQuery
)
--19.	Cho biết tổng số giờ tham gia dự án của mỗi nhân viên. Thông tin yêu cầu: mã nhân viên, tên nhân viên, tên phòng ban của nhân viên
SELECT e.empSSN AS 'Mã nhân viên ',  e.empName AS 'Tên Nhân viên',  d.depName AS 'Tên phòng ban', 
		SUM(w.workHours) AS 'Tổng số giờ làm'
FROM 
    Employee e
INNER JOIN 
    WorksOn w ON e.empSSN = w.empSSN
INNER JOIN 
    Department d ON e.depNum = d.depNum
GROUP BY 
    e.empSSN, e.empName, d.depName

--20.	Cho biết tổng số giờ làm dự án của mỗi phòng ban. Thông tin yêu cầu: mã phòng ban,  tên phòng ban, tổng số giờ

SELECT d.depNum AS 'Mã phòng ban', d.depName AS 'Tên phòng ban', 
	  SUM(w.workHours) AS 'Tổng số giờ'
FROM 
    Department d
INNER JOIN  Employee e ON d.depNum = e.depNum
INNER JOIN  WorksOn w ON e.empSSN = w.empSSN
GROUP BY 
    d.depNum, d.depName

-- 21. Cho biết nhân viên nào có số giờ tham gia dự án là ít nhất. Thông tin yêu cầu: mã nhân viên, tên nhân viên, tổng số giờ tham gia dự án
SELECT 
    empSSN AS EmployeeID, empName AS EmployeeName, TotalHours
FROM (
    SELECT 
        e.empSSN, 
        e.empName, 
        SUM(w.workHours) AS TotalHours,
        RANK() OVER (ORDER BY SUM(w.workHours)) AS RankHours
    FROM 
        Employee e
INNER JOIN 
        WorksOn w ON e.empSSN = w.empSSN
    GROUP BY 
        e.empSSN, e.empName
) AS RankedHours
WHERE RankHours = 1

--22. Cho biết nhân viên nào có số giờ tham gia dự án là nhiều nhất. Thông tin yêu cầu: mã nhân viên, tên nhân viên, tổng số giờ tham gia dự án
SELECT e.empSSN AS EmployeeID, e.empName AS EmployeeName, 
    SUM(w.workHours) AS TotalHours
FROM 
    Employee e
INNER JOIN 
    WorksOn w ON e.empSSN = w.empSSN
GROUP BY 
    e.empSSN, e.empName
HAVING 
    SUM(w.workHours) = (
        SELECT MAX(TotalHours)
        FROM (
            SELECT 
                empSSN, 
                SUM(workHours) AS TotalHours
            FROM 
                WorksOn
            GROUP BY 
                empSSN
        ) AS SubQuery
    )

-- 23. Cho biết những nhân viên nào lần đầu tiên tham gia dụ án. Thông tin yêu cầu: mã nhân viên, tên nhân viên, tên phòng ban của nhân viên
SELECT 
    e.empSSN AS 'Mã nhân viên', 
    e.empName AS 'Tên nhân viên', 
    d.depName AS 'Tên phòng ban của nhân viên'
FROM 
    Employee e
INNER JOIN 
    Department d ON e.depNum = d.depNum
WHERE 
    e.empSSN IN (
        SELECT empSSN
        FROM WorksOn
        GROUP BY empSSN
        HAVING COUNT(proNum) = 2
    )

-- 25.Cho biết những nhân viên nào tham gia tối thiểu hai dụ án. Thông tin yêu cầu: mã nhân viên, tên nhân viên, tên phòng ban của nhân viên
SELECT 
    e.empSSN AS 'Mã nhân viên ', 
    e.empName AS 'Tên nhân viên', 
    d.depName AS 'Tên phòng ban nhân viên'
FROM 
    Employee e
INNER JOIN 
    Department d ON e.depNum = d.depNum
WHERE 
    e.empSSN IN (
        SELECT empSSN
        FROM WorksOn
        GROUP BY empSSN
        HAVING COUNT(DISTINCT proNum) >= 2
    )
--26. Cho biết số lượng thành viên của mỗi dự án. Thông tin yêu cầu: mã dự án, tên dự án, số lượng thành viên
SELECT 
    p.proNum AS 'Mã dự án', 
    p.proName AS 'Tên dự án', 
    COUNT(DISTINCT w.empSSN) AS 'Số lượng thành viên'
FROM 
    Project p
INNER JOIN 
    WorksOn w ON p.proNum = w.proNum
GROUP BY 
    p.proNum, p.proName

