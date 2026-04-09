CREATE TABLE clinics (
    cid VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

INSERT INTO clinics VALUES
('cl1','Apollo Clinic','Hyderabad','Telangana','India'),
('cl2','Sunrise Clinic','Hyderabad','Telangana','India'),
('cl3','LifeCare Clinic','Mumbai','Maharashtra','India'),
('cl4','City Health Center','Mumbai','Maharashtra','India'),
('cl5','Rainbow Clinic','Chennai','Tamil Nadu','India'),
('cl6','Sai Clinic','Chennai','Tamil Nadu','India'),
('cl7','Green Valley Clinic','Bangalore','Karnataka','India'),
('cl8','Metro Clinic','Bangalore','Karnataka','India'),
('cl9','Happy Health Clinic','Delhi','Delhi','India'),
('cl10','Capital Clinic','Delhi','Delhi','India');




CREATE TABLE customer (
    uid VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    mobile VARCHAR(20)
);

INSERT INTO customer VALUES
('cu1','John Doe','9871111111'),
('cu2','Prasad','9872222222'),
('cu3','Ravi Kumar','9873333333'),
('cu4','Sita Devi','9874444444'),
('cu5','Arjun Reddy','9875555555'),
('cu6','Divya Rao','9876666666'),
('cu7','Mahesh','9877777777'),
('cu8','Kiran','9878888888'),
('cu9','Lakshmi','9879999999'),
('cu10','Venu','9870000000'),
('cu11','Sameer','9001111111'),
('cu12','Harsha','9002222222'),
('cu13','Nithin','9003333333'),
('cu14','Meena','9004444444'),
('cu15','Sandhya','9005555555'),
('cu16','Vishnu','9006666666'),
('cu17','Rohit','9007777777'),
('cu18','Anjali','9008888888'),
('cu19','Kavya','9009999999'),
('cu20','Teja','9010000000');




CREATE TABLE clinic_sales (
    oid VARCHAR(50) PRIMARY KEY,
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount DECIMAL(10,2),
    datetime DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

INSERT INTO clinic_sales VALUES
('s1','cu1','cl1',20000,'2021-08-12 10:00:00','website'),
('s2','cu2','cl2',15000,'2021-08-18 12:00:00','walkin'),
('s3','cu3','cl3',30000,'2021-08-20 16:00:00','agent'),
('s4','cu4','cl4',18000,'2021-08-22 14:00:00','call'),
('s5','cu5','cl5',25000,'2021-08-29 09:30:00','website'),

('s6','cu6','cl6',12000,'2021-09-05 11:15:00','walkin'),
('s7','cu7','cl7',16000,'2021-09-11 13:40:00','call'),
('s8','cu8','cl8',22000,'2021-09-14 15:00:00','website'),
('s9','cu9','cl9',27000,'2021-09-18 10:10:00','agent'),
('s10','cu10','cl10',30000,'2021-09-25 18:20:00','walkin'),

('s11','cu11','cl1',35000,'2021-10-01 11:00:00','call'),
('s12','cu12','cl2',28000,'2021-10-04 12:50:00','agent'),
('s13','cu13','cl3',26000,'2021-10-07 08:30:00','walkin'),
('s14','cu14','cl4',24000,'2021-10-15 16:10:00','website'),
('s15','cu15','cl5',31000,'2021-10-19 09:45:00','call'),
('s16','cu16','cl6',22000,'2021-10-27 17:00:00','walkin'),
('s17','cu17','cl7',33000,'2021-10-30 14:00:00','website'),

('s18','cu18','cl8',29000,'2021-11-02 12:00:00','walkin'),
('s19','cu19','cl9',21000,'2021-11-05 10:30:00','call'),
('s20','cu20','cl10',28000,'2021-11-09 13:20:00','agent'),
('s21','cu1','cl1',25000,'2021-11-14 15:10:00','website'),
('s22','cu2','cl2',26000,'2021-11-18 18:00:00','call'),
('s23','cu3','cl3',24000,'2021-11-20 09:00:00','website'),
('s24','cu4','cl4',19000,'2021-11-23 16:55:00','walkin'),
('s25','cu5','cl5',22000,'2021-11-28 11:30:00','agent'),
('s26','cu6','cl6',27000,'2021-11-30 20:15:00','walkin'),

('s27','cu7','cl7',32000,'2021-12-02 08:15:00','website'),
('s28','cu8','cl8',30000,'2021-12-06 15:25:00','walkin'),
('s29','cu9','cl9',26000,'2021-12-10 18:45:00','call'),
('s30','cu10','cl10',35000,'2021-12-13 13:35:00','agent'),
('s31','cu11','cl1',27000,'2021-12-15 10:50:00','walkin'),
('s32','cu12','cl2',29000,'2021-12-17 17:30:00','website'),
('s33','cu13','cl3',31000,'2021-12-20 11:00:00','call'),
('s34','cu14','cl4',25000,'2021-12-22 19:15:00','website'),
('s35','cu15','cl5',23000,'2021-12-27 14:40:00','walkin'),
('s36','cu16','cl6',21000,'2021-12-29 16:20:00','agent'),

('s37','cu17','cl7',26000,'2021-12-30 10:30:00','website'),
('s38','cu18','cl8',18000,'2021-12-31 20:00:00','walkin'),
('s39','cu19','cl9',20000,'2021-12-31 22:00:00','call'),
('s40','cu20','cl10',24000,'2021-12-31 23:00:00','website');




CREATE TABLE expenses (
    eid VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50),
    description VARCHAR(255),
    amount DECIMAL(10,2),
    datetime DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

INSERT INTO expenses VALUES
('e1','cl1','equipment repair',5000,'2021-08-10 11:00:00'),
('e2','cl2','electricity',3000,'2021-08-12 10:00:00'),
('e3','cl3','staff salary',8000,'2021-08-15 09:00:00'),
('e4','cl4','cleaning',2000,'2021-08-20 08:00:00'),
('e5','cl5','maintenance',6000,'2021-08-25 12:00:00'),

('e6','cl6','equipment',4000,'2021-09-03 13:00:00'),
('e7','cl7','salary',9000,'2021-09-07 11:00:00'),
('e8','cl8','water bill',1500,'2021-09-14 07:00:00'),
('e9','cl9','rent',10000,'2021-09-19 16:00:00'),
('e10','cl10','cleaning',3500,'2021-09-23 09:00:00'),

('e11','cl1','repairs',4500,'2021-10-04 10:00:00'),
('e12','cl2','staff',7500,'2021-10-08 12:00:00'),
('e13','cl3','maintenance',4000,'2021-10-12 14:00:00'),
('e14','cl4','supplies',2500,'2021-10-17 08:00:00'),
('e15','cl5','electricity',3500,'2021-10-21 18:00:00'),

('e16','cl6','staff',7000,'2021-11-01 13:00:00'),
('e17','cl7','repair',4500,'2021-11-06 11:00:00'),
('e18','cl8','cleaning',2000,'2021-11-11 10:00:00'),
('e19','cl9','water',1800,'2021-11-15 17:00:00'),
('e20','cl10','rent',9000,'2021-11-20 07:00:00'),

('e21','cl1','electricity',4000,'2021-12-03 09:00:00'),
('e22','cl2','repair',3000,'2021-12-06 14:00:00'),
('e23','cl3','water',1600,'2021-12-10 10:00:00'),
('e24','cl4','rent',11000,'2021-12-12 11:00:00'),
('e25','cl5','cleaning',2000,'2021-12-15 08:00:00'),

('e26','cl6','equipment',3000,'2021-12-18 12:00:00'),
('e27','cl7','repair',5000,'2021-12-22 07:00:00'),
('e28','cl8','staff',8000,'2021-12-25 18:00:00'),
('e29','cl9','rent',10000,'2021-12-28 09:00:00'),
('e30','cl10','maintenance',4500,'2021-12-30 16:00:00');
