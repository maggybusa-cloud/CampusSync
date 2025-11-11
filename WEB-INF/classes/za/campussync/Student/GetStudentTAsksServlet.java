package com.campussync.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import org.json.*;

public class GetStudentTasksServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        String username = (String) session.getAttribute("username");

        JSONArray events = new JSONArray();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/campussync", "root", "yourpassword");

            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM tasks WHERE username = ?");
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                JSONObject event = new JSONObject();
                event.put("title", rs.getString("title"));
                event.put("start", rs.getString("due_date"));
                events.put(event);
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        out.print(events.toString());
    }
}
