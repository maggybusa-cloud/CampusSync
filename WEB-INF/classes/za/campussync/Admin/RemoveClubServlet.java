package za.campussync.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import za.campussync.db.DBConnection;

@WebServlet("/RemoveClubServlet")
public class RemoveClubServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String clubId = request.getParameter("club_id");
        if (clubId == null) { response.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps1 = conn.prepareStatement("DELETE FROM events WHERE club_id=?");
                 PreparedStatement ps2 = conn.prepareStatement("DELETE FROM clubs WHERE club_id=?")) {
                ps1.setInt(1, Integer.parseInt(clubId));
                ps1.executeUpdate();
                ps2.setInt(1, Integer.parseInt(clubId));
                ps2.executeUpdate();
            }
            response.sendRedirect("adminDashboard.jsp#clubs");
        } catch (Exception e) { throw new ServletException(e); }
    }
}

