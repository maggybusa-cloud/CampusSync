<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="za.campussync.db.DBConnection,java.sql.*" %>

<%
    String sessionEmail = null;
    if (session != null) {
        // Prefer the email set at login; fall back to legacy 'username'
        Object em = session.getAttribute("email");
        sessionEmail = (em != null) ? em.toString() : (String) session.getAttribute("username");
    }

    String firstName = "Admin";
    String lastName = "";
    String email = (sessionEmail != null) ? sessionEmail : "";
    String role = "admin";
    String campus = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT first_name, last_name, email, role, campus FROM users WHERE email = ? LIMIT 1")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    if (rs.getString("first_name") != null) firstName = rs.getString("first_name");
                    if (rs.getString("last_name") != null) lastName = rs.getString("last_name");
                    if (rs.getString("email") != null) email = rs.getString("email");
                    if (rs.getString("role") != null) role = rs.getString("role");
                    if (rs.getString("campus") != null) campus = rs.getString("campus");
                }
            }
        }
    } catch (Exception ignore) { }

    String fullName = (lastName == null || lastName.isEmpty()) ? firstName : (firstName + " " + lastName);
    String initials = (firstName != null && !firstName.isEmpty() ? firstName.substring(0,1) : "A") +
                      (lastName != null && !lastName.isEmpty() ? lastName.substring(0,1) : "");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Profile | CampusSync</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/profile.css">
</head>
<body style="background-color: #f5f7ff; font-family: 'Segoe UI', sans-serif;">

    <!-- HEADER -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center">
                <img src="images/campus-sync-logo.png" alt="CampusSync Logo" style="height: 40px; margin-right: 10px;">
                <h4 class="mb-0 fw-bold text-white">CampusSync</h4>
            </div>
            <div class="dropdown">
                <a class="text-white text-decoration-none" href="#" role="button" data-bs-toggle="dropdown">
                    <span class="rounded-circle bg-white text-primary fw-bold d-inline-flex justify-content-center align-items-center"
                          style="width: 40px; height: 40px; line-height:40px;">
                        <%= initials.toUpperCase() %>
                    </span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li class="dropdown-item-text"><strong><%= fullName %></strong><br><small class="text-muted"><%= email %></small></li>
                    <li><hr class="dropdown-divider"/></li>
                    <li><a class="dropdown-item" href="adminProfile.jsp">My Profile</a></li>
                    <li><a class="dropdown-item text-danger" href="logout.jsp">Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- PROFILE SECTION -->
    <div class="container mt-5">
        <div class="card shadow-sm p-4">
            <div class="d-flex align-items-center mb-4">
                <div class="rounded-circle bg-primary text-white fw-bold d-flex justify-content-center align-items-center"
                     style="width: 60px; height: 60px; font-size: 1.5rem;">
                    <%= initials.toUpperCase() %>
                </div>
                <div class="ms-3">
                    <h4 class="fw-bold mb-0"><%= fullName %></h4>
                    <small class="text-muted">Administrator</small>
                </div>
            </div>

            <!-- ADMIN INFO -->
            <h5 class="fw-bold mb-3 text-primary">Profile Information</h5>
            <table class="table table-borderless">
                <tr><td><strong>Full Name:</strong></td><td><%= fullName %></td></tr>
                <tr><td><strong>Email:</strong></td><td><%= email %></td></tr>
                <tr><td><strong>Role:</strong></td><td><%= role %></td></tr>
                <tr><td><strong>Campus:</strong></td><td><%= campus %></td></tr>
            </table>

            <!-- LOGOUT -->
            <div class="text-end mt-4">
                <a href="logout.jsp" class="btn btn-danger px-4">Logout</a>
            </div>
        </div>
    </div>

    <!-- FOOTER -->
    <footer class="text-center py-3 bg-primary text-white mt-5">
        <p class="mb-0">© 2025 CampusSync | Administrator Panel</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
