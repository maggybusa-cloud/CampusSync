package za.campussync.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import za.campussync.db.DBConnection;

@WebServlet("/AddEventServlet")
public class AddEventServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String eventDate = request.getParameter("event_date");
        String eventTime = request.getParameter("event_time");
        String location = request.getParameter("location");
        String eventType = request.getParameter("event_type"); // general|course|club
        String courseId = request.getParameter("course_id");
        String clubId = request.getParameter("club_id");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
               "INSERT INTO events (title, description, event_date, event_time, location, related_to, course_id, club_id, type) VALUES (?,?,?,?,?,?,?,?, 'general')")) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, eventDate);
            ps.setString(4, eventTime);
            ps.setString(5, location);
            ps.setString(6, eventType);
            if (courseId != null && !courseId.isEmpty()) ps.setInt(7, Integer.parseInt(courseId)); else ps.setNull(7, Types.INTEGER);
            if (clubId != null && !clubId.isEmpty()) ps.setInt(8, Integer.parseInt(clubId)); else ps.setNull(8, Types.INTEGER);
            ps.executeUpdate();
            response.sendRedirect("adminDashboard.jsp#events");
        } catch (Exception e) { throw new ServletException(e); }
    }
}

