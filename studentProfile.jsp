<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.util.Map" %>
<%
    String sessionEmail = (session != null && session.getAttribute("email") != null) ? (String) session.getAttribute("email") : (String) session.getAttribute("username");
    String displayName = (request.getAttribute("fullName") != null) ? (String) request.getAttribute("fullName") : "Student";
    String initials = displayName.substring(0,1).toUpperCase();
    String studentNumber = (request.getAttribute("studentNumber") != null) ? String.valueOf(request.getAttribute("studentNumber")) : "";
    String programme = (String) request.getAttribute("programme");
    String year = (String) request.getAttribute("year");
    String campus = (String) request.getAttribute("campus");
    String email = (String) request.getAttribute("email");
    String phone = (String) request.getAttribute("phone");
    List<Map<String, String>> courses = (List<Map<String, String>>) request.getAttribute("courses");
    List<String> clubs = (List<String>) request.getAttribute("clubs");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile | CampusSync</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body style="background-color: #f5f7ff; font-family: 'Segoe UI', sans-serif;">

<!-- 🔷 NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4">
    <div class="container-fluid d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center">
            <img src="images/campus-sync-logo.png" alt="CampusSync Logo" style="height: 40px; margin-right: 10px;">
            <h4 class="mb-0 fw-bold text-white">CampusSync</h4>
        </div>
        <div class="dropdown">
            <a class="text-white text-decoration-none" href="#" role="button" data-bs-toggle="dropdown">
                <span class="rounded-circle bg-white text-primary fw-bold d-inline-flex justify-content-center align-items-center" style="width: 40px; height: 40px; line-height:40px;">
                    <%= initials %>
                </span>
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="studentProfile.jsp">My Profile</a></li>
                <li><a class="dropdown-item text-danger" href="logout.jsp">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- 🔷 PROFILE CARD -->
<div class="container mt-5">
    <div class="card shadow-sm p-4">
        <div class="d-flex align-items-center mb-4">
            <div class="rounded-circle bg-primary text-white fw-bold d-flex justify-content-center align-items-center"
                 style="width: 60px; height: 60px; font-size: 1.5rem;">
                <%= initials %>
            </div>
            <div class="ms-3">
                <h4 class="fw-bold mb-0"><%= displayName %></h4>
                <small class="text-muted">Student Profile</small>
            </div>
        </div>

        <!-- 🔹 PERSONAL INFO -->
        <h5 class="fw-bold mb-3 text-primary">Personal Information</h5>
        <table class="table table-borderless">
            <tr><td><strong>Student Number:</strong></td><td><%= studentNumber %></td></tr>
            <tr><td><strong>Email:</strong></td><td><%= email != null ? email : sessionEmail %></td></tr>
            <tr><td><strong>Phone:</strong></td><td><%= phone != null ? phone : "" %></td></tr>
            <tr><td><strong>Programme:</strong></td><td><%= programme %></td></tr>
            <tr><td><strong>Year:</strong></td><td><%= year %></td></tr>
            <tr><td><strong>Campus:</strong></td><td><%= campus %></td></tr>
        </table>

        <!-- 🔹 COURSES -->
        <h5 class="fw-bold mt-4 text-primary">My Courses</h5>
        <table class="table">
            <thead class="table-light">
                <tr>
                    <th>Course Code</th>
                    <th>Course Name</th>
                    <th>Lecturer</th>
                </tr>
            </thead>
            <tbody>
            <% if (courses != null) {
                for (Map<String, String> course : courses) { %>
                    <tr>
                        <td><%= course.get("code") %></td>
                        <td><%= course.get("name") %></td>
                        <td><%= course.get("lecturer") %></td>
                    </tr>
            <% }} %>
            </tbody>
        </table>

        <!-- 🔹 CLUBS -->
        <h5 class="fw-bold mt-4 text-primary">My Clubs</h5>
        <ul>
        <% if (clubs != null) {
            for (String club : clubs) { %>
                <li><%= club %></li>
        <% }} %>
        </ul>

        <!-- 🔴 LOGOUT -->
        <div class="text-end mt-4">
            <a href="logout.jsp" class="btn btn-danger px-4">Logout</a>
        </div>
    </div>
</div>

<!-- 🔻 FOOTER -->
<footer class="text-center py-3 bg-primary text-white mt-5">
    <p class="mb-0">© 2025 CampusSync | Student Portal</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
