<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.campussync.model.Student" %>
<%
    String studentName = (session != null && session.getAttribute("username") != null)
        ? (String) session.getAttribute("username")
        : "Student";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CampusSync | Student Dashboard</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>

    <style>
        body {
            font-family: 'Poppins', Arial, sans-serif;
            background-color: #f4f7fc;
            margin: 0;
            padding: 0;
        }
        .navbar-custom {
            background: linear-gradient(90deg, #1d4ed8, #3b82f6);
        }
        .dashboard-header {
            padding: 30px 40px 10px 40px;
        }
        .dashboard-header h3 {
            font-weight: bold;
        }
        .dashboard-header p {
            color: #6c757d;
            margin-bottom: 0;
        }
        .tabs {
            padding: 0 40px 20px 40px;
        }
        .calendar-container {
            padding: 0 40px 40px 40px;
        }
        .footer {
            background-color: #0d6efd;
            color: white;
            text-align: center;
            padding: 10px;
            font-size: 14px;
            margin-top: 20px;
        }
        #sideButtons {
            position: fixed;
            right: 25px;
            bottom: 60px;
            display: flex;
            flex-direction: column;
            gap: 15px;
            z-index: 9999;
        }
    </style>
</head>
<body>
<!-- 🔷 NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark px-4 navbar-custom">
    <div class="container-fluid d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center">
            <img src="images/campus-sync-logo.png" alt="CampusSync Logo" style="height: 40px; margin-right: 10px;">
            <h4 class="mb-0 fw-bold text-white">CampusSync</h4>
        </div>
        <div class="dropdown">
            <a class="text-white fw-semibold dropdown-toggle text-decoration-none" href="#" role="button" data-bs-toggle="dropdown">
                Hi, <%= studentName %>
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="studentProfile.jsp">My Profile</a></li>
                <li><a class="dropdown-item text-danger" href="Logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- 🔷 HEADER -->
<div class="dashboard-header">
    <h3>Hi <%= studentName %></h3>
    <p>Here's your campus life at a glance.</p>
</div>

<!-- 🔷 TABS -->
<div class="tabs">
    <ul class="nav nav-tabs">
        <li class="nav-item">
            <a class="nav-link active" href="#thisWeek">This Week</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#courses">My Courses</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#clubs">My Clubs</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#planner" id="plannerTab">My Planner</a>
        </li>
    </ul>
</div>

<!-- 🔷 CALENDAR -->
<div class="calendar-container" id="planner">
    <div id="calendar"></div>
</div>

<!-- 🔷 FIXED BUTTONS -->
<div id="sideButtons">
    <a href="#planner" class="btn btn-info" style="width: 120px;">📅 View Calendar</a>
    <button type="button" class="btn btn-danger" style="width: 120px;" data-bs-toggle="modal" data-bs-target="#addTaskModal">➕ Add Task</button>
</div>

<!-- 🔷 ADD TASK MODAL -->
<div class="modal fade" id="addTaskModal" tabindex="-1" aria-labelledby="addTaskModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="addTaskModalLabel">Add New Task</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="AddTaskServlet" method="post">
        <div class="modal-body">
          <div class="mb-3">
            <label for="taskTitle" class="form-label">Task Title</label>
            <input type="text" class="form-control" id="taskTitle" name="title" required>
          </div>
          <div class="mb-3">
            <label for="taskDate" class="form-label">Due Date</label>
            <input type="date" class="form-control" id="taskDate" name="dueDate" required>
          </div>
          <div class="mb-3">
            <label for="taskDescription" class="form-label">Description</label>
            <textarea class="form-control" id="taskDescription" name="description" rows="3"></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">Save Task</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 🔷 FOOTER -->
<div class="footer">
    © 2025 CampusSync | Group 21
</div>

<!-- 🔷 JS for FullCalendar -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var calendarEl = document.getElementById('calendar');
        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'timeGridWeek', // shows the week view
            height: 'auto',
            events: 'getCalendarEvents.jsp', // backend to fetch events
            headerToolbar: {
                left: '',
                center: 'title',
                right: ''
            }
        });
        calendar.render();
    });
</script>

</body>
</html>
