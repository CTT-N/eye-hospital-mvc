DROP DATABASE IF EXISTS eye_hospital;
CREATE DATABASE eye_hospital;
USE eye_hospital;

CREATE TABLE IF NOT EXISTS Hospital (
    hospitalId VARCHAR(25) PRIMARY KEY,
    hospitalName VARCHAR(50),
    address VARCHAR(200),
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Department (
    departmentId VARCHAR(25) PRIMARY KEY,
    hospitalId VARCHAR(25),
    departmentName VARCHAR(255),
    description VARCHAR(255),

    FOREIGN KEY (hospitalId) 
    REFERENCES Hospital(hospitalId)
);

CREATE TABLE IF NOT EXISTS Room (
    roomId VARCHAR(25) PRIMARY KEY,
    departmentId VARCHAR(25),
    roomName VARCHAR(255),
    description VARCHAR(255),

    FOREIGN KEY (departmentId)
    REFERENCES Department(departmentId)
);

CREATE TABLE IF NOT EXISTS User (
    userId VARCHAR(25) PRIMARY KEY,
    userName VARCHAR(25) UNIQUE,
    password VARCHAR(25),
    fullname VARCHAR(30),
    email VARCHAR(30),
    role enum("DOCTOR","PATIENT","MANAGER","ADMIN"),
    phone VARCHAR(20),
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Doctor (
    doctorId VARCHAR(25) PRIMARY KEY,
    userId VARCHAR(25) UNIQUE,
    departmentId VARCHAR(25),
    educationDegree VARCHAR(50),
    experience VARCHAR(255),
    description VARCHAR(255),
    avatarUrl VARCHAR(255),

    FOREIGN KEY (userId)
    REFERENCES User(userId),

    FOREIGN KEY (departmentId)
    REFERENCES Department(departmentId)
);

CREATE TABLE IF NOT EXISTS Patient (
    patientId VARCHAR(25) PRIMARY KEY,
    userId VARCHAR(25) UNIQUE,
    CCCD VARCHAR(20) UNIQUE,
    address VARCHAR(255),
    birthday DATE,
    gender VARCHAR(25),
    note VARCHAR(255),

    FOREIGN KEY (userId)
    REFERENCES User(userId)
);

CREATE TABLE IF NOT EXISTS Appointment (
    appointmentId VARCHAR(25) PRIMARY KEY,
    patientId VARCHAR(25),
    doctorId VARCHAR(25),
    roomId VARCHAR(25),
    date DATE,
    time TIME,
    status VARCHAR(20),

    FOREIGN KEY (patientId) REFERENCES Patient(patientId),
    FOREIGN KEY (doctorId) REFERENCES Doctor(doctorId),
    FOREIGN KEY (roomId) REFERENCES Room(roomId)
);

CREATE TABLE IF NOT EXISTS MedicalRecord (
    recordId VARCHAR(25) PRIMARY KEY,
    appointmentId VARCHAR(25),
    symptoms VARCHAR(255),
    diagnosis VARCHAR(255),
    treatment VARCHAR(255),
    createdDate DATE,
    note VARCHAR(255),

    FOREIGN KEY (appointmentId)
    REFERENCES Appointment(appointmentId)
);

CREATE TABLE IF NOT EXISTS Service (
    serviceId VARCHAR(25) PRIMARY KEY,
    serviceName VARCHAR(255),
    price DECIMAL(10,2),
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Invoice (
    invoiceId VARCHAR(25) PRIMARY KEY,
    appointmentId VARCHAR(25),
    date DATE,
    totalAmount DECIMAL(15,2),

    FOREIGN KEY (appointmentId)
    REFERENCES Appointment(appointmentId)
);

CREATE TABLE IF NOT EXISTS Invoice_Service (
    invoiceId VARCHAR(25),
    serviceId VARCHAR(25),
    quantity int,
    totalPrice DECIMAL(15, 2),

    PRIMARY KEY (invoiceId, serviceId),

    FOREIGN KEY (invoiceId)
    REFERENCES Invoice(invoiceId),

    FOREIGN KEY (serviceId)
    REFERENCES Service(serviceId)
);

CREATE TABLE IF NOT EXISTS EyeDiseaseInfo (
    infoId VARCHAR(25) PRIMARY KEY,
    userId VARCHAR(25),
    diseaseName VARCHAR(255),
    content VARCHAR(255),
    description VARCHAR(255),
    createdBy VARCHAR(25),
    lastUpdate DATE,

    FOREIGN KEY (userId) REFERENCES User(userId),
    FOREIGN KEY (createdBy) REFERENCES User(userId)
);

/* INSERT INTO User VALUES
('U001','admin','123456','Administrator','admin@gmail.com','ADMIN','0123456789','System admin');
INSERT INTO User VALUES
('U002','doctor1','123456','Dr John','doctor@gmail.com','DOCTOR','0123456788','Eye doctor');
INSERT INTO User VALUES
('U003','patient1','123456','Patient A','patient@gmail.com','PATIENT','0123456787','Patient');

INSERT INTO Hospital VALUES
('H001','Eye Hospital','Hanoi','Eye specialist hospital');
INSERT INTO Department VALUES
('D001','H001','Ophthalmology','Eye department');
INSERT INTO Doctor VALUES
('DOC001','U002','D001','PhD','10 years experience','Eye specialist');
*/