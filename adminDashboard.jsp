<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String adminName = (session != null && session.getAttribute("username") != null)
        ? (String) session.getAttribute("username")
        : "Admin";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
        }

        header {
            background-color: #0066cc;
            color: white;
            padding: 15px;
            display: flex;
            justify-content: space-between;
        }

        .tabs {
            display: flex;
            gap: 10px;
            background-color: #f4f4f4;
            padding: 10px;
        }

        .tab-button {
            padding: 10px 20px;
            background-color: white;
            border: 1px solid #ccc;
            cursor: pointer;
        }

        .tab-button:hover {
            background-color: #ddd;
        }

        .tab-content {
            display: none;
            padding: 20px;
        }

        .active {
            display: block;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            right: 10px;
            background-color: white;
            box-shadow: 0 0 5px #ccc;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .dropdown-content a {
            padding: 8px 12px;
            display: block;
            text-decoration: none;
            color: black;
        }

        #calendar {
            max-width: 900px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>

<header>
    <div>CampusSync</div>
    <div class="dropdown">
        <button>Hi, <%= adminName %> ▼</button>
        <div class="dropdown-content">
            <a href="adminProfile.jsp">Profile</a>
            <a href="logout.jsp">Logout</a>
        </div>
    </div>
</header>

<div class="tabs">
    <button class="tab-button" onclick="showTab('dashboard')">Dashboard</button>
    <button class="tab-button" onclick="showTab('approvals')">Approvals</button>
    <button class="tab-button" onclick="showTab('notices')">Notices</button>
    <button class="tab-button" onclick="showTab('courses')">Courses</button>
    <button class="tab-button" onclick="showTab('students')">Students</button>
</div>

<div id="dashboard" class="tab-content active">
    <h2>This Week Overview</h2>
    <div id="calendar"></div>
</div>

<div id="approvals" class="tab-content">
    <h2>Pending Approvals</h2>
    <p>No requests at the moment.</p>
</div>

<div id="notices" class="tab-content">
    <h2>Notices</h2>
    <p>No notices yet.</p>
</div>

<div id="courses" class="tab-content">
    <h2>All Courses</h2>
    <p>Course list goes here.</p>
</div>

<div id="students" class="tab-content">
    <h2>Students</h2>
    <p>Student list goes here.</p>
</div>

<script>
    function showTab(id) {
        const contents = document.getElementsByClassName('tab-content');
        for (let i = 0; i < contents.length; i++) {
            contents[i].classList.remove('active');
        }
        document.getElementById(id).classList.add('active');
    }

    document.addEventListener('DOMContentLoaded', function () {
        const calendarEl = document.getElementById('calendar');
        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            events: 'getCalendarEvents.jsp',
            height: 'auto',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek'
            }
        });
        calendar.render();
    });
</script>

</body>
</html>
