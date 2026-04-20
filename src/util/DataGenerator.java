package util;

import java.sql.*;
import java.sql.Date;
import java.util.*;

public class DataGenerator {

    static final String DB_URL = "jdbc:mysql://localhost:3306/eye_hospital";
    static final String USER = "root";
    static final String PASS = "minhkhuat123";

    static Random rand = new Random();

    static String[] ho = {"Nguyen","Tran","Le","Pham","Hoang","Huynh","Phan","Vu","Dang","Bui"};
    static String[] ten = {"An","Binh","Chau","Dung","Giang","Ha","Hung","Khanh","Linh","Nam","Phong","Quan","Son","Trang","Tu","Vy"};

    static String randomName(){
        return ho[rand.nextInt(ho.length)] + " " + ten[rand.nextInt(ten.length)];
    }

    static String randomPhone(){
        return "09" + (10000000 + rand.nextInt(89999999));
    }

    static Date randomDate(){
        long start = Date.valueOf("2024-01-01").getTime();
        long end = Date.valueOf("2025-12-31").getTime();
        return new Date(start + (long)(rand.nextDouble()*(end-start)));
    }

    public static void main(String[] args) {

        try(Connection conn = DriverManager.getConnection(DB_URL, USER, PASS)) {

            Statement st = conn.createStatement();

            System.out.println("Reset database...");

            st.execute("SET FOREIGN_KEY_CHECKS=0");

            st.execute("TRUNCATE Invoice_Service");
            st.execute("TRUNCATE Invoice");
            st.execute("TRUNCATE MedicalRecord");
            st.execute("TRUNCATE Appointment");
            st.execute("TRUNCATE Patient");
            st.execute("TRUNCATE Doctor");
            st.execute("TRUNCATE Room");
            st.execute("TRUNCATE Department");
            st.execute("TRUNCATE Service");
            st.execute("TRUNCATE EyeDiseaseInfo");
            st.execute("TRUNCATE User");

            st.execute("SET FOREIGN_KEY_CHECKS=1");

            System.out.println("Generating Hospital...");

            st.executeUpdate(
                    "INSERT INTO Hospital VALUES('H001','Benh vien Mat Trung Uong','Ha Noi','Benh vien chuyen khoa mat')"
            );

            System.out.println("Generating Department...");

            for(int i=1;i<=5;i++){
                st.executeUpdate(
                        "INSERT INTO Department VALUES('D00"+i+"','H001','Khoa mat "+i+"','Chuyen khoa mat')"
                );
            }

            List<String> rooms = new ArrayList<>();

            System.out.println("Generating Room...");

            for(int i=1;i<=10;i++){

                String roomId="R"+String.format("%03d",i);
                rooms.add(roomId);

                st.executeUpdate(
                        "INSERT INTO Room VALUES('"+roomId+"','D001','Phong "+i+"','Phong kham mat')"
                );
            }

            List<String> doctorUsers = new ArrayList<>();
            List<String> patientUsers = new ArrayList<>();

            System.out.println("Generating Users...");

            // tao rieng 1 tai khoan cho admin
            st.executeUpdate(
                        "INSERT INTO User VALUES('U000','admin','123456','Administrator','admin@gmail.com','ADMIN','0123456789','System admin')"
                );

            for(int i=1;i<500;i++){

                String uid="U"+String.format("%03d",i);

                String role;

                if(i<=5) role="ADMIN";
                if(i<=25) role="DOCTOR";
                else if(i<=50) role="MANAGER";
                else role="PATIENT";

                st.executeUpdate(
                        "INSERT INTO User VALUES('"+uid+"','user"+i+"','123456','"
                                +randomName()+"','user"+i+"@gmail.com','"
                                +role+"','"+randomPhone()+"','Generated user')"
                );

                if(role.equals("DOCTOR")) doctorUsers.add(uid);
                if(role.equals("PATIENT")) patientUsers.add(uid);
            }

            List<String> doctors = new ArrayList<>();

            System.out.println("Generating Doctor...");

            int d=1;

            for(String u: doctorUsers){

                String did="DOC"+String.format("%03d",d++);

                st.executeUpdate(
                        "INSERT INTO Doctor VALUES('"+did+"','"+u+"','D001','Thac si','10 nam kinh nghiem','Bac si mat')"
                );

                doctors.add(did);
            }

            List<String> patients = new ArrayList<>();

            System.out.println("Generating Patient...");

            int p=1;

            for(String u: patientUsers){

                String pid="PAT"+String.format("%03d",p++);

                st.executeUpdate(
                        "INSERT INTO Patient VALUES('"+pid+"','"+u+"','0"+(100000000+rand.nextInt(899999999))+
                                "','Ha Noi','"+randomDate()+"','Nam','Benh nhan')"
                );

                patients.add(pid);
            }

            List<String> services = new ArrayList<>();

            System.out.println("Generating Service...");

            for(int i=1;i<=20;i++){

                String sid="S"+String.format("%03d",i);

                services.add(sid);

                st.executeUpdate(
                        "INSERT INTO Service VALUES('"+sid+"','Dich vu mat "+i+"',"
                                +(100000+rand.nextInt(500000))+",'Dich vu y te')"
                );
            }

            List<String> appointments = new ArrayList<>();

            System.out.println("Generating Appointment...");

            for(int i=1;i<=200;i++){

                String aid="A"+String.format("%03d",i);

                String patient=patients.get(rand.nextInt(patients.size()));
                String doctor=doctors.get(rand.nextInt(doctors.size()));
                String room=rooms.get(rand.nextInt(rooms.size()));

                st.executeUpdate(
                        "INSERT INTO Appointment VALUES('"+aid+"','"+patient+"','"+doctor+"','"+room+"','"
                                +randomDate()+"','09:00:00','DONE')"
                );

                appointments.add(aid);
            }

            System.out.println("Generating MedicalRecord...");

            int r=1;

            for(String a: appointments){

                st.executeUpdate(
                        "INSERT INTO MedicalRecord VALUES('MR"+String.format("%03d",r++)+"','"
                                +a+"','Dau mat','Can thi','Deo kinh','"
                                +randomDate()+"','Ho so benh')"
                );
            }

            System.out.println("Generating Invoice...");

            int inv=1;

            for(String a: appointments){

                String iid="INV"+String.format("%03d",inv++);

                st.executeUpdate(
                        "INSERT INTO Invoice VALUES('"+iid+"','"+a+"','"+randomDate()+"',0)"
                );

                int total=0;

                for(int i=0;i<2;i++){

                    String service=services.get(rand.nextInt(services.size()));

                    int qty=1+rand.nextInt(3);
                    int price=100000+rand.nextInt(400000);
                    int tp=qty*price;

                    total+=tp;

                    st.executeUpdate(
                            "INSERT ignore INTO Invoice_Service VALUES('"+iid+"','"+service+"',"+qty+","+tp+")"
                    );
                }

                st.executeUpdate(
                        "UPDATE Invoice SET totalAmount="+total+" WHERE invoiceId='"+iid+"'"
                );
            }

            System.out.println("Generating EyeDiseaseInfo...");

            for(int i=1;i<=50;i++){

                st.executeUpdate(
                        "INSERT INTO EyeDiseaseInfo VALUES('E"+String.format("%03d",i)+"','U001','Benh mat "+i+
                                "','Thong tin benh mat','Mo ta benh','U001','"+randomDate()+"')"
                );
            }

            System.out.println("DONE - Database generated successfully!");

        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}