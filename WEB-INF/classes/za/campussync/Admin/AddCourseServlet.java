package za.campussync.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import za.campussync.db.DBConnection;

@WebServlet("/AddCourseServlet")
public class AddCourseServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("course_code");
        String name = request.getParameter("course_name");
        String lecturer = request.getParameter("lecturer_name");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("INSERT INTO courses (course_code, course_name, lecturer_name) VALUES (?,?,?)")) {
            ps.setString(1, code);
            ps.setString(2, name);
            ps.setString(3, lecturer);
            ps.executeUpdate();
            response.sendRedirect("adminDashboard.jsp#courses");
        } catch (Exception e) { throw new ServletException(e); }
    }
}

