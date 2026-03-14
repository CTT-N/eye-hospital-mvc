package util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Random;

public class DataGenerator {

    static Random rand = new Random();

    static String[] firstNames = {"An","Binh","Chi","Dung","Ha","Lan","Minh","Nam","Phuc","Trang"};
    static String[] lastNames = {"Nguyen","Tran","Le","Pham","Hoang","Phan","Vu","Dang"};

    static String randomName(){
        return lastNames[rand.nextInt(lastNames.length)] + " " +
               firstNames[rand.nextInt(firstNames.length)];
    }

    static String randomPhone(){
        return "09" + (rand.nextInt(90000000) + 10000000);
    }

    static String randomEmail(int i){
        return "user"+i+"@gmail.com";
    }

    static String randomGender(){
        return rand.nextBoolean() ? "Male" : "Female";
    }

    // 1 Hospital
    public static void generateHospital() throws Exception {

    Connection conn = DBConnection.getConnection();

    String sql = "INSERT INTO Hospital (HospitalId, HospitalName, Address, Description) VALUES (?,?,?,?)";

    PreparedStatement ps = conn.prepareStatement(sql);

    ps.setString(1,"H002");
    ps.setString(2,"Vision Care Hospital");
    ps.setString(3,"Hanoi");
    ps.setString(4,"Eye treatment hospital");

    ps.executeUpdate();

    System.out.println("Hospital inserted");
}

    // 2 Department
    public static void generateDepartments() throws Exception {

        Connection conn = DBConnection.getConnection();

        String[] deps = {"Eye Examination","Surgery","Emergency","Pharmacy"};

        String sql = "INSERT INTO Department (DepartmentId,HospitalId,DepartmentName,Description) VALUES (?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);

        for(int i=2;i<=5;i++){

            ps.setString(1,"D00"+i);
            ps.setString(2,"H001");
            ps.setString(3,deps[rand.nextInt(deps.length)]);
            ps.setString(4,"Department description");

            ps.executeUpdate();
        }

        System.out.println("Departments inserted");
    }

    // 3 Room
    public static void generateRooms() throws Exception {

        Connection conn = DBConnection.getConnection();

        String sql = "INSERT INTO Room (RoomId,DepartmentId,RoomName,Description) VALUES (?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);

        for(int i=1;i<=10;i++){

            ps.setString(1,"R"+i);
            ps.setString(2,"D001");
            ps.setString(3,"Room "+i);
            ps.setString(4,"Medical room");

            ps.executeUpdate();
        }

        System.out.println("Rooms inserted");
    }

    // 4 User
    public static void generateUsers() throws Exception {

        Connection conn = DBConnection.getConnection();

        String sql = "INSERT INTO User (UserId,UserName,Password,FullName,Email,Role,Phone,Description) VALUES (?,?,?,?,?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);

        String[] roles = {"DOCTOR","PATIENT","STAFF"};

        for(int i=10;i<=40;i++){

            ps.setString(1,"U"+i);
            ps.setString(2,"user"+i);
            ps.setString(3,"123456");
            ps.setString(4,randomName());
            ps.setString(5,randomEmail(i));
            ps.setString(6,roles[rand.nextInt(roles.length)]);
            ps.setString(7,randomPhone());
            ps.setString(8,"Generated user");

            ps.executeUpdate();
        }

        System.out.println("Users inserted");
    }

    // 5 Doctor
    public static void generateDoctors() throws Exception {

        Connection conn = DBConnection.getConnection();

        String sql = "INSERT INTO Doctor VALUES(?,?,?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);

        for(int i=1;i<=10;i++){

            ps.setString(1,"DOC"+(100+i));
            ps.setString(2,"U"+(10+i));
            ps.setString(3,"D001");
            ps.setString(4,"MD");
            ps.setString(5,"5 years experience");
            ps.setString(6,"Eye doctor");

            ps.executeUpdate();
        }

        System.out.println("Doctors inserted");
    }

    // 6 Patient
    public static void generatePatients() throws Exception {

        Connection conn = DBConnection.getConnection();

        String sql = "INSERT INTO Patient VALUES(?,?,?,?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);

        for(int i=1;i<=30;i++){

            ps.setString(1,"P"+i);
            ps.setString(2,"U"+(20+i));
            ps.setString(3,"0"+(rand.nextInt(900000000)+100000000));
            ps.setString(4,"Hanoi");
            ps.setDate(5,new java.sql.Date(System.currentTimeMillis()));
            ps.setString(6,randomGender());
            ps.setString(7,"No note");

            ps.executeUpdate();
        }

        System.out.println("Patients inserted");
    }

    // 7 Appointment
    public static void generateAppointments() throws Exception {

        Connection conn = DBConnection.getConnection();

        String sql = "INSERT INTO Appointment VALUES(?,?,?,?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);

        for(int i=1;i<=50;i++){

            ps.setString(1,"A"+i);
            ps.setString(2,"P"+(rand.nextInt(30)+1));
            ps.setString(3,"DOC"+(rand.nextInt(10)+101));
            ps.setString(4,"R"+(rand.nextInt(10)+1));
            ps.setDate(5,new java.sql.Date(System.currentTimeMillis()));
            ps.setTime(6,new java.sql.Time(System.currentTimeMillis()));
            ps.setString(7,"Scheduled");

            ps.executeUpdate();
        }

        System.out.println("Appointments inserted");
    }

    // 8 PatientRecord
    public static void generateRecords() throws Exception {

        Connection conn = DBConnection.getConnection();

        String sql = "INSERT INTO PatientRecord VALUES(?,?,?,?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);

        for(int i=1;i<=50;i++){

            ps.setString(1,"REC"+i);
            ps.setString(2,"A"+i);
            ps.setString(3,"Eye pain");
            ps.setString(4,"Dry eye");
            ps.setString(5,"Eye drops");
            ps.setDate(6,new java.sql.Date(System.currentTimeMillis()));
            ps.setString(7,"No note");

            ps.executeUpdate();
        }

        System.out.println("Patient records inserted");
    }

    // 9 Service
    public static void generateServices() throws Exception {

        Connection conn = DBConnection.getConnection();

        String sql = "INSERT INTO Service VALUES(?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);

        String[] services = {"Eye Test","Laser Surgery","Consultation","Glasses Check"};

        for(int i=1;i<=services.length;i++){

            ps.setString(1,"S"+i);
            ps.setString(2,services[i-1]);
            ps.setDouble(3,rand.nextInt(200)+50);
            ps.setString(4,"Hospital service");

            ps.executeUpdate();
        }

        System.out.println("Services inserted");
    }

    // 10 Invoice
    public static void generateInvoices() throws Exception {

        Connection conn = DBConnection.getConnection();

        String sql = "INSERT INTO Invoice VALUES(?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);

        for(int i=1;i<=30;i++){

            ps.setString(1,"INV"+i);
            ps.setString(2,"A"+i);
            ps.setDate(3,new java.sql.Date(System.currentTimeMillis()));
            ps.setDouble(4,rand.nextInt(500)+100);

            ps.executeUpdate();
        }

        System.out.println("Invoices inserted");
    }

    // 11 Invoice_Service
    public static void generateInvoiceServices() throws Exception {

        Connection conn = DBConnection.getConnection();

        String sql = "INSERT INTO Invoice_Service VALUES(?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);

        for(int i=1;i<=30;i++){

            ps.setString(1,"INV"+i);
            ps.setString(2,"S"+(rand.nextInt(4)+1));
            ps.setInt(3,rand.nextInt(3)+1);
            ps.setDouble(4,rand.nextInt(200)+50);

            ps.executeUpdate();
        }

        System.out.println("Invoice services inserted");
    }

    // 12 EyeDiseaseInfo
    public static void generateEyeDiseaseInfo() throws Exception {

        Connection conn = DBConnection.getConnection();

        String sql = "INSERT INTO EyeDiseaseInfo VALUES(?,?,?,?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);

        for(int i=1;i<=10;i++){

            ps.setString(1,"INFO"+i);
            ps.setString(2,"U001");
            ps.setString(3,"Cataract");
            ps.setString(4,"Eye disease information");
            ps.setString(5,"Description");
            ps.setString(6,"Admin");
            ps.setDate(7,new java.sql.Date(System.currentTimeMillis()));

            ps.executeUpdate();
        }

        System.out.println("Eye disease info inserted");
    }

    public static void main(String[] args) throws Exception {

        generateHospital();
        generateDepartments();
        generateRooms();
        generateUsers();
        generateDoctors();
        generatePatients();
        generateAppointments();
        generateRecords();
        generateServices();
        generateInvoices();
        generateInvoiceServices();
        generateEyeDiseaseInfo();

        System.out.println("DATA GENERATED SUCCESSFULLY");
    }
}