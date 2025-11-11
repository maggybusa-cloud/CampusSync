package za.campussync.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import za.campussync.db.DBConnection;

@WebServlet("/AddClubServlet")
public class AddClubServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("club_name");
        String description = request.getParameter("description");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("INSERT INTO clubs (club_name, description) VALUES (?,?)")) {
            ps.setString(1, name);
            ps.setString(2, description);
            ps.executeUpdate();
            response.sendRedirect("adminDashboard.jsp#clubs");
        } catch (Exception e) { throw new ServletException(e); }
    }
}

