<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="za.campussync.db.DBConnection,java.sql.*,java.util.*" %>
<%
    String studentName = (session != null && session.getAttribute("firstName") != null)
        ? (String) session.getAttribute("firstName")
        : "Student";

    // Build course list for Subject dropdown
    List<Map<String, Object>> courseList = new ArrayList<>();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT course_id, course_name FROM courses ORDER BY course_name");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", rs.getObject("course_id"));
                m.put("name", rs.getString("course_name"));
                courseList.add(m);
            }
        }
    } catch (Exception ex) {
        ex.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CampusSync | <%= studentName %> Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', Arial, sans-serif; background-color: #f4f7fc; padding: 0; margin: 0; }
        .navbar-custom { background: linear-gradient(90deg, #1d4ed8, #3b82f6); }
        .navbar-custom .navbar-brand, .navbar-custom .navbar-text, .navbar-custom .nav-link { color: white; font-weight: 500; }
        .navbar-custom .nav-link:hover { color: #e0e0e0; }
        .greeting-section { margin: 30px 60px 10px; }
        .greeting-section h2 { font-weight: 600; color: #1d4ed8; margin-bottom: 5px; }
        .greeting-section p { color: #6b7280; font-size: 14px; margin-top: 0; }
        .tabs { margin: 20px 60px 0; }
        .tabs .nav-tabs .nav-link { border: none; font-weight: 500; color: #3b82f6; cursor: pointer; }
        .tabs .nav-tabs .nav-link.active { border-bottom: 2px solid #1d4ed8; font-weight: 600; color: #1d4ed8; }
        .tab-content > div { display: none; }
        .tab-content > div.active { display: block; }
        #calendar-wrapper { max-width: 1000px; margin: 20px auto; background-color: #fff; padding: 20px; border-radius: 12px; box-shadow: 0 6px 20px rgba(0,0,0,0.08); }
        .fc-toolbar-title { color: #1d4ed8; font-weight: 600; }
        .fc-button { background-color: #3b82f6 !important; border-color: #3b82f6 !important; color: white !important; }
        .fc-button:hover { background-color: #1d4ed8 !important; border-color: #1d4ed8 !important; }
        .fc .fc-daygrid-day-number { color: #3b82f6; font-weight: 500; }
        .calendar-buttons { display: flex; gap: 10px; justify-content: flex-end; margin: 20px 60px; }
        .btn-add-task { background-color: #f43f5e; color: white; }
        .btn-add-task:hover { background-color: #be123c; }
        .btn-view-calendar { background-color: #06b6d4; color: white; }
        .btn-view-calendar:hover { background-color: #0e7490; }
        .footer { background-color: #0d6efd; color: white; text-align: center; padding: 10px; font-size: 14px; margin-top: 40px; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark px-4 navbar-custom">
    <div class="container-fluid d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center">
            <img src="images/campus-sync-logo.png" alt="CampusSync Logo" style="height: 40px; margin-right: 10px;">
            <h4 class="mb-0 fw-bold text-white">CampusSync</h4>
        </div>
        <div class="dropdown">
            <a class="dropdown-toggle text-white text-decoration-none fw-semibold" href="#" role="button" data-bs-toggle="dropdown">
                <%= studentName %>
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="studentProfile.jsp">My Profile</a></li>
                <li><a class="dropdown-item text-danger" href="logout.jsp">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="greeting-section">
    <h2>Hi, <%= studentName %> 👋🏾</h2>
    <p>Here’s your campus life at a glance.</p>
</div>

<div class="tabs">
    <ul class="nav nav-tabs">
        <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" href="#thisWeek">This Week</a></li>
        <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#courses">My Courses</a></li>
        <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#clubs">My Clubs</a></li>
        <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#planner">My Planner</a></li>
    </ul>
</div>

<div class="tab-content">
    <div class="tab-pane fade show active" id="thisWeek">
        <div class="calendar-buttons">
            <a href="#planner" class="btn btn-view-calendar">📅 View Calendar</a>
            <button type="button" class="btn btn-add-task" data-bs-toggle="modal" data-bs-target="#addTaskModal">➕ Add Task</button>
        </div>
        <div id="calendar-wrapper">
            <p>Here's what's going on this week:</p>
            <div id="calendar"></div>
        </div>
    </div>
    <div class="tab-pane fade" id="courses">
        <div class="container mt-4">
            <h5 class="mb-3">Enrolled Courses and Events</h5>
            <!-- Placeholder example -->
            <div class="card">
                <div class="card-header">Introduction to Java</div>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item">Assignment 1 – Due 10 Nov 2025</li>
                    <li class="list-group-item">Test 2 – Due 15 Nov 2025</li>
                </ul>
            </div>
        </div>
    </div>
    <div class="tab-pane fade" id="clubs">
        <div class="container mt-4">
            <h5 class="mb-3">Your Clubs</h5>
            <p>List of student clubs you're part of will appear here.</p>
        </div>
    </div>
    <div class="tab-pane fade" id="planner">
        <div class="container mt-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="mb-0">Planner</h5>
                <button type="button" class="btn btn-add-task" data-bs-toggle="modal" data-bs-target="#addTaskModal">Add Task</button>
            </div>
            <div id="plannerCalendar" class="bg-white rounded-3 shadow p-3"></div>
        </div>
    </div>
</div>

<!-- 🔷 ADD TASK MODAL -->
<div class="modal fade" id="addTaskModal" tabindex="-1" aria-labelledby="addTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addTaskModalLabel">Add New Task</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="<%= request.getContextPath() %>/AddTaskServlet" method="post">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label for="taskTitle" class="form-label">Title</label>
                            <input type="text" class="form-control" id="taskTitle" name="title" required>
                        </div>
                        <div class="col-md-4">
                            <label for="subject" class="form-label">Subject</label>
                            <select id="subject" name="courseId" class="form-select" required>
                                <option value="">Select Subject</option>
                                <%
                                    for (Map<String, Object> cRow : courseList) {
                                %>
                                    <option value="<%= cRow.get("id") %>"><%= cRow.get("name") %></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>

                        <div class="col-12">
                            <label for="taskDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="taskDescription" name="description" rows="3" placeholder="Optional"></textarea>
                        </div>

                        <div class="col-12">
                            <label class="form-label d-block">Task Type</label>
                            <div class="d-flex flex-wrap gap-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="taskType" id="typeReminder" value="Reminder" checked>
                                    <label class="form-check-label" for="typeReminder">Reminder</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="taskType" id="typeRevision" value="Revision">
                                    <label class="form-check-label" for="typeRevision">Revision</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="taskType" id="typeEssay" value="Essay">
                                    <label class="form-check-label" for="typeEssay">Essay</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="taskType" id="typeGroup" value="Group Project">
                                    <label class="form-check-label" for="typeGroup">Group Project</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="taskType" id="typeReading" value="Reading">
                                    <label class="form-check-label" for="typeReading">Reading</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="taskType" id="typeMeeting" value="Meeting">
                                    <label class="form-check-label" for="typeMeeting">Meeting</label>
                                </div>
                            </div>
                        </div>

                        <div class="col-12">
                            <label class="form-label d-block">Occurs</label>
                            <div class="d-flex gap-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="occurs" id="occursOnce" value="once" checked onchange="toggleOccurs()">
                                    <label class="form-check-label" for="occursOnce">Once</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="occurs" id="occursRepeating" value="repeating" onchange="toggleOccurs()">
                                    <label class="form-check-label" for="occursRepeating">Repeating</label>
                                </div>
                            </div>
                        </div>

                        <!-- Once fields -->
                        <div id="onceFields" class="row g-3">
                            <div class="col-md-6">
                                <label for="dueDate" class="form-label">Due Date</label>
                                <input type="date" class="form-control" id="dueDate" name="dueDate">
                            </div>
                            <div class="col-md-6">
                                <label for="dueTime" class="form-label">Time</label>
                                <input type="time" class="form-control" id="dueTime" name="dueTime">
                            </div>
                        </div>

                        <!-- Repeating fields -->
                        <div id="repeatFields" class="row g-3 d-none">
                            <div class="col-12">
                                <label class="form-label d-block">Days of the week</label>
                                <div class="d-flex flex-wrap gap-3">
                                    <label class="form-check"><input class="form-check-input" type="checkbox" name="days" value="Mon"> Mon</label>
                                    <label class="form-check"><input class="form-check-input" type="checkbox" name="days" value="Tue"> Tue</label>
                                    <label class="form-check"><input class="form-check-input" type="checkbox" name="days" value="Wed"> Wed</label>
                                    <label class="form-check"><input class="form-check-input" type="checkbox" name="days" value="Thu"> Thu</label>
                                    <label class="form-check"><input class="form-check-input" type="checkbox" name="days" value="Fri"> Fri</label>
                                    <label class="form-check"><input class="form-check-input" type="checkbox" name="days" value="Sat"> Sat</label>
                                    <label class="form-check"><input class="form-check-input" type="checkbox" name="days" value="Sun"> Sun</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="startTime" class="form-label">Start Time</label>
                                <input type="time" class="form-control" id="startTime" name="startTime">
                            </div>
                            <div class="col-md-6">
                                <label for="endTime" class="form-label">End Time</label>
                                <input type="time" class="form-control" id="endTime" name="endTime">
                            </div>
                            <div class="col-12 d-flex align-items-center mt-2">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" role="switch" id="toggleDateRange" onchange="toggleDateRange()">
                                    <label class="form-check-label" for="toggleDateRange">Add start/end dates?</label>
                                </div>
                            </div>
                            <div id="dateRangeFields" class="row g-3 d-none mt-1">
                                <div class="col-md-6">
                                    <label for="startDate" class="form-label">Start Date</label>
                                    <input type="date" class="form-control" id="startDate" name="startDate">
                                </div>
                                <div class="col-md-6">
                                    <label for="endDate" class="form-label">End Date</label>
                                    <input type="date" class="form-control" id="endDate" name="endDate">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Save</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="footer">© 2025 CampusSync | Group 21</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const calendarEl = document.getElementById('calendar');
        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'timeGridWeek',
            height: 'auto',
            events: 'getCalendarEvents.jsp',
            headerToolbar: { left: '', center: 'title', right: '' },
            slotMinTime: '08:00:00',
            slotMaxTime: '20:00:00'
        });
        calendar.render();

        // Planner calendar with day/week/month views
        const plannerEl = document.getElementById('plannerCalendar');
        if (plannerEl) {
            const planner = new FullCalendar.Calendar(plannerEl, {
                initialView: 'timeGridWeek',
                height: 'auto',
                headerToolbar: { left: 'prev,next today', center: 'title', right: 'dayGridMonth,timeGridWeek,timeGridDay' },
                events: 'getCalendarEvents.jsp'
            });
            planner.render();
        }

        // Enable tab switching
        const tabs = document.querySelectorAll('.nav-link');
        tabs.forEach(tab => {
            tab.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelectorAll('.tab-pane').forEach(pane => pane.classList.remove('show', 'active'));
                document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
                document.querySelector(this.getAttribute('href')).classList.add('show', 'active');
                this.classList.add('active');
            });
        });

        // Scroll to planner tab on button click
        document.querySelector('.btn-view-calendar').addEventListener('click', () => {
            document.querySelector('[href="#planner"]').click();
            document.getElementById('planner').scrollIntoView({ behavior: 'smooth' });
        });
    });
</script>
<script>
    function toggleOccurs() {
        const once = document.getElementById('occursOnce').checked;
        const onceFields = document.getElementById('onceFields');
        const repeatFields = document.getElementById('repeatFields');

        if (once) {
            onceFields.classList.remove('d-none');
            repeatFields.classList.add('d-none');
            document.getElementById('dueDate')?.setAttribute('required', 'required');
            document.getElementById('dueTime')?.setAttribute('required', 'required');
            document.getElementById('startTime')?.removeAttribute('required');
            document.getElementById('endTime')?.removeAttribute('required');
        } else {
            onceFields.classList.add('d-none');
            repeatFields.classList.remove('d-none');
            document.getElementById('dueDate')?.removeAttribute('required');
            document.getElementById('dueTime')?.removeAttribute('required');
            document.getElementById('startTime')?.setAttribute('required', 'required');
            document.getElementById('endTime')?.setAttribute('required', 'required');
        }
    }

    function toggleDateRange() {
        const checked = document.getElementById('toggleDateRange').checked;
        const fields = document.getElementById('dateRangeFields');
        if (checked) {
            fields.classList.remove('d-none');
        } else {
            fields.classList.add('d-none');
        }
    }
</script>
</body>
</html>
