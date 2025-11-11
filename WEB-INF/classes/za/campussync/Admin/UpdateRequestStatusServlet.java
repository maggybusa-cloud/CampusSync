package za.campussync.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import za.campussync.db.DBConnection;

@WebServlet("/UpdateRequestStatusServlet")
public class UpdateRequestStatusServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String status = request.getParameter("status");
        if (idStr == null || status == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id or status");
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE support_requests SET status=? WHERE id=?")) {
            ps.setString(1, status);
            ps.setInt(2, Integer.parseInt(idStr));
            ps.executeUpdate();
            response.sendRedirect("adminDashboard.jsp#requests");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

