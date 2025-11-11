package za.campussync.support;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/SubmitRequestServlet")
public class SubmitRequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                System.out.println("🚀 SubmitRequestServlet triggered successfully!");

        String requesterEmail = request.getParameter("requesterEmail");
        String requestType = request.getParameter("requestType");
        String requestOption = request.getParameter("requestOption");
        String identification = request.getParameter("identification");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/campussync", "root", "yourpassword");

            String sql = "INSERT INTO support_requests (email, request_type, request_option, identification, submitted_at) VALUES (?, ?, ?, ?, NOW())";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, requesterEmail);
            stmt.setString(2, requestType);
            stmt.setString(3, requestOption);
            stmt.setString(4, identification);

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("requestsuccess.jsp");
            } else {
                response.getWriter().println("Submission failed. Try again.");
            }

            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
