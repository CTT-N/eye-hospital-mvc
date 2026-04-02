package controller.manager;

import dao.RoomDAO;
import model.Room;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/manager/rooms")
public class RoomController extends HttpServlet {

    private RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Room> list = roomDAO.getAllRooms();
        request.setAttribute("listRooms", list);
        request.getRequestDispatcher("/views/manager/rooms.jsp").forward(request, response);
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
            room.setRoomId(request.getParameter("roomId"));
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
