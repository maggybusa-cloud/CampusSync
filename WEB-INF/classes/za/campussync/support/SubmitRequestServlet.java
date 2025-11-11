package za.campussync.support;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import za.campussync.db.DBConnection;

@WebServlet("/SubmitRequestServlet")
public class SubmitRequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                System.out.println("🚀 SubmitRequestServlet triggered successfully!");

        String requesterEmail = request.getParameter("requesterEmail");
        String requestType = request.getParameter("requestType"); // page context (e.g., admin/password)
        String requestOption = request.getParameter("requestOption"); // dropdown selection
        String identification = request.getParameter("identification");

        // Align with DB schema: store the dropdown value in request_type; fallback to page context
        String effectiveRequestType = (requestOption != null && !requestOption.isEmpty()) ? requestOption : requestType;

        try {
            String sql = "INSERT INTO support_requests (email, request_type, identification, status, created_at) VALUES (?, ?, ?, 'Pending', CURRENT_TIMESTAMP)";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, requesterEmail);
                stmt.setString(2, effectiveRequestType);
                stmt.setString(3, identification);

                int rows = stmt.executeUpdate();

                if (rows > 0) {
                    response.sendRedirect("requestSuccess.jsp");
                } else {
                    response.getWriter().println("Submission failed. Try again.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
