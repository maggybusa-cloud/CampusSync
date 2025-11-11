package za.campussync.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import za.campussync.db.DBConnection;

@WebServlet("/AddNoticeServlet")
public class AddNoticeServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String noticeType = request.getParameter("noticeType");
        String courseId = request.getParameter("courseId");
        String clubId = request.getParameter("clubId");
        String postedBy = (String) request.getSession().getAttribute("username");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("INSERT INTO notices (title, body, notice_type, course_id, club_id, posted_by, posted_at) VALUES (?,?,?,?,?,?, NOW())")) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setString(3, noticeType);
            if (courseId != null && !courseId.isEmpty()) ps.setInt(4, Integer.parseInt(courseId)); else ps.setNull(4, Types.INTEGER);
            if (clubId != null && !clubId.isEmpty()) ps.setInt(5, Integer.parseInt(clubId)); else ps.setNull(5, Types.INTEGER);
            ps.setString(6, postedBy);
            ps.executeUpdate();
            response.sendRedirect("adminDashboard.jsp#notices");
        } catch (Exception e) { throw new ServletException(e); }
    }
}

