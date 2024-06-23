--Anhduc--
USE [FUH_COMPANY]
GO
--1.Cho biết ai đang quản lý phòng ban có tên: Phòng Nghiên cứu và phát triển. Thông tin yêu cầu: mã số,họ tên nhân viên, mã số phòng ban, tên phòng ban
SELECT E.empSSN, E.empName, D.depNum, D.depName FROM tblEmployee E
JOIN tblDepartment D ON E.empSSN = D.mgrSSN
WHERE D.depName = N'Phòng Nghiên cứu và phát triển';

--2.Cho phòng ban có tên: Phòng Nghiên cứu và phát triển hiện đang quản lý dự án nào. Thông tin yêu cầu: mã số dụ án, tên dự án, tên phòng ban quản lý
SELECT P.proNum, P.proName, D.depName
FROM  tblProject P
JOIN  tblDepartment D ON P.depNum = D.depNum
WHERE  D.depName = N'Phòng Nghiên cứu và phát triển';

--3.Cho biết dự án có tên ProjectB hiện đang được quản lý bởi phòng ban nào. Thông tin yêu cầu: mã số dụ án, tên dự án, tên phòng ban quản lý
SELECT P.proNum, P.proName, D.depName FROM  tblProject P
JOIN tblDepartment D ON P.depNum = D.depNum
WHERE  P.proName = 'ProjectB';

--4.Cho biết những nhân viên nào đang bị giám sát bởi nhân viên có tên Mai Duy An. Thông tin yêu cầu: mã số nhân viên, họ tên nhân viên
SELECT E_a.empSSN, E_a.empName FROM tblEmployee E_a
JOIN  tblEmployee E_b ON E_a.supervisorSSN = E_b.empSSN
WHERE E_b.empName = N'Mai Duy An';

--5.Cho biết ai hiện đang giám sát những nhân viên có tên Mai Duy An. Thông tin yêu cầu: mã số nhân viên, họ tên nhân viên giám sát.
SELECT E_b.empSSN, E_b.empName FROM tblEmployee E_a
JOIN  tblEmployee E_b ON E_a.supervisorSSN = E_b.empSSN
WHERE E_a.empName = N'Mai Duy An';

--6.Cho biết dự án có tên ProjectA hiện đang làm việc ở đâu. Thông tin yêu cầu: mã số, tên vị trí làm việc
SELECT P.proNum,  L.locName FROM tblProject P
JOIN  tblLocation L ON p.locNum = L.locNum
WHERE  P.proName = 'ProjectA';

--7.Cho biết vị trí làm việc có tên Tp. HCM hiện đang là chỗ làm việc của những dự án nào. Thông tin yêu cầu: mã số, tên dự án
SELECT P.proNum, P.proName From tblProject P
JOIN tblLocation L ON P.locNum = L.locNum
WHERE L.locname = N'TP Hồ Chí Minh';

--8.Cho biết những người phụ thuộc trên 18 tuổi .Thông tin yêu cầu: tên, ngày tháng năm sinh của người phụ thuộc, tên nhân viên phụ thuộc vào.
SELECT D.depName, D.depBirthdate, E.empName FROM tblDependent D
JOIN tblEmployee E ON E.empSSN = E.empSSN
WHERE DATEDIFF(YEAR, D.depBirthdate, GETDATE()) > 18;

--9.Cho biết những người phụ thuộc  là nam giới. Thông tin yêu cầu: tên, ngày tháng năm sinh của người phụ thuộc, tên nhân viên phụ thuộc vào 
SELECT D.depName, D.depBirthdate, E.empName FROM tblDependent D
JOIN tblEmployee E ON D.empSSN = E.empSSN
WHERE D.depSex = 'M'

--10.Cho biết những nơi làm việc của phòng ban có tên : Phòng Nghiên cứu và phát triển. Thông tin yêu cầu: mã phòng ban, tên phòng ban, tên nơi làm việc.
SELECT D.depNum, D.depName,L.locName FROM tblDepLocation DL
JOIN tblDepartment D ON DL.depNum = D.depNum
JOIN tblLocation L ON DL.locNum = L.locNum 
WHERE D.depName = N'Phòng Nghiên cứu và phát triển';

--11.Cho biết các dự án làm việc tại Tp. HCM. Thông tin yêu cầu: mã dự án, tên dự án, tên phòng ban chịu trách nhiệm dự án.
SELECT P.proNum, P.proName, D.depName FROM tblProject P
JOIN tblLocation L ON P.locNum = L.locNum
JOIN tblDepartment D ON P.depNum = D.depNum
WHERE L.locName = N'TP Hồ Chí Minh';

--12.Cho biết những người phụ thuộc là nữ giới, của nhân viên thuộc phòng ban có tên: Phòng Nghiên cứu và phát triển . Thông tin yêu cầu: tên nhân viên, tên người phụ thuộc, mối liên hệ giữa người phụ thuộc với nhân viên12.	Cho biết những người phụ thuộc là nữ giới, của nhân viên thuộc phòng ban có tên: Phòng Nghiên cứu và phát triển . Thông tin yêu cầu: tên nhân viên, tên người phụ thuộc, mối liên hệ giữa người phụ thuộc với nhân viên
SELECT E.empName,D.depName, D.depRelationship FROM tblDependent D
JOIN  tblEmployee E ON D.empSSN = E.empSSN
JOIN tblDepartment dp ON E.depNum = dp.depNum
WHERE D.depSex = N'F' AND dp.depName = N'Phòng Nghiên cứu và phát triển'; 

--13.Cho biết những người phụ thuộc trên 18 tuổi, của nhân viên thuộc phòng ban có tên: Phòng Nghiên cứu và phát triển. Thông tin yêu cầu: tên nhân viên, tên người phụ thuộc, mối liên hệ giữa người phụ thuộc với nhân viên
SELECT E.empName,D.depName,D.depRelationship FROM tblDependent D
JOIN tblEmployee E ON D.empSSN = E.empSSN
JOIN tblDepartment dp ON e.depNum = dp.depNum
WHERE DATEDIFF(YEAR, D.depBirthdate, GETDATE()) > 18 AND dp.depName = N'Phòng Nghiên cứu và phát triển';


