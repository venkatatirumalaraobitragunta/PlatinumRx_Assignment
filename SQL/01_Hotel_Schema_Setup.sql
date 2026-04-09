CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    phone_number VARCHAR(20),
    mail_id VARCHAR(100),
    billing_address VARCHAR(255)
);

INSERT INTO users VALUES
('u1','John Doe','9871111111','john@example.com','Hyderabad'),
('u2','Prasad','9872222222','prasad@example.com','Hyderabad'),
('u3','Ravi Kumar','9873333333','ravi@example.com','Chennai'),
('u4','Sita Devi','9874444444','sita@example.com','Mumbai'),
('u5','Mahesh','9875555555','mahesh@example.com','Delhi');

CREATE TABLE bookings (
    booking_id VARCHAR(50) PRIMARY KEY,
    booking_date DATETIME,
    room_no VARCHAR(50),
    user_id VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO bookings VALUES
('b1','2021-08-15 10:20:00','R101','u1'),
('b2','2021-08-20 12:30:00','R102','u2'),
('b3','2021-09-12 14:15:00','R103','u3'),
('b4','2021-10-05 09:10:00','R104','u4'),
('b5','2021-11-18 18:20:00','R105','u5'),
('b6','2021-12-02 11:40:00','R106','u1');


CREATE TABLE items (
    item_id VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(100),
    item_rate DECIMAL(10,2)
);

INSERT INTO items VALUES
('itm1','Tawa Paratha',18),
('itm2','Mix Veg',89),
('itm3','Paneer Tikka',150),
('itm4','Chicken Biryani',220),
('itm5','Fried Rice',120),
('itm6','Curd Rice',80),
('itm7','Dal Fry',90),
('itm8','French Fries',70);



CREATE TABLE booking_commercials (
    id VARCHAR(50) PRIMARY KEY,
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date DATETIME,
    item_id VARCHAR(50),
    item_quantity DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

INSERT INTO booking_commercials VALUES
('bc1','b1','bill1','2021-08-15 12:00:00','itm1',3),
('bc2','b1','bill1','2021-08-15 12:00:00','itm2',1),

('bc3','b2','bill2','2021-08-20 13:00:00','itm3',2),
('bc4','b2','bill2','2021-08-20 13:00:00','itm4',1),

('bc5','b3','bill3','2021-09-12 14:30:00','itm1',4),
('bc6','b3','bill3','2021-09-12 14:30:00','itm5',2),

('bc7','b4','bill4','2021-10-05 10:00:00','itm4',1),
('bc8','b4','bill4','2021-10-05 10:00:00','itm7',3),

('bc9','b5','bill5','2021-11-18 19:00:00','itm2',2),
('bc10','b5','bill5','2021-11-18 19:00:00','itm8',4),

('bc11','b6','bill6','2021-12-02 13:00:00','itm3',1),
('bc12','b6','bill6','2021-12-02 13:00:00','itm6',2);
