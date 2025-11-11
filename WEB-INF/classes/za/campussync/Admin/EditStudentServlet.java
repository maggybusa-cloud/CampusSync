package za.campussync.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import za.campussync.db.DBConnection;

@WebServlet("/EditStudentServlet")
public class EditStudentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String studentNumber = request.getParameter("studentNumber");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String courseId = request.getParameter("courseId");

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET student_number=?, first_name=?, last_name=?, email=?, phone=? WHERE user_id=?")) {
                ps.setString(1, studentNumber);
                ps.setString(2, firstName);
                ps.setString(3, lastName);
                ps.setString(4, email);
                ps.setString(5, phone);
                ps.setInt(6, Integer.parseInt(userId));
                ps.executeUpdate();
            }

            // Update student_courses link (simple replace)
            try (PreparedStatement del = conn.prepareStatement("DELETE FROM student_courses WHERE user_id=?")) {
                del.setInt(1, Integer.parseInt(userId));
                del.executeUpdate();
            }
            if (courseId != null && !courseId.isEmpty()) {
                try (PreparedStatement link = conn.prepareStatement("INSERT INTO student_courses (user_id, course_id) VALUES (?,?)")) {
                    link.setInt(1, Integer.parseInt(userId));
                    link.setInt(2, Integer.parseInt(courseId));
                    link.executeUpdate();
                }
            }
            conn.commit();
            response.sendRedirect("adminDashboard.jsp#students");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

