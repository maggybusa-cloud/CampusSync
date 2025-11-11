<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session.invalidate();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Campus Sync • Signed Out</title>
    <!-- Same CSS file (login.css) to maintain the look -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/generalform.css">
</head>
<body>
    <div class="auth-wrapper">
        <div class="auth-card">
            <!-- Left panel (Same as login) -->
            <aside class="promo">
                <h2 class="tagline">Plan Smart...<br><em>Sync Everything</em></h2>
                <div class="logo-container">
                    
                    <img class="brand" src="images/CampusSync logo (transparent).png" alt="Campus Sync logo" />
                </div>
            </aside>

            <!-- Right panel (Logout Confirmation) -->
            <main class="form-area">
                <!-- Successful sign-out -->
                <h1>Signed Out</h1> 

                <div class="form" style="display: block; text-align: center;">
                    <p style="margin-bottom: 25px; font-size: 1.1rem; color: var(--ink);">
                        You have successfully logged out of Campus Sync.
                    </p>
                    <p style="margin-bottom: 30px; color: var(--muted);">
                        Thank you for using the system.
                    </p>

                    <!-- Button to redirect back to the main login page -->
                    <a href="index.jsp" class="btn" 
                       style="display: block; text-decoration: none; width: 100%; margin-top: 10px;">
                        Return to Sign In
                    </a>
                </div>

                <p class="meta center">
                    Need help? 
                    <a class="link" href="#">Contact Admin</a>
                </p>
            </main>
        </div>
    </div>
</body>
</html>