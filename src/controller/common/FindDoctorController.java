package controller.common;

import dao.DoctorDAO;
import model.Doctor;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class FindDoctorController extends HttpServlet {

    private final DoctorDAO doctorDAO = new DoctorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        req.setAttribute("doctors", doctors);
        req.getRequestDispatcher("/views/common/find-doctor.jsp").forward(req, resp);
    }
}
