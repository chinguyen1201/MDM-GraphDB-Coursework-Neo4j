// Tạo mới database
create database QLTTTinHoc
:use QLTTTinHoc
// List các database hiện có
show database  
// Hiển thị toàn bộ các nodes có trong CSDL của bạn
MATCH (n) RETURN n 
// Xóa database
drop database <database_name> 

// Tạo node và quan hệ
CREATE
(s1:Student {id: "1", name: "Nguyen Van A", address: "tp hcm", gender: "Male", birth_year: 2000}),
(s2:Student {id: "2", name: "Tran Thi B", address: "ha noi", gender: "Female", birth_year: 1999}),
(s3:Student {id: "3", name: "Le Van C", address: "tp hcm", gender: "Male", birth_year: 2001}),
(s4:Student {id: "4", name: "Pham Van D", address: "tp hcm", gender: "Male", birth_year: 2002}),
(s5:Student {id: "5", name: "Hoang Thi E", address: "da nang", gender: "Female", birth_year: 1998}),
(s6:Student {id: "6", name: "Nguyen Minh F", address: "ha noi", gender: "Male", birth_year: 2000}),
(s7:Student {id: "7", name: "Tran Thanh G", address: "tp hcm", gender: "Male", birth_year: 2001}),
(s8:Student {id: "8", name: "Le Thi H", address: "can tho", gender: "Female", birth_year: 1999}),


(c1:Course {id: "1", name: "Lập trình Python", sessions: 40}),
(c2:Course {id: "2", name: "Cơ sở dữ liệu", sessions: 30}),
(c3:Course {id: "3", name: "Chuyên đề phân tích dữ liệu", sessions: 35}),

(r1:Room {id: "101", name: "Phòng A"}),
(r2:Room {id: "102", name: "Phòng B"}),

(p1:Project {id: "10", name: "Hệ thống quản lý học viên"}),
(p2:Project {id: "12", name: "Phân tích dữ liệu giao thông"}),
(p3:Project {id: "15", name: "Ứng dụng chatbot"}),
(p4:Project {id: "20", name: "Ứng dụng AI phân tích dữ liệu"})

MERGE (s1)-[:ENROLLED_IN]->(c1)
MERGE (s1)-[:ENROLLED_IN]->(c3)
MERGE (s2)-[:ENROLLED_IN]->(c2)
MERGE (s3)-[:ENROLLED_IN]->(c1)
MERGE (s3)-[:ENROLLED_IN]->(c3)

MERGE (c1)-[:HELD_IN]->(r1)
MERGE (c2)-[:HELD_IN]->(r2)
MERGE (c3)-[:HELD_IN]->(r1)

MERGE (s1)-[:WORKS_ON {hours: 20}]->(p1)
MERGE (s1)-[:WORKS_ON {hours: 25}]->(p2)
MERGE (s2)-[:WORKS_ON {hours: 30}]->(p3)
MERGE (s3)-[:WORKS_ON {hours: 15}]->(p1)
MERGE (s3)-[:WORKS_ON {hours: 20}]->(p2)

MERGE (s1)-[:WORKS_ON {hours: 10}]->(p4)
MERGE (s2)-[:WORKS_ON {hours: 15}]->(p4)
MERGE (s3)-[:WORKS_ON {hours: 12}]->(p4)
MERGE (s4)-[:WORKS_ON {hours: 20}]->(p4)
MERGE (s5)-[:WORKS_ON {hours: 18}]->(p4)
MERGE (s6)-[:WORKS_ON {hours: 14}]->(p4)


// Truy vấn
//Câu 1: 
MATCH (s:Student)
WHERE s.address = "tp hcm"
RETURN s.name as name, s.address as address, s.gender as gender, s.birth_year as birth_year
ORDER BY split(s.name, " ")[0] DESC
// Câu 2:
MATCH (c:Course)
WHERE c.sessions > 32
RETURN c.name as course, c.sessions as sessions
ORDER BY c.sessions DESC
// Câu 3:
MATCH (s:Student)-[:ENROLLED_IN]->(c:Course)-[:HELD_IN]->(r:Room)
RETURN r.name AS room, COLLECT(DISTINCT s.name) AS students
// Câu 4: 
MATCH (p:Project)<-[:WORKS_ON]-(s:Student)
WITH p, COLLECT(s.name) AS students
WHERE SIZE(students) >= 5
UNWIND students AS student_name
RETURN p.name as project, student_name
ORDER BY split(student_name, " ")[0] 
// Câu 5:
MATCH (c:Course {id: "1"})-[:HELD_IN]->(r:Room)
RETURN c.name as course, r.name as room
// Câu 6:
MATCH (s:Student {id: "1"})-[w:WORKS_ON]->(p:Project)
RETURN s.name as student, p.name as project, w.hours as hours
// Câu 7:
MATCH (s:Student)-[w:WORKS_ON]->(p:Project {id: "12"})
RETURN s.name as student, w.hours as hours, p.name as project
// Câu 8:
MATCH (s:Student)-[w:WORKS_ON]->(p:Project)
WITH s.name AS student, COLLECT([p.name, w.hours]) AS project_hours
UNWIND project_hours AS ph
RETURN student, ph[0] AS project, ph[1] AS hours
ORDER BY split(student, " ")[0]
LIMIT 4
/*INCORRECT 
MATCH (s:Student)-[w:WORKS_ON]->(p:Project)
WITH s.name AS student, COLLECT(p.name) AS projects, COLLECT(w.hours) AS hours
UNWIND projects AS project
UNWIND hours AS hour
RETURN student, project, hour
ORDER BY split(student, " ")[0]
LIMIT 4*/
// Câu 9:
MATCH (s:Student)-[:WORKS_ON]->(p:Project)
WITH s, COUNT(p) AS project_count
WHERE project_count > 2
RETURN s.name as student, project_count as number_of_projects
ORDER BY project_count DESC
// Câu 10:
MATCH (s1:Student)-[:WORKS_ON]->(p:Project)<-[:WORKS_ON]-(s2:Student)
WHERE s1 <> s2 AND split(s1.name, " ")[0] = split(s2.name, " ")[0]
RETURN DISTINCT s1.name as student, p.name as project 
ORDER BY split(s1.name, " ")[0]
// Câu 11:
MATCH (c:Course {name: "Chuyên đề phân tích dữ liệu"})-[:HELD_IN]->(r:Room),
      (s:Student)-[:ENROLLED_IN]->(c)
RETURN r.name as room, c.name as course, s.name as student















