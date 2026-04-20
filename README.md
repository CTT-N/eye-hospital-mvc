# eye-hospital-mvc
Web Eye Hospital Management System (Java MVC + MySQL)

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

Clone project từ GitHub:
git clone <repo-url>

Sau đó mở project bằng VS Code hoặc IDE Java.

---

Tạo database:

Trong project đã có file:
database.sql

Cách 1 (khuyên dùng):

- Mở MySQL Workbench  
- Chọn **File → Open SQL Script**  
- Mở file `database.sql`  
- Nhấn nút **Execute (⚡)**  

Database và dữ liệu mẫu sẽ được tạo tự động.

Cách 2 (command line):
mysql -u root -p

Sau đó chạy:
source path/to/database.sql;

---

Cấu hình kết nối database:

Mở file:
src/util/DBConnection.java

Kiểm tra thông tin kết nối:
jdbc:mysql://localhost:3306/eye_hospital

ví dụ:
String url = "jdbc:mysql://localhost:3306/eye_hospital";
String user = "root";
String password = "123456";

(Nếu password MySQL khác thì chỉnh lại.)

---

Kiểm tra thư viện trong project: webapp/WEB-INF/lib

Thư mục này cần có:

- mysql-connector-j.jar
- servlet-api.jar

---

Build project:

Trong VS Code:
Ctrl + Shift + B

---

Deploy vào Tomcat:

Copy thư mục project vào: apache-tomcat/webapps/
(thư mục eye-hospital-mvc/webapp/)

Sau đó restart Tomcat. (Start tomcat)

---

Chạy project trên trình duyệt: (tùy thư mục desploy vào mà đường dẫn sau 8080/ sẽ khác)
http://localhost:8080/webapp/auth/login

Trang login sẽ xuất hiện.

---

Cấu trúc project:
eye-hospital-mvc
│
├── src
│   ├── controller
│   │     LoginController.java
│   │     ...
│   ├── dao
│   │     UserDAO.java
│   │     ...
│   ├── model
│   │     User.java
│   │     ...
│   └── util
│         DBConnection.java
│
├── webapp
│   ├── css
│   ├── js
│   │
│   ├── views
│   │     home.jsp
│   │     login.jsp
│   │
│   │     ├── admin
│   │     │     dashboard.jsp
│   │     │     ...
│   │     ├── doctor
│   │     │     dashboard.jsp
│   │     │     ...
│   │     ├── manager
│   │     │     dashboard.jsp
│   │     │     ...
│   │     └── patient
│   │           dashboard.jsp
│   │           ...
│   └── WEB-INF
│        ├── classes
│        ├── lib
│        │    mysql-connector-j-9.6.0.jar
│        │    servlet-api.jar
│        └── web.xml


---

Lỗi thường gặp:

Không kết nối được database:

- Kiểm tra MySQL đã chạy chưa
- Kiểm tra username/password
- Kiểm tra database đã import chưa

---

Lỗi 404:

- Kiểm tra project nằm trong `tomcat/webapps`
- Restart Tomcat

---

Lỗi ClassNotFoundException:

Kiểm tra file:
WEB-INF/lib/mysql-connector-j.jar

---

Sau khi hoàn thành các bước trên, project sẽ chạy được trên máy local.