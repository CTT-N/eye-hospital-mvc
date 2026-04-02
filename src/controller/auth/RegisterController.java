package controller.auth;

import dao.UserDAO;
import model.User;
import dao.PatientDAO;
import model.Patient;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class RegisterController extends HttpServlet {

    // mở trang register
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
    }

    // xử lý submit
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");

        UserDAO dao = new UserDAO();

        // check trùng username
        if(dao.checkUsernameExists(username)){
            req.setAttribute("error", "Username already exists!");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }

        // tạo user (role = patient)
        User user = new User();
        String commonId = ""+System.currentTimeMillis() % 10000;
        user.setUserId("U" + commonId);
        user.setUsername(username);
        user.setPassword(password);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setRole("PATIENT");

        dao.insertUser(user);
            
        //create patient
        Patient patient = new Patient();
        patient.setPatientId("PA"+commonId);
        patient.setUserId("U" + commonId);
        PatientDAO pdao = new PatientDAO();
        pdao.insertPatient(patient);
        
        // đăng ký xong → login
        resp.sendRedirect(req.getContextPath() + "/auth/login");
    }
}
