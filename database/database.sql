CREATE DATABASE eye_hospital;
USE eye_hospital;

CREATE TABLE Hospital (
    HospitalId VARCHAR(25) PRIMARY KEY,
    HospitalName VARCHAR(50),
    Address VARCHAR(200),
    Description VARCHAR(255)
);

CREATE TABLE Department (
    DepartmentId VARCHAR(25) PRIMARY KEY,
    HospitalId VARCHAR(25),
    DepartmentName VARCHAR(255),
    Description VARCHAR(255),

    FOREIGN KEY (HospitalId) 
    REFERENCES Hospital(HospitalId)
);

CREATE TABLE Room (
    RoomId VARCHAR(25) PRIMARY KEY,
    DepartmentId VARCHAR(25),
    RoomName VARCHAR(255),
    Description VARCHAR(255),

    FOREIGN KEY (DepartmentId)
    REFERENCES Department(DepartmentId)
);

CREATE TABLE User (
    UserId VARCHAR(25) PRIMARY KEY,
    UserName VARCHAR(25) UNIQUE,
    Password VARCHAR(25),
    FullName VARCHAR(30),
    Email VARCHAR(30),
    Role VARCHAR(20),
    Phone VARCHAR(20),
    Description VARCHAR(255)
);

CREATE TABLE Doctor (
    DoctorId VARCHAR(25) PRIMARY KEY,
    UserId VARCHAR(25),
    DepartmentId VARCHAR(25),
    EducationDegree VARCHAR(50),
    Experience VARCHAR(255),
    Description VARCHAR(255),

    FOREIGN KEY (UserId)
    REFERENCES User(UserId),

    FOREIGN KEY (DepartmentId)
    REFERENCES Department(DepartmentId)
);

CREATE TABLE Patient (
    PatientId VARCHAR(25) PRIMARY KEY,
    UserId VARCHAR(25),
    CCCD VARCHAR(20),
    Address VARCHAR(255),
    Birthday DATE,
    Gender VARCHAR(25),
    Note VARCHAR(255),

    FOREIGN KEY (UserId)
    REFERENCES User(UserId)
);

CREATE TABLE Appointment (
    AppointmentId VARCHAR(25) PRIMARY KEY,
    PatientId VARCHAR(25),
    DoctorId VARCHAR(25),
    RoomId VARCHAR(25),
    Date DATE,
    Time TIME,
    Status VARCHAR(20),

    FOREIGN KEY (PatientId)
    REFERENCES Patient(PatientId),

    FOREIGN KEY (DoctorId)
    REFERENCES Doctor(DoctorId),

    FOREIGN KEY (RoomId)
    REFERENCES Room(RoomId)
);

CREATE TABLE PatientRecord (
    RecordId VARCHAR(25) PRIMARY KEY,
    AppointmentId VARCHAR(25),
    Symptoms VARCHAR(255),
    Diagnosis VARCHAR(255),
    Treatment VARCHAR(255),
    CreatedDate DATE,
    Note VARCHAR(255),

    FOREIGN KEY (AppointmentId)
    REFERENCES Appointment(AppointmentId)
);

CREATE TABLE Service (
    ServiceId VARCHAR(25) PRIMARY KEY,
    ServiceName VARCHAR(255),
    Price DECIMAL(10,2),
    Description VARCHAR(255)
);

CREATE TABLE Invoice (
    InvoiceId VARCHAR(25) PRIMARY KEY,
    AppointmentId VARCHAR(25),
    Date DATE,
    TotalAmount DECIMAL(15,2),

    FOREIGN KEY (AppointmentId)
    REFERENCES Appointment(AppointmentId)
);

CREATE TABLE Invoice_Service (
    InvoiceId VARCHAR(25),
    ServiceId VARCHAR(25),
    Quanlity integer(10),
    TotalPrice DECIMAL(15, 2),

    PRIMARY KEY (InvoiceId, ServiceId),

    FOREIGN KEY (InvoiceId)
    REFERENCES Invoice(InvoiceId),

    FOREIGN KEY (ServiceId)
    REFERENCES Service(ServiceId)
);

CREATE TABLE EyeDiseaseInfo (
    InfoId VARCHAR(25) PRIMARY KEY,
    UserId VARCHAR(25),
    DiseaseName VARCHAR(255),
    Content VARCHAR(255),
    Description VARCHAR(255),
    CreatedBy VARCHAR(25),
    LastUpdate DATE,

    FOREIGN KEY (UserId)
    REFERENCES User(UserId)
);

INSERT INTO User VALUES
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

