<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampusSync | Request Help</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/generalform.css">
</head>
<body>

<%
    String requestType = request.getParameter("type");
    String title = "Request Help";
    String description = "Please fill out the form below to submit your request to the administrator.";

    if ("password".equals(requestType)) {
        title = "Forgot Password";
        description = "Enter your email address to receive a link to reset your password.";
    } else if ("admin".equals(requestType)) {
        title = "Contact Administrator";
        description = "Use this form for account assistance, registration, or urgent issues.";
    }
%>

<div class="auth-wrapper">
    <div class="auth-card">
        <!-- LEFT SECTION -->
        <div class="promo">
            <h2 class="tagline">
                Forgot Your Password? <br>
                Need a new account? <br>
                <em>Happens to the best of us.</em>
            </h2>
            <div class="logo-container">
                <img src="images/campus-sync-logo.png" alt="CampusSync Logo" class="brand">
            </div>
        </div>

        <!-- RIGHT SECTION -->
        <div class="form-area">
            <h1><%= title %></h1>
            <p style="color:var(--muted); margin-bottom:20px;"><%= description %></p>

            <!-- FAKE SUBMIT FORM -->
            <form method="get" action="requestSuccess.jsp" class="form">
                <!-- Email Field -->
                <div class="field">
                    <span>Your Email</span>
                    <input type="email" name="requesterEmail" placeholder="Enter your email" required>
                </div>

                <!-- Request Type Dropdown -->
                <div class="field">
                    <span>Request Type</span>
                    <select name="requestOption" required 
                            style="width:100%;padding:12px 14px;border:1.5px solid #e5e7eb;
                                   border-radius:12px;font:inherit;outline:none;background:#fff;
                                   transition:border 0.15s, box-shadow 0.15s;">
                        <option value="" disabled selected>Select your request type</option>
                        <option value="password">Request New Password</option>
                        <option value="account">Request New Account</option>
                    </select>
                </div>

                <!-- Identification Field -->
                <div class="field">
                    <span>Identification</span>
                    <input type="text" name="identification" placeholder="ID / Passport / Student Number"
                           style="width:100%;padding:10px 14px;border:1.5px solid #e5e7eb;
                                  border-radius:10px;font:inherit;outline:none;
                                  transition:border 0.15s, box-shadow 0.15s;height:40px;">
                </div>

                <!-- FAKE SUBMIT BUTTON -->
                <button type="submit" class="btn">Submit Request</button>
            </form>

            <div class="meta center" style="margin-top:20px;">
                <a href="login.jsp" class="link">← Back to Sign In</a>
            </div>

            <div class="meta center" style="margin-top:24px;">© 2025 CampusSync | Group 21</div>
        </div>
    </div>
</div>
</body>
</html>
