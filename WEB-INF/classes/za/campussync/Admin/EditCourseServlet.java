package za.campussync.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import za.campussync.db.DBConnection;

@WebServlet("/EditCourseServlet")
public class EditCourseServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseId = request.getParameter("course_id");
        String code = request.getParameter("course_code");
        String name = request.getParameter("course_name");
        String lecturer = request.getParameter("lecturer_name");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE courses SET course_code=?, course_name=?, lecturer_name=? WHERE course_id=?")) {
            ps.setString(1, code);
            ps.setString(2, name);
            ps.setString(3, lecturer);
            ps.setInt(4, Integer.parseInt(courseId));
            ps.executeUpdate();
            response.sendRedirect("adminDashboard.jsp#courses");
        } catch (Exception e) { throw new ServletException(e); }
    }
}

