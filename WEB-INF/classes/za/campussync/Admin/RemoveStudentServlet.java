package za.campussync.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import za.campussync.db.DBConnection;

@WebServlet("/RemoveStudentServlet")
public class RemoveStudentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        if (userId == null) { response.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement delLinks = conn.prepareStatement("DELETE FROM student_courses WHERE user_id=?");
                 PreparedStatement delUser = conn.prepareStatement("DELETE FROM users WHERE user_id=?")) {
                delLinks.setInt(1, Integer.parseInt(userId));
                delLinks.executeUpdate();
                delUser.setInt(1, Integer.parseInt(userId));
                delUser.executeUpdate();
            }
            response.sendRedirect("adminDashboard.jsp#students");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

