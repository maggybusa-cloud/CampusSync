package za.campussync.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import za.campussync.db.DBConnection;

@WebServlet("/AddStudentServlet")
public class AddStudentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String studentNumber = request.getParameter("studentNumber");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String courseId = request.getParameter("courseId");

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO users (student_number, first_name, last_name, email, phone, role, password) VALUES (?,?,?,?,?,'student', ?)",
                Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, studentNumber);
                ps.setString(2, firstName);
                ps.setString(3, lastName);
                ps.setString(4, email);
                ps.setString(5, phone);
                ps.setString(6, "changeme"); // default password placeholder
                ps.executeUpdate();
                ResultSet keys = ps.getGeneratedKeys();
                Integer userId = null; if (keys.next()) userId = keys.getInt(1);

                if (userId != null && courseId != null && !courseId.isEmpty()) {
                    try (PreparedStatement link = conn.prepareStatement("INSERT INTO student_courses (user_id, course_id) VALUES (?,?)")) {
                        link.setInt(1, userId);
                        link.setInt(2, Integer.parseInt(courseId));
                        link.executeUpdate();
                    }
                }
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
            response.sendRedirect("adminDashboard.jsp#students");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

