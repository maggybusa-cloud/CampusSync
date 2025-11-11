package za.campussync.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import za.campussync.db.DBConnection;

@WebServlet("/RemoveCourseServlet")
public class RemoveCourseServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseId = request.getParameter("course_id");
        if (courseId == null) { response.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps1 = conn.prepareStatement("DELETE FROM student_courses WHERE course_id=?");
                 PreparedStatement ps2 = conn.prepareStatement("DELETE FROM courses WHERE course_id=?")) {
                ps1.setInt(1, Integer.parseInt(courseId));
                ps1.executeUpdate();
                ps2.setInt(1, Integer.parseInt(courseId));
                ps2.executeUpdate();
            }
            response.sendRedirect("adminDashboard.jsp#courses");
        } catch (Exception e) { throw new ServletException(e); }
    }
}

