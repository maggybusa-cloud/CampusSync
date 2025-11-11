package com.campussync.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.DriverManager;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AddTaskServlet")
public class AddTaskServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String dueDate = request.getParameter("dueDate");
        String description = request.getParameter("description");

        // Get the logged-in student ID from session
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userID");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/campussync", "root", "password");

            String sql = "INSERT INTO student_tasks (user_id, title, due_date, description) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, title);
            stmt.setString(3, dueDate);
            stmt.setString(4, description);

            stmt.executeUpdate();
            stmt.close();
            con.close();

            response.sendRedirect("studentDashboard.jsp"); // Refresh back to dashboard
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}

