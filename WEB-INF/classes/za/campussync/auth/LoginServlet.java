package za.campussync.auth;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;
import za.campussync.db.DBConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        System.out.println("Received login attempt for: " + email);

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT user_id, first_name, password, role FROM users WHERE email = ?");
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (!rs.next()) {
                System.out.println("Email not found: " + email);
                request.setAttribute("error", "email_not_found");
                request.setAttribute("email", email);
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            int userId = rs.getInt("user_id");
            String firstName = rs.getString("first_name");
            String dbPassword = rs.getString("password");
            String role = rs.getString("role");

            if (!password.equals(dbPassword)) {
                System.out.println("Invalid password for: " + email);
                request.setAttribute("error", "invalid_password");
                request.setAttribute("email", email);
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("email", email);
            session.setAttribute("role", role);
            session.setAttribute("firstName", firstName);
            session.setAttribute("userID", userId);

            if ("admin".equals(role)) {
                response.sendRedirect("adminDashboard.jsp");
            } else if ("student".equals(role)) {
                response.sendRedirect("studentDashboard.jsp");
            } else {
                System.out.println("Unknown role: " + role);
                request.setAttribute("error", "server_error");
                request.setAttribute("email", email);
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("Server error: " + e.getMessage());
            request.setAttribute("error", "server_error");
            request.setAttribute("email", email);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
