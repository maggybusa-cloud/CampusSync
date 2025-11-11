package za.campussync.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import za.campussync.db.DBConnection;

@WebServlet("/EditClubServlet")
public class EditClubServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String clubId = request.getParameter("club_id");
        String name = request.getParameter("club_name");
        String description = request.getParameter("description");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE clubs SET club_name=?, description=? WHERE club_id=?")) {
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setInt(3, Integer.parseInt(clubId));
            ps.executeUpdate();
            response.sendRedirect("adminDashboard.jsp#clubs");
        } catch (Exception e) { throw new ServletException(e); }
    }
}

