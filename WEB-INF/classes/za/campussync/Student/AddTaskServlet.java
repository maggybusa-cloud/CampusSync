package za.campussync.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import za.campussync.db.DBConnection;

@WebServlet("/AddTaskServlet")
public class AddTaskServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String taskType = request.getParameter("taskType");
        String occurs = request.getParameter("occurs"); // once | repeating
        String courseIdStr = request.getParameter("courseId");

        String dueDate = request.getParameter("dueDate");
        String dueTime = request.getParameter("dueTime");

        String[] daysArr = request.getParameterValues("days");
        String days = (daysArr != null && daysArr.length > 0) ? String.join(",", daysArr) : null;
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userID") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int userId = (int) session.getAttribute("userID");
        Integer courseId = null;
        try {
            if (courseIdStr != null && !courseIdStr.isEmpty()) {
                courseId = Integer.parseInt(courseIdStr);
            }
        } catch (NumberFormatException ignored) {}

        // Basic server-side validation
        try {
            if (isBlank(title)) {
                throw new IllegalArgumentException("Title is required.");
            }
            if (!"once".equalsIgnoreCase(occurs) && !"repeating".equalsIgnoreCase(occurs)) {
                throw new IllegalArgumentException("Occurs must be either 'once' or 'repeating'.");
            }
            if ("once".equalsIgnoreCase(occurs)) {
                if (isBlank(dueDate) || isBlank(dueTime)) {
                    throw new IllegalArgumentException("Due date and time are required for one-time tasks.");
                }
            } else {
                if (isBlank(days) || isBlank(startTime) || isBlank(endTime)) {
                    throw new IllegalArgumentException("Repeating tasks require days, start time, and end time.");
                }
                // Optional constraint: start time before end time
                if (!isBlank(startTime) && !isBlank(endTime) && startTime.compareTo(endTime) >= 0) {
                    throw new IllegalArgumentException("Start time must be before end time.");
                }
                // Optional date range ordering if both provided
                if (!isBlank(startDate) && !isBlank(endDate) && startDate.compareTo(endDate) > 0) {
                    throw new IllegalArgumentException("Start date cannot be after end date.");
                }
            }
        } catch (IllegalArgumentException ex) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().println("Validation error: " + ex.getMessage());
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            String sqlOnce = "INSERT INTO student_tasks (user_id, course_id, title, description, task_type, occurs, due_date, due_time) " +
                             "VALUES (?, ?, ?, ?, ?, 'once', ?, ?)";
            String sqlRepeat = "INSERT INTO student_tasks (user_id, course_id, title, description, task_type, occurs, days, start_time, end_time, start_date, end_date) " +
                               "VALUES (?, ?, ?, ?, ?, 'repeating', ?, ?, ?, ?, ?)";

            if ("repeating".equalsIgnoreCase(occurs)) {
                try (PreparedStatement ps = con.prepareStatement(sqlRepeat)) {
                    ps.setInt(1, userId);
                    if (courseId == null) ps.setNull(2, java.sql.Types.INTEGER); else ps.setInt(2, courseId);
                    ps.setString(3, title);
                    ps.setString(4, description);
                    ps.setString(5, taskType);
                    ps.setString(6, days);
                    ps.setString(7, startTime);
                    ps.setString(8, endTime);
                    ps.setString(9, (startDate == null || startDate.isEmpty()) ? null : startDate);
                    ps.setString(10, (endDate == null || endDate.isEmpty()) ? null : endDate);
                    ps.executeUpdate();
                }
            } else {
                try (PreparedStatement ps = con.prepareStatement(sqlOnce)) {
                    ps.setInt(1, userId);
                    if (courseId == null) ps.setNull(2, java.sql.Types.INTEGER); else ps.setInt(2, courseId);
                    ps.setString(3, title);
                    ps.setString(4, description);
                    ps.setString(5, taskType);
                    ps.setString(6, dueDate);
                    ps.setString(7, dueTime);
                    ps.executeUpdate();
                }
            }

            response.sendRedirect("studentDashboard.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}

