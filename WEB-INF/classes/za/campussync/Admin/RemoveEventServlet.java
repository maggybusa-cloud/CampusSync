package za.campussync.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import za.campussync.db.DBConnection;

@WebServlet("/RemoveEventServlet")
public class RemoveEventServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("event_id");
        if (id == null) { response.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM events WHERE event_id=?")) {
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();
            response.sendRedirect("adminCalendar.jsp");
        } catch (Exception e) { throw new ServletException(e); }
    }
}

