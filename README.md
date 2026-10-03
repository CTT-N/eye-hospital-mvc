# EYE HOSPITAL MANAGEMENT SYSTEM
> A web-based hospital management system designed to support the management of patients, doctors, appointments, medical examinations, and hospital services (Java MVC + MySQL)

Project sử dụng:
- Java Servlet + JSP
- Apache Tomcat
- MySQL
- JDBC
- MVC architecture

---

Yêu cầu trước khi chạy project:

- Cài Java JDK 17 hoặc mới hơn  
- Cài MySQL Server  
- Cài MySQL Workbench (khuyến nghị)  
- Tải Apache Tomcat 10  

Kiểm tra Java:
java -version
javac -version

---

## Overview

Eye Hospital Management System is a web-based application developed as a team project to support the management and operation of an eye hospital.

The system provides different functionalities for patients, doctors, managers, and administrators, helping manage patient information, appointments, medical examinations, and hospital services through a centralized web application.

The project was developed using Java web technologies with a MySQL database.

---

## Project Objectives

- Build a web-based system for managing eye hospital operations.
- Manage patient and doctor information.
- Support appointment scheduling and management.
- Manage medical examination and patient records.
- Provide different functionalities based on user roles.
- Apply database management and web application development practices.

---

## Technologies

### Backend

- Java
- JSP / Servlet
- Apache Tomcat

### Frontend

- HTML
- CSS
- JavaScript
- JSP

### Database

- MySQL
- JDBC

### Tools

- Git
- GitHub
- Maven
- IntelliJ IDEA / NetBeans

---

## User Roles

### Doctor

- View assigned appointments
- View patient information
- Manage medical examination records
- Update examination results

### Patient

- Register and log in
- Manage personal information
- Book appointments
- View appointment information
- View medical examination records

### Manager

- Manage doctors and patients
- Manage hospital services
- Monitor appointments and hospital operations

### Administrator

- Manage user accounts
- Manage system access and permissions

---

## Main Features

### Authentication and Authorization

- User registration and login
- Session management
- Role-based access control

### Patient Management

- Manage patient information
- Search and view patient records
- View medical history

### Doctor Management

- Manage doctor information
- View doctor schedules
- Manage assigned appointments

### Appointment Management

- Create appointments
- View appointment schedules
- Update appointment status
- Manage appointments between patients and doctors

### Medical Examination

- Record examination information
- Store examination results
- View patient examination history

### Hospital Management

- Manage hospital services
- Manage users and system information
- Support different workflows for each role

---

## Application Screenshots

### Home Page 

![Home Page](images/home.jpg)

### Login Page

![Login Page](images/login.jpg)

### Patient Dashboard

![Patient Dashboard](images/patient-dashboard.jpg)

### Doctor Dashboard

![Doctor Dashboard](images/doctor-dashboard.jpg)

### Appointment Management

![Appointment Management](images/appointment.jpg)


---

## System Architecture

The application follows a layered web application architecture:

```text
              +----------------------+
              |       Client         |
              |  HTML / CSS / JS     |
              |        JSP           |
              +----------+-----------+
                         |
                         v
              +----------------------+
              |      Controller      |
              |    Servlet / JSP     |
              +----------+-----------+
                         |
                         v
              +----------------------+
              |        Model         |
              |   Java / Business    |
              |       Logic          |
              +----------+-----------+
                         |
                         v
              +----------------------+
              |      Database        |
              |        MySQL         |
              +----------------------+
