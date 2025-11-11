<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampusSync | Sign In</title>

    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <!-- Your main CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/generalform.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card">
        <!-- LEFT SECTION -->
        <div class="promo">
            <h2 class="tagline">
                Manage your classes, tasks, exams and more.<br>
                <em>All in one place.</em>
            </h2>
            <div class="logo-container">
                <img src="images/campus-sync-logo.png" alt="CampusSync Logo" class="brand">
            </div>
        </div>

        <!-- RIGHT SECTION -->
        <div class="form-area">
            <h1>Sign In</h1>
            <p class="muted-text">Welcome back! Enter your details and let's get planning!</p>

            <%
                String error = (String) request.getAttribute("error");
                String email = (String) request.getAttribute("email");
                if (error != null) {
                    if ("email_not_found".equals(error)) {
            %>
                        <div class="error-msg">This email is not registered. Please contact Admin or request a new account.</div>
            <%
                    } else if ("invalid_password".equals(error)) {
            %>
                        <div class="error-msg">Incorrect password. Please try again.</div>
            <%
                    } else if ("server_error".equals(error)) {
            %>
                        <div class="error-msg">A server error occurred. Please try again later.</div>
            <%
                    } else {
            %>
                        <div class="error-msg">Something went wrong. Please try again.</div>
            <%
                    }
                }
            %>

            <form method="post" action="LoginServlet" class="form">
                <div class="field">
                    <span>Email</span>
                    <input type="email" name="email" placeholder="Enter your email" value="<%= email != null ? email : "" %>" required>
                </div>

                <div class="field">
                    <span>Password</span>
                    <input type="password" name="password" placeholder="Enter password" required>
                </div>

                <button type="submit" class="btn">Continue</button>
            </form>

            <div class="meta center">
                <a href="requestForm.jsp" class="link">Forgot password?</a>
            </div>

            <div class="meta center">
                Need help? <a href="requestForm.jsp" class="link">Contact Admin</a>
            </div>

            <div class="meta center copyright">© 2025 CampusSync | Group 21</div>
        </div>
    </div>
</div>
</body>
</html>
