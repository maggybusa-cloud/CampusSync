<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String adminName = (session != null && session.getAttribute("username") != null)
        ? (String) session.getAttribute("username") : "Admin";
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
                <a class="text-white fw-semibold dropdown-toggle text-decoration-none" href="#" role="button" data-bs-toggle="dropdown">
                    Hi, <%= adminName %>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
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
                    <%= adminName.substring(0,1).toUpperCase() %>
                </div>
                <div class="ms-3">
                    <h4 class="fw-bold mb-0"><%= adminName %></h4>
                    <small class="text-muted">Administrator</small>
                </div>
            </div>

            <!-- ADMIN INFO -->
            <h5 class="fw-bold mb-3 text-primary">Profile Information</h5>
            <table class="table table-borderless">
                <tr><td><strong>Full Name:</strong></td><td><%= request.getAttribute("fullName") %></td></tr>
                <tr><td><strong>Email:</strong></td><td><%= request.getAttribute("email") %></td></tr>
                <tr><td><strong>Role:</strong></td><td><%= request.getAttribute("role") %></td></tr>
                <tr><td><strong>Campus:</strong></td><td><%= request.getAttribute("campus") %></td></tr>
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
