package za.campussync.Student;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import za.campussync.db.DBConnection;

@WebServlet("/StudentProfileServlet")
public class StudentProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("email") == null && session.getAttribute("username") == null)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String email = (String) (session.getAttribute("email") != null ? session.getAttribute("email") : session.getAttribute("username"));

        try (Connection conn = DBConnection.getConnection()) {
            // Personal info
            PreparedStatement userStmt = conn.prepareStatement(
                "SELECT user_id, student_number, first_name, last_name, email, phone, program, year, campus " +
                "FROM users WHERE email = ? LIMIT 1");
            userStmt.setString(1, email);
            ResultSet ur = userStmt.executeQuery();
            int userId = -1;
            String firstName = "Student", lastName = "";
            if (ur.next()) {
                userId = ur.getInt("user_id");
                request.setAttribute("studentNumber", ur.getString("student_number"));
                firstName = Optional.ofNullable(ur.getString("first_name")).orElse(firstName);
                lastName = Optional.ofNullable(ur.getString("last_name")).orElse("");
                request.setAttribute("email", ur.getString("email"));
                request.setAttribute("phone", ur.getString("phone"));
                request.setAttribute("programme", ur.getString("program"));
                request.setAttribute("year", ur.getString("year"));
                request.setAttribute("campus", ur.getString("campus"));
            }
            request.setAttribute("fullName", (lastName.isEmpty()? firstName : firstName + " " + lastName));

            // Courses
            PreparedStatement courseStmt = conn.prepareStatement(
                "SELECT c.course_code, c.course_name, c.lecturer_name FROM courses c " +
                "JOIN student_courses sc ON c.course_id = sc.course_id " +
                "WHERE sc.user_id = ?");
            courseStmt.setInt(1, userId);
            ResultSet crs = courseStmt.executeQuery();
            List<Map<String, String>> courses = new ArrayList<>();
            while (crs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("code", crs.getString("course_code"));
                m.put("name", crs.getString("course_name"));
                m.put("lecturer", crs.getString("lecturer_name"));
                courses.add(m);
            }
            request.setAttribute("courses", courses);

            // Clubs
            PreparedStatement clubStmt = conn.prepareStatement(
                "SELECT cl.club_name FROM clubs cl " +
                "JOIN student_clubs sc ON cl.club_id = sc.club_id WHERE sc.user_id = ?");
            clubStmt.setInt(1, userId);
            ResultSet clrs = clubStmt.executeQuery();
            List<String> clubs = new ArrayList<>();
            while (clrs.next()) clubs.add(clrs.getString(1));
            request.setAttribute("clubs", clubs);

            request.getRequestDispatcher("studentProfile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp");
        }
    }
}
