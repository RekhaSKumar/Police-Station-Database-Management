CREATE TABLE police_staff (
    pid VARCHAR(5) PRIMARY KEY,
    fname VARCHAR(25),
    lname VARCHAR(25),
    dob DATE,
    gender VARCHAR(1),
    designation VARCHAR(20),
    salary INT,
    address VARCHAR(80)
);

CREATE TABLE cases (
    caseno INT PRIMARY KEY,
    case_type VARCHAR(25),
    case_desc VARCHAR(150),
    reportedby VARCHAR(25),
    contactno VARCHAR(10),
    defname VARCHAR(25),
    r_time TIME,
    r_date DATE,
    p_assigned VARCHAR(5),
    FOREIGN KEY (p_assigned) REFERENCES police_staff(pid)
);

CREATE TABLE defendant (
    did INT PRIMARY KEY,
    cno INT,
    name VARCHAR(25),
    dob DATE,
    gender VARCHAR(1),
    convicted VARCHAR(1),
    cellno INT,
    FOREIGN KEY (cno) REFERENCES cases(caseno)
);

CREATE TABLE ceased_prop (
    oncase INT,
    ceasedby VARCHAR(5),
    proptype VARCHAR(20),
    propvalue INT,
    FOREIGN KEY (oncase) REFERENCES cases(caseno),
    FOREIGN KEY (ceasedby) REFERENCES police_staff(pid)
);

CREATE TABLE vehicles (
    vno VARCHAR(10) PRIMARY KEY,
    vtype VARCHAR(15),
    driver_pid VARCHAR(5),
    FOREIGN KEY (driver_pid) REFERENCES police_staff(pid)
);

--inserting into police_staff--

INSERT INTO police_staff VALUES 
('AA111', 'Ram', 'Purohit', '1975-09-03', 'M', 'SP', 100000, 'Rajarajeshvarinagar, Banglore'),
('AA112', 'Pramod', 'UB', '1973-05-07', 'M', 'ASP', 93000, 'Sahakarnagar, Banglore'),
('AA113', 'Roshni', 'Singh', '1978-11-11', 'F', 'DSP', 90000, 'Rajajinagar, Banglore'),
('AA114', 'Soumya', 'Deep', '1980-11-21', 'F', 'PI', 83000, 'Nagarbhavi, Banglore'),
('AA115', 'Mohan', 'Kumar', '1981-11-21', 'M', 'API', 80000, 'Nagarbhavi, Banglore'),
('AA116', 'Shravya', 'Hebbar', '1980-07-12', 'F', 'SI', 70000, 'White Field, Banglore'),
('AA117', 'Ramesh', 'Rao', '1978-02-15', 'M', 'ASI', 55000, 'Near Hebbal flyover, Banglore'),
('AA118', 'Kumarappa', 'MP', '1977-05-07', 'M', 'HC', 40000, 'Goraguntepalya, Banglore'),
('AA119', 'Fathima', 'Khan', '1978-07-18', 'F', 'PC', 30000, 'Yashvanthpur, Banglore');

--inserting into cases--
INSERT INTO cases VALUES 
(1111, 'Property', 'Illegal acquisition of 400 acres of land near nayanapalya, Banglore', 'Mohan', '9291837453', 'Kishor', '19:38:47', '2018-10-25', 'AA111'),
(1112, 'Property', 'Damaging property worth of 7.5 lacks', 'Raghu', '8473645201', 'Sam', '15:53:57', '2018-10-26', 'AA111'),
(1113, 'Murder', 'Murder of a 22 year old man with a knife because of property related conflict', 'Raj', '9483628234', 'Rahul', '01:34:12', '2018-10-31', 'AA117'),
(1114, 'Attempted murder', 'Attack on Navya by Pavani in a hotel room near Hebbal', 'Navya', '7483927501', 'Pavani', '13:30:22', '2018-10-15', 'AA113'),
(1115, 'Rash driving', 'Rash driving of car in a domestic area', 'Mohan', '9584746352', 'Ram', '12:23:23', '2018-10-10', 'AA114'),
(1116, 'Robbery', 'Department store near nagarbhavi circle robbed on 30th of October 2018 midnight', 'Mohan', '8574930285', '', '10:06:24', '2018-10-31', 'AA116'),
(1117, 'Murder', 'Murder of a 40 year old woman in Yashvanthpur.', 'Ramesh', '8884747433', 'Ramu', '10:59:16', '2018-10-31', 'AA118');

--inserting into defendant--
INSERT INTO defendant VALUES
(111, 1111, 'Kishor', '1988-10-02', 'M', 'Y', 1),
(112, 1112, 'Sam', '1988-10-09', 'M', 'N', NULL),
(113, 1113, 'Rahul', '1985-09-18', 'M', 'Y', 2),
(114, 1114, 'Pavani', '1990-12-12', 'F', 'N', NULL),
(115, 1115, 'Ram', '1992-05-14', 'M', 'N', NULL),
(116, 1117, 'Ramu', '1985-09-03', 'M', 'N', NULL);

--inserting into vehicles--
INSERT INTO vehicles VALUES
('KA12RE2361', 'Jeep', 'AA116'),
('KA12RE7311', 'Bike', 'AA114'),
('KA12RE7362', 'Bike', 'AA111'),
('KA12RE7462', 'Car', 'AA118');

--inserting into ceased_prop--
INSERT INTO ceased_prop VALUES
(1111, 'AA111', 'Land', 40000000),
(1113, 'AA117', 'Knife', NULL),
(1115, 'AA114', 'Car', NULL);

select * from police_staff;
select * from cases;
select * from defendant;
select * from vehicles;
select * from ceased_prop;

-- 1)To search police who are handling cases in Hebbal--
SELECT fname, lname
FROM police_staff p
WHERE EXISTS (
    SELECT 1
    FROM cases
    WHERE p.pid = p_assigned 
    AND case_desc ILIKE '%Hebbal%'
);
--2) To select police staff whose date of birth is between any two given dates--
SELECT *
FROM police_staff
WHERE dob > '1977-01-01' AND dob < '1980-12-12';

--3)Update salary of those police who have convicted murder case defendants by 10%--

UPDATE police_staff
SET salary = salary * 1.1
WHERE pid IN (
    SELECT p_assigned
    FROM cases
    WHERE case_type = 'Murder'
    AND caseno IN (
        SELECT cno
        FROM defendant
        WHERE convicted = 'Y'
    )
);
Select * from police_staff;

--6) To get information of defendants in a particular cell (eg. cellno = 1) and police who are handling their case--


select p.fname,p.lname
from police_staff p
where p.pid in
(
select c.p_assigned
from cases c
where caseno in
(
select d.cno
from defendant d
where cellno = 1
)
);

--5) Select the vehicle where ceased property type is land--
select vno,vtype
from vehicles
where driver_pid in
(
select p_assigned
from cases
where caseno in
(
select oncase
from ceased_prop
where proptype='Land'
)
);

--6)Select which police drives or uses which vehicles--
select pid,fname,lname,designation,vno,vtype
from police_staff,vehicles
where pid = driver_pid;

--7)A query comprising of all 5 tables retrieving the details of cases, the police who handles them, the vehicle used by them, the defendant arrested and the property ceased--

select p.pid"POLICE_ID", p.fname"FNAME", p.lname"LNAME",
c.caseno"CASE_NO", c.case_type"CASE_TYPE", c.case_desc"CASE_DESC",
d.did"DEFENDANT_ID", d.name"DEFENDANT_NAME",
proptype"PROPTYPE", propvalue"PROPVALUE", vno"VEHICLE_NO",
vtype"VEHICLE_USED"
from police_staff p, cases c, defendant d,ceased_prop, vehicles
where p.pid=c.p_assigned
and c.caseno=cno and
driver_pid=p.pid and p.pid=ceasedby;

--8)Find number of cases on a particular day--

select r_date,count(*)”count”
from cases
group by r_date;

--9)Select defendants who are convicted--


SELECT did, cno, defname, case_type, cellno
FROM defendant
JOIN cases ON cno = caseno
WHERE convicted = 'Y';

--10)Find cases handled by a poloce of particular designation--

SELECT caseno, case_desc, fname
FROM cases
JOIN police_staff ON p_assigned = pid
WHERE designation = 'DSP';