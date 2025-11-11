<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampusSync | Request Submitted</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to bottom right, #f0f4ff, #e6f9f5);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .success-container {
            background: #fff;
            border-radius: 18px;
            padding: 50px 60px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
            text-align: center;
            max-width: 500px;
        }
        h1 {
            color: #009b5c;
            font-size: 26px;
            margin-bottom: 15px;
        }
        p {
            color: #333;
            font-size: 15px;
            margin: 8px 0;
        }
        .btn {
            display: inline-block;
            background: linear-gradient(90deg, #0066ff, #ff6600, #00cc66);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            padding: 10px 24px;
            margin-top: 25px;
            font-size: 14px;
            transition: 0.3s ease;
        }
        .btn:hover {
            opacity: 0.85;
            transform: scale(1.02);
        }
    </style>
</head>
<body>
    <div class="success-container">
        <h1>Request Submitted Successfully</h1>
        <p>Thank you! Your request has been received by the administrator.</p>
        <p>We'll get back to you as soon as possible.</p>
        <a href="login.jsp" class="btn">← Back to Login</a>
    </div>
</body>
</html>
