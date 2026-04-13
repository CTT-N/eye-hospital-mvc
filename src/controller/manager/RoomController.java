package controller.manager;

import dao.RoomDAO;
import model.Room;
import model.User;

import dao.DepartmentDAO;
import model.Department;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

public class RoomController extends HttpServlet {

    private RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        List<Room> list = roomDAO.getAllRooms();
        List<Department> departments = new DepartmentDAO().getAllDepartments();
        request.setAttribute("listRooms", list);
        request.setAttribute("listDepartments", departments);
        request.getRequestDispatcher("/views/manager/manager-rooms.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        if ("delete".equals(action)) {
            String id = request.getParameter("roomId");
            roomDAO.deleteRoom(id);
        } else if ("add".equals(action)) {
            Room room = new Room();
            String roomId = request.getParameter("roomId");
            if (roomId == null || roomId.trim().isEmpty()) {
                roomId = "P" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            }
            room.setRoomId(roomId);
            room.setDepartmentId(request.getParameter("departmentId"));
            room.setRoomName(request.getParameter("roomName"));
            room.setDescription(request.getParameter("description"));
            roomDAO.insertRoom(room);
        } else if ("update".equals(action)) {
            Room room = new Room();
            room.setRoomId(request.getParameter("roomId"));
            room.setDepartmentId(request.getParameter("departmentId"));
            room.setRoomName(request.getParameter("roomName"));
            room.setDescription(request.getParameter("description"));
            roomDAO.updateRoom(room);
        }

        response.sendRedirect(request.getContextPath() + "/manager/rooms?msg=success");
    }
}
