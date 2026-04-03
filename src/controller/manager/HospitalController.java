package controller.manager;

import dao.HospitalDAO;
import model.Hospital;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/manager/hospital")
public class HospitalController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        List<Hospital> hospitals = new HospitalDAO().getAllHospitals();
        Hospital hospital = hospitals.isEmpty() ? null : hospitals.get(0);
        request.setAttribute("hospital", hospital);

        request.getRequestDispatcher("/views/manager/manager-hospital-info.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String hospitalId = request.getParameter("hospitalId");
        String hospitalName = request.getParameter("hospitalName");
        String address = request.getParameter("address");
        String description = request.getParameter("description");

        HospitalDAO dao = new HospitalDAO();
        Hospital hospital = new Hospital();
        hospital.setHospitalId(hospitalId);
        hospital.setHospitalName(hospitalName);
        hospital.setAddress(address);
        hospital.setDescription(description);
        dao.updateHospital(hospital);

        response.sendRedirect(request.getContextPath() + "/manager/hospital?msg=success");
    }
}
