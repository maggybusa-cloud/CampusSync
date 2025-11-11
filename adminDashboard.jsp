<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="za.campussync.db.DBConnection,java.sql.*,java.util.*" %>
<%
    String adminName = (session != null && session.getAttribute("username") != null)
        ? (String) session.getAttribute("username")
        : "Admin";
%>
<%
    int pendingRequests = 0;
    int totalStudents = 0;
    int upcomingEvents = 0;
    List<Map<String,Object>> courseList = new ArrayList<>();
    List<Map<String,Object>> clubList = new ArrayList<>();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection c = DBConnection.getConnection()) {
            try (PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM support_requests WHERE status='Pending'")) {
                ResultSet rs = ps.executeQuery(); if (rs.next()) pendingRequests = rs.getInt(1);
            }
            try (PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM users WHERE role='student'")) {
                ResultSet rs = ps.executeQuery(); if (rs.next()) totalStudents = rs.getInt(1);
            }
            try (PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM events WHERE event_date >= CURDATE()")) {
                ResultSet rs = ps.executeQuery(); if (rs.next()) upcomingEvents = rs.getInt(1);
            }
            try (PreparedStatement ps = c.prepareStatement("SELECT course_id, course_name FROM courses ORDER BY course_name")) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) { Map<String,Object> m=new HashMap<>(); m.put("id", rs.getObject(1)); m.put("name", rs.getString(2)); courseList.add(m);} }
            try (PreparedStatement ps = c.prepareStatement("SELECT club_id, club_name FROM clubs ORDER BY club_name")) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) { Map<String,Object> m=new HashMap<>(); m.put("id", rs.getObject(1)); m.put("name", rs.getString(2)); clubList.add(m);} }
        }
    } catch (Exception ex) { ex.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CampusSync | Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.js"></script>
    <!-- Style tweaks to match student look -->
    <style>
        /* Override square tabs with rounded, modern look */
        body { font-family: 'Poppins', Arial, sans-serif; background-color: #f4f7fc; }
        header { background: linear-gradient(90deg, #1d4ed8, #3b82f6); color: #fff; display:flex; justify-content:space-between; padding:15px 24px; }
        .tabs { display: flex; gap: 10px; background: transparent; padding: 10px 60px; flex-wrap: wrap; }
        .tab-button {
            padding: 10px 18px;
            background: #fff;
            border: 1.5px solid #e5e7eb;
            border-radius: 12px;
            color: #1d4ed8;
            font-weight: 500;
            cursor: pointer;
            transition: background .15s ease, box-shadow .15s ease, color .15s ease;
        }
        .tab-button:hover { background: #eef4ff; box-shadow: 0 6px 14px rgba(29,78,216,0.12); }
        .tab-button.active { background: #1d4ed8; color: #fff; box-shadow: 0 8px 18px rgba(29,78,216,0.25); border-color: transparent; }
        #calendar { max-width: 1000px; border-radius: 12px; box-shadow: 0 6px 20px rgba(0,0,0,0.08); }

        /* Ensure only the active tab's content is visible */
        .tab-content { display: none; padding: 20px; }
        .tab-content.active { display: block; }
    </style>
    <!-- Removed legacy styles to allow modern look -->
</head>
<body>

<header>
    <div class="d-flex align-items-center">
        <img src="images/campus-sync-logo.png" alt="CampusSync Logo" style="height: 40px; margin-right: 10px;">
        <h4 class="mb-0 fw-bold">CampusSync</h4>
    </div>
    <div class="dropdown">
        <a class="text-white text-decoration-none dropdown-toggle" href="#" data-bs-toggle="dropdown">Hi, <%= adminName %></a>
        <ul class="dropdown-menu dropdown-menu-end">
            <li><a class="dropdown-item" href="adminProfile.jsp">Profile</a></li>
            <li><a class="dropdown-item text-danger" href="logout.jsp">Logout</a></li>
        </ul>
    </div>
</header>

<div class="tabs">
    <button class="tab-button active" onclick="showTab('dashboard', this)">Dashboard</button>
    <button class="tab-button" onclick="showTab('students', this)">Students</button>
    <button class="tab-button" onclick="showTab('courses', this)">Courses</button>
    <button class="tab-button" onclick="showTab('events', this)">Events</button>
    <button class="tab-button" onclick="showTab('clubs', this)">Clubs</button>
    <button class="tab-button" onclick="showTab('requests', this)">Requests</button>
    <button class="tab-button" onclick="showTab('notices', this)">Notices</button>
</div>

<div id="dashboard" class="tab-content active">
    <div class="container-fluid">
        <div class="row g-3">
            <div class="col-lg-8">
                <div class="bg-white rounded-3 shadow p-3 mb-3">
                    <h5 class="mb-3">Key Stats</h5>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="border rounded-3 p-3 text-center">
                                <div class="text-muted">Pending Requests</div>
                                <div class="fs-3 fw-bold"><%= pendingRequests %></div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="border rounded-3 p-3 text-center">
                                <div class="text-muted">Total Students</div>
                                <div class="fs-3 fw-bold"><%= totalStudents %></div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="border rounded-3 p-3 text-center">
                                <div class="text-muted">Upcoming Events</div>
                                <div class="fs-3 fw-bold"><%= upcomingEvents %></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="bg-white rounded-3 shadow p-3">
                    <h5 class="mb-3">Calendar – This Week</h5>
                    <div id="calendar"></div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="bg-white rounded-3 shadow p-3">
                    <h5 class="mb-3">Quick Actions</h5>
                    <div class="d-grid gap-2">
                        <button class="btn btn-outline-primary" onclick="showTab('students', document.querySelector('.tabs .tab-button:nth-child(2)'))">Manage Students</button>
                        <button class="btn btn-outline-success" data-bs-toggle="modal" data-bs-target="#courseModal">Add New Course</button>
                        <button class="btn btn-outline-info" data-bs-toggle="modal" data-bs-target="#eventModal">Add Event</button>
                        <a class="btn btn-outline-primary" href="adminCalendar.jsp">View Calendar</a>
                        <button class="btn btn-outline-warning" data-bs-toggle="modal" data-bs-target="#noticeModal">Post New Notice</button>
                        <button class="btn btn-outline-secondary" onclick="showTab('requests', document.querySelector('.tabs .tab-button:nth-child(6)'))">View All Requests</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="students" class="tab-content">
    <div class="container mt-3">
        <div class="row g-3">
            <div class="col-lg-9">
                <div class="bg-white rounded-3 shadow p-3">
                    <h5 class="mb-3">Students</h5>
                    <table class="table table-sm align-middle">
                        <thead>
                        <tr><th>#</th><th>Student No.</th><th>First Name</th><th>Last Name</th><th>Email</th><th>Phone</th><th>Course</th><th class="text-end">Actions</th></tr>
                        </thead>
                        <tbody>
                        <%
                          try (Connection c = DBConnection.getConnection();
                               PreparedStatement ps = c.prepareStatement("SELECT u.user_id, u.student_number, u.first_name, u.last_name, u.email, u.phone, c.course_name, c.course_id FROM users u LEFT JOIN student_courses sc ON sc.user_id=u.user_id LEFT JOIN courses c ON sc.course_id=c.course_id WHERE u.role='student' ORDER BY u.first_name")) {
                               ResultSet rs = ps.executeQuery();
                               int i=1; boolean any=false; 
                               while (rs.next()) { any=true; 
                        %>
                          <tr>
                            <td><%= i++ %></td>
                            <td><%= rs.getString("student_number") %></td>
                            <td><%= rs.getString("first_name") %></td>
                            <td><%= rs.getString("last_name") %></td>
                            <td><%= rs.getString("email") %></td>
                            <td><%= rs.getString("phone") == null ? "" : rs.getString("phone") %></td>
                            <td data-course-id="<%= rs.getObject("course_id") %>"><%= rs.getString("course_name") == null ? "" : rs.getString("course_name") %></td>
                            <td class="text-end">
                              <button type="button" class="btn btn-sm btn-outline-secondary" onclick="openEditStudent(this)" 
                                data-user-id="<%= rs.getInt("user_id") %>"
                                data-student-number="<%= rs.getString("student_number") %>"
                                data-first-name="<%= rs.getString("first_name") %>"
                                data-last-name="<%= rs.getString("last_name") %>"
                                data-email="<%= rs.getString("email") %>"
                                data-phone="<%= rs.getString("phone") == null ? "" : rs.getString("phone") %>"
                                data-course-id="<%= rs.getObject("course_id") %>">Edit</button>
                              <form method="post" action="<%= request.getContextPath() %>/RemoveStudentServlet" class="d-inline" onsubmit="return confirm('Remove this student?');">
                                <input type="hidden" name="userId" value="<%= rs.getInt("user_id") %>">
                                <button class="btn btn-sm btn-outline-danger" type="submit">Delete</button>
                              </form>
                            </td>
                          </tr>
                        <%
                               }
                               if (!any) {
                        %>
                          <tr><td colspan="4" class="text-muted">No students found.</td></tr>
                        <%
                               }
                          } catch (Exception ignore) { %>
                          <tr><td colspan="4" class="text-muted">Unable to load students.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="bg-white rounded-3 shadow p-3 mb-3">
                    <div class="text-muted">Total Students</div>
                    <div class="fs-3 fw-bold"><%= totalStudents %></div>
                </div>
                <div class="bg-white rounded-3 shadow p-3">
                    <h6>Actions</h6>
                    <div class="d-grid gap-2">
                        <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#addStudentModal">Add New Student</button>
                        <button class="btn btn-outline-secondary">Edit Student Details</button>
                        <button class="btn btn-outline-danger">Remove Student</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="courses" class="tab-content">
    <div class="container mt-3">
        <div class="row g-3">
            <div class="col-lg-9">
                <div class="bg-white rounded-3 shadow p-3">
                    <h5 class="mb-3">Courses</h5>
                    <table class="table table-sm align-middle">
                        <thead>
                        <tr><th>Code</th><th>Title</th><th>Lecturer</th><th class="text-end">Actions</th></tr>
                        </thead>
                        <tbody>
                        <%
                          try (Connection c = DBConnection.getConnection();
                               PreparedStatement ps = c.prepareStatement("SELECT c.course_id, c.course_code, c.course_name, c.lecturer_name FROM courses c ORDER BY c.course_name")) {
                               ResultSet rs = ps.executeQuery(); boolean any=false;
                               while (rs.next()) { any=true; %>
                          <tr>
                            <td><%= rs.getString("course_code") %></td>
                            <td><%= rs.getString("course_name") %></td>
                            <td><%= rs.getString("lecturer_name") %></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary" type="button" onclick="openEditCourse(<%= rs.getInt("course_id") %>,'<%= rs.getString("course_code") %>','<%= rs.getString("course_name").replace("'","\u2019") %>','<%= rs.getString("lecturer_name") == null ? "" : rs.getString("lecturer_name").replace("'","\u2019") %>')">Edit</button>
                                <form method="post" action="<%= request.getContextPath() %>/RemoveCourseServlet" class="d-inline" onsubmit="return confirm('Remove this course?');">
                                  <input type="hidden" name="course_id" value="<%= rs.getInt("course_id") %>">
                                  <button class="btn btn-sm btn-outline-danger" type="submit">Delete</button>
                                </form>
                            </td>
                          </tr>
                        <% }
                           if (!any) { %>
                          <tr><td colspan="4" class="text-muted">No courses found.</td></tr>
                        <% }
                          } catch (Exception ignore) { %>
                          <tr><td colspan="4" class="text-muted">Unable to load courses.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="bg-white rounded-3 shadow p-3">
                    <h6>Actions</h6>
                    <div class="d-grid gap-2">
                        <button class="btn btn-outline-success" data-bs-toggle="modal" data-bs-target="#courseModal">Add New Course</button>
                        <button class="btn btn-outline-secondary" disabled>Edit Course Information</button>
                        <button class="btn btn-outline-danger" disabled>Remove Course</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="events" class="tab-content">
    <div class="container mt-3">
        <div class="row g-3">
            <div class="col-lg-9">
                <div class="bg-white rounded-3 shadow p-3 mb-3">
                    <h5 class="mb-2">Course Events</h5>
                    <table class="table table-sm align-middle">
                        <thead><tr><th>Title</th><th>Type</th><th>Course</th><th>Date</th><th>Time</th></tr></thead>
                        <tbody>
                        <%
                          try (Connection c = DBConnection.getConnection();
                               PreparedStatement ps = c.prepareStatement("SELECT e.title, e.type, c.course_name, e.event_date, e.event_time FROM events e LEFT JOIN courses c ON e.course_id=c.course_id WHERE e.related_to='course' ORDER BY e.event_date, e.event_time")) {
                               ResultSet rs = ps.executeQuery(); boolean any=false; while (rs.next()) { any=true; %>
                          <tr>
                            <td><%= rs.getString(1) %></td>
                            <td><%= rs.getString(2) %></td>
                            <td><%= rs.getString(3) %></td>
                            <td><%= rs.getString(4) %></td>
                            <td><%= rs.getString(5) %></td>
                          </tr>
                        <% } if(!any){ %><tr><td colspan="5" class="text-muted">No course events.</td></tr><% } } catch(Exception ignore){ %>
                          <tr><td colspan="5" class="text-muted">Unable to load course events.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <div class="bg-white rounded-3 shadow p-3">
                    <h5 class="mb-2">Club Events</h5>
                    <table class="table table-sm align-middle">
                        <thead><tr><th>Title</th><th>Type</th><th>Club</th><th>Date</th><th>Time</th></tr></thead>
                        <tbody>
                        <%
                          try (Connection c = DBConnection.getConnection();
                               PreparedStatement ps = c.prepareStatement("SELECT e.title, e.type, cl.club_name, e.event_date, e.event_time FROM events e LEFT JOIN clubs cl ON e.club_id=cl.club_id WHERE e.related_to='club' ORDER BY e.event_date, e.event_time")) {
                               ResultSet rs = ps.executeQuery(); boolean any=false; while (rs.next()) { any=true; %>
                          <tr>
                            <td><%= rs.getString(1) %></td>
                            <td><%= rs.getString(2) %></td>
                            <td><%= rs.getString(3) %></td>
                            <td><%= rs.getString(4) %></td>
                            <td><%= rs.getString(5) %></td>
                          </tr>
                        <% } if(!any){ %><tr><td colspan="5" class="text-muted">No club events.</td></tr><% } } catch(Exception ignore){ %>
                          <tr><td colspan="5" class="text-muted">Unable to load club events.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="bg-white rounded-3 shadow p-3">
                    <h6>Actions</h6>
                    <div class="d-grid gap-2">
                        <button class="btn btn-outline-info" data-bs-toggle="modal" data-bs-target="#eventModal">+ Add Event</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="clubs" class="tab-content">
    <div class="container mt-3">
        <div class="row g-3">
            <div class="col-lg-9">
                <div class="bg-white rounded-3 shadow p-3">
                    <h5 class="mb-3">Clubs</h5>
                    <table class="table table-sm align-middle">
                        <thead><tr><th>#</th><th>Club</th><th class="text-end">Actions</th></tr></thead>
                        <tbody>
                        <%
                          try (Connection c = DBConnection.getConnection();
                               PreparedStatement ps = c.prepareStatement("SELECT club_id, club_name, description FROM clubs ORDER BY club_name")) {
                               ResultSet rs = ps.executeQuery(); int i=1; boolean any=false; while(rs.next()){ any=true; %>
                          <tr>
                            <td><%= i++ %></td>
                            <td><%= rs.getString("club_name") %></td>
                            <td class="text-end">
                              <button class="btn btn-sm btn-outline-secondary" type="button" onclick="openEditClub(<%= rs.getInt("club_id") %>,'<%= rs.getString("club_name").replace("'","\u2019") %>','<%= (rs.getString("description")==null?"":rs.getString("description").replace("'","\u2019")) %>')">Edit</button>
                              <form method="post" action="<%= request.getContextPath() %>/RemoveClubServlet" class="d-inline" onsubmit="return confirm('Remove this club?');">
                                <input type="hidden" name="club_id" value="<%= rs.getInt("club_id") %>">
                                <button class="btn btn-sm btn-outline-danger" type="submit">Delete</button>
                              </form>
                            </td>
                          </tr>
                        <% } if(!any){ %><tr><td colspan="2" class="text-muted">No clubs found.</td></tr><% } } catch(Exception ignore){ %>
                          <tr><td colspan="2" class="text-muted">Unable to load clubs.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="bg-white rounded-3 shadow p-3">
                    <h6>Manage Clubs</h6>
                    <div class="d-grid gap-2">
                        <button class="btn btn-outline-success" data-bs-toggle="modal" data-bs-target="#addClubModal">Add Club</button>
                        <button class="btn btn-outline-secondary" disabled>Edit Club Details</button>
                        <button class="btn btn-outline-danger" disabled>Remove Club</button>
                        <button class="btn btn-outline-info" data-bs-toggle="modal" data-bs-target="#eventModal">Add Club Event</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="requests" class="tab-content">
    <div class="container mt-3">
        <div class="bg-white rounded-3 shadow p-3">
            <h5 class="mb-3">Requests</h5>
            <table class="table table-sm align-middle">
                <thead><tr><th>#</th><th>Email</th><th>Type</th><th>Identification</th><th>Status</th><th>Created</th><th>Action</th></tr></thead>
                <tbody>
                <%
                   try (Connection c = DBConnection.getConnection();
                        PreparedStatement ps = c.prepareStatement("SELECT id, email, request_type, identification, status, created_at FROM support_requests ORDER BY created_at DESC")) {
                        ResultSet rs = ps.executeQuery(); boolean any=false; while(rs.next()){ any=true; %>
                    <tr>
                        <td><%= rs.getInt(1) %></td>
                        <td><%= rs.getString(2) %></td>
                        <td><%= rs.getString(3) %></td>
                        <td><%= rs.getString(4) %></td>
                        <td><span class="badge bg-<%= "Resolved".equalsIgnoreCase(rs.getString(5))?"success":"warning text-dark" %>"><%= rs.getString(5) %></span></td>
                        <td><%= rs.getString(6) %></td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary" type="button" data-request-toggle data-id="<%= rs.getInt(1) %>" data-next="<%= "Resolved".equalsIgnoreCase(rs.getString(5))?"Pending":"Resolved" %>">Mark <%= "Resolved".equalsIgnoreCase(rs.getString(5))?"Pending":"Resolved" %></button>
                        </td>
                    </tr>
                <% } if(!any){ %><tr><td colspan="7" class="text-muted">No requests found.</td></tr><% } } catch(Exception ignore){ %>
                    <tr><td colspan="7" class="text-muted">Unable to load requests.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div id="notices" class="tab-content">
    <div class="container mt-3">
        <div class="row g-3">
            <div class="col-lg-9">
                <div class="bg-white rounded-3 shadow p-3">
                    <h5 class="mb-3">Notices</h5>
                    <table class="table table-sm align-middle">
                        <thead><tr><th>Title</th><th>Posted</th><th>Linked To</th><th>Posted By</th></tr></thead>
                        <tbody>
                        <%
                          try (Connection c = DBConnection.getConnection();
                               PreparedStatement ps = c.prepareStatement("SELECT n.title, n.posted_at, n.notice_type, n.posted_by, c.course_name, cl.club_name FROM notices n LEFT JOIN courses c ON n.course_id=c.course_id LEFT JOIN clubs cl ON n.club_id=cl.club_id ORDER BY n.posted_at DESC")){
                               ResultSet rs=ps.executeQuery(); boolean any=false; while(rs.next()){ any=true; String linked = rs.getString(3); if("course".equalsIgnoreCase(linked)) linked = "Course: "+rs.getString(5); else if("club".equalsIgnoreCase(linked)) linked = "Club: "+rs.getString(6); else linked = "General"; %>
                          <tr>
                            <td><%= rs.getString(1) %></td>
                            <td><%= rs.getString(2) %></td>
                            <td><%= linked %></td>
                            <td><%= rs.getString(4) %></td>
                          </tr>
                        <% } if(!any){ %><tr><td colspan="4" class="text-muted">No notices found.</td></tr><% } } catch(Exception ignore){ %>
                          <tr><td colspan="4" class="text-muted">Unable to load notices.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="bg-white rounded-3 shadow p-3">
                    <h6>Actions</h6>
                    <div class="d-grid gap-2">
                        <button class="btn btn-outline-warning" data-bs-toggle="modal" data-bs-target="#noticeModal">Add Notice</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function showTab(id, btn) {
        const contents = document.getElementsByClassName('tab-content');
        for (let i = 0; i < contents.length; i++) { contents[i].classList.remove('active'); }
        document.getElementById(id).classList.add('active');

        const buttons = document.getElementsByClassName('tab-button');
        for (let i = 0; i < buttons.length; i++) { buttons[i].classList.remove('active'); }
        if (btn) { btn.classList.add('active'); }
    }

    document.addEventListener('DOMContentLoaded', function () {
        // Build weekly events feed from DB
        const events = [
            <% 
              try (Connection c = DBConnection.getConnection();
                   PreparedStatement ps = c.prepareStatement(
                    "SELECT e.event_id, e.title, e.event_date, e.event_time, e.type, e.related_to, c.course_name, cl.club_name " +
                    "FROM events e LEFT JOIN courses c ON e.course_id=c.course_id LEFT JOIN clubs cl ON e.club_id=cl.club_id " +
                    "WHERE e.event_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY) ORDER BY e.event_date, e.event_time")) {
                   ResultSet rs = ps.executeQuery(); boolean first=true; 
                   while (rs.next()) { 
                     String title = rs.getString(2);
                     String date = rs.getString(3);
                     String time = rs.getString(4);
                     String type = rs.getString(5);
                     String related = rs.getString(6);
                     String linked = ("course".equalsIgnoreCase(related)? rs.getString(7): ("club".equalsIgnoreCase(related)? rs.getString(8): "General"));
                     String display = title + " (" + type + ") - " + linked;
            %>
            { id: <%= rs.getInt(1) %>, title: "<%= display.replace("\"","\\\"") %>", start: "<%= date %>T<%= time %>" },
            <%   } } catch (Exception ignore) { } %>
        ];

        const calendarEl = document.getElementById('calendar');
        if (calendarEl) {
          const calendar = new FullCalendar.Calendar(calendarEl, {
              initialView: 'timeGridWeek',
              height: 'auto',
              headerToolbar: { left: 'prev,next today', center: 'title', right: 'timeGridWeek,dayGridMonth' },
              events
          });
          calendar.render();
        }

        // Activate tab from hash, e.g., #requests
        if (location.hash) {
          const target = location.hash.replace('#','');
          const button = Array.from(document.querySelectorAll('.tabs .tab-button'))
            .find(b => b.textContent.trim().toLowerCase() === target.toLowerCase());
          if (button) showTab(target, button);
        }
    });
</script>

<!-- Notice Modal -->
<div class="modal fade" id="noticeModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header"><h5 class="modal-title">Post New Notice</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <form method="post" action="<%= request.getContextPath() %>/AddNoticeServlet">
        <div class="modal-body">
          <div class="row g-3">
            <div class="col-12"><label class="form-label">Title</label><input name="title" type="text" class="form-control" required></div>
            <div class="col-12"><label class="form-label">Content</label><textarea name="content" class="form-control" rows="4" required></textarea></div>
            <div class="col-md-6">
              <label class="form-label">Notice Type</label>
              <select name="noticeType" id="noticeType" class="form-select" onchange="toggleNoticeLinks()" required>
                <option value="general">General</option>
                <option value="course">Course</option>
                <option value="club">Club</option>
              </select>
            </div>
            <div class="col-md-6" id="noticeCourseWrap" style="display:none;">
              <label class="form-label">Course</label>
              <select name="courseId" class="form-select">
                <option value="">Select course</option>
                <%
                  for (Map<String,Object> cRow : courseList) {
                %>
                  <option value="<%= cRow.get("id") %>"><%= cRow.get("name") %></option>
                <%
                  }
                %>
              </select>
            </div>
            <div class="col-md-6" id="noticeClubWrap" style="display:none;">
              <label class="form-label">Club</label>
              <select name="clubId" class="form-select">
                <option value="">Select club</option>
                <%
                  for (Map<String,Object> clRow : clubList) {
                %>
                  <option value="<%= clRow.get("id") %>"><%= clRow.get("name") %></option>
                <%
                  }
                %>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer"><button class="btn btn-primary" type="submit">Save</button><button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Cancel</button></div>
      </form>
    </div>
  </div>
</div>

<!-- Course Modal -->
<div class="modal fade" id="courseModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header"><h5 class="modal-title">Add New Course</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <form method="post" action="<%= request.getContextPath() %>/AddCourseServlet">
        <div class="modal-body">
          <div class="row g-3">
            <div class="col-md-6"><label class="form-label">Course Name</label><input name="course_name" type="text" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label">Course Code</label><input name="course_code" type="text" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label">Lecturer Name</label><input name="lecturer_name" type="text" class="form-control"></div>
            <div class="col-md-6"><label class="form-label">Credits</label><input name="credits" type="number" min="0" class="form-control"></div>
            <div class="col-12"><label class="form-label">Description</label><textarea name="description" class="form-control" rows="3"></textarea></div>
          </div>
        </div>
        <div class="modal-footer"><button class="btn btn-success" type="submit">Save</button><button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Cancel</button></div>
      </form>
    </div>
  </div>
</div>

<!-- Event Modal -->
<div class="modal fade" id="eventModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header"><h5 class="modal-title">Add Event</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <form method="post" action="<%= request.getContextPath() %>/AddEventServlet">
        <div class="modal-body">
          <div class="row g-3">
            <div class="col-md-6"><label class="form-label">Title</label><input name="title" type="text" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label">Location</label><input name="location" type="text" class="form-control"></div>
            <div class="col-md-6"><label class="form-label">Event Date</label><input name="event_date" type="date" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label">Event Time</label><input name="event_time" type="time" class="form-control" required></div>
            <div class="col-12"><label class="form-label">Description</label><textarea name="description" class="form-control" rows="3"></textarea></div>
            <div class="col-md-6">
              <label class="form-label">Event Type</label>
              <select name="event_type" id="eventType" class="form-select" onchange="toggleEventLinks()" required>
                <option value="general">General</option>
                <option value="course">Course</option>
                <option value="club">Club</option>
              </select>
            </div>
            <div class="col-md-6" id="eventCourseWrap" style="display:none;">
              <label class="form-label">Course</label>
              <select name="course_id" class="form-select">
                <option value="">Select course</option>
                <%
                  for (Map<String,Object> cRow : courseList) {
                %>
                  <option value="<%= cRow.get("id") %>"><%= cRow.get("name") %></option>
                <%
                  }
                %>
              </select>
            </div>
            <div class="col-md-6" id="eventClubWrap" style="display:none;">
              <label class="form-label">Club</label>
              <select name="club_id" class="form-select">
                <option value="">Select club</option>
                <%
                  for (Map<String,Object> clRow : clubList) {
                %>
                  <option value="<%= clRow.get("id") %>"><%= clRow.get("name") %></option>
                <%
                  }
                %>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer"><button class="btn btn-info" type="submit">Save</button><button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Cancel</button></div>
      </form>
    </div>
  </div>
</div>

<!-- Edit Course Modal -->
<div class="modal fade" id="editCourseModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header"><h5 class="modal-title">Edit Course</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <form method="post" action="<%= request.getContextPath() %>/EditCourseServlet">
        <input type="hidden" name="course_id" id="editCourseId">
        <div class="modal-body">
          <div class="row g-3">
            <div class="col-md-6"><label class="form-label">Course Code</label><input name="course_code" id="editCourseCode" type="text" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label">Course Name</label><input name="course_name" id="editCourseName" type="text" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label">Lecturer Name</label><input name="lecturer_name" id="editCourseLecturer" type="text" class="form-control"></div>
          </div>
        </div>
        <div class="modal-footer"><button class="btn btn-primary" type="submit">Save Changes</button><button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Cancel</button></div>
      </form>
    </div>
  </div>
</div>

<!-- Add Club Modal -->
<div class="modal fade" id="addClubModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header"><h5 class="modal-title">Add Club</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <form method="post" action="<%= request.getContextPath() %>/AddClubServlet">
        <div class="modal-body">
          <div class="row g-3">
            <div class="col-md-6"><label class="form-label">Club Name</label><input name="club_name" type="text" class="form-control" required></div>
            <div class="col-12"><label class="form-label">Description</label><textarea name="description" class="form-control" rows="3"></textarea></div>
          </div>
        </div>
        <div class="modal-footer"><button class="btn btn-success" type="submit">Save</button><button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Cancel</button></div>
      </form>
    </div>
  </div>
</div>

<!-- Edit Club Modal -->
<div class="modal fade" id="editClubModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header"><h5 class="modal-title">Edit Club</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <form method="post" action="<%= request.getContextPath() %>/EditClubServlet">
        <input type="hidden" name="club_id" id="editClubId">
        <div class="modal-body">
          <div class="row g-3">
            <div class="col-md-6"><label class="form-label">Club Name</label><input name="club_name" id="editClubName" type="text" class="form-control" required></div>
            <div class="col-12"><label class="form-label">Description</label><textarea name="description" id="editClubDesc" class="form-control" rows="3"></textarea></div>
          </div>
        </div>
        <div class="modal-footer"><button class="btn btn-primary" type="submit">Save Changes</button><button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Cancel</button></div>
      </form>
    </div>
  </div>
</div>
<!-- Add Student Modal -->
<div class="modal fade" id="addStudentModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header"><h5 class="modal-title">Add New Student</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <form method="post" action="<%= request.getContextPath() %>/AddStudentServlet">
        <div class="modal-body">
          <div class="row g-3">
            <div class="col-md-4"><label class="form-label">Student Number</label><input name="studentNumber" type="text" class="form-control" required></div>
            <div class="col-md-4"><label class="form-label">First Name</label><input name="firstName" type="text" class="form-control" required></div>
            <div class="col-md-4"><label class="form-label">Last Name</label><input name="lastName" type="text" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label">Email</label><input name="email" type="email" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label">Phone</label><input name="phone" type="text" class="form-control"></div>
            <div class="col-md-6"><label class="form-label">Course</label>
              <select name="courseId" class="form-select">
                <option value="">-- None --</option>
                <%
                  for (Map<String,Object> cRow : courseList) {
                %>
                  <option value="<%= cRow.get("id") %>"><%= cRow.get("name") %></option>
                <%
                  }
                %>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer"><button class="btn btn-primary" type="submit">Save</button><button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Cancel</button></div>
      </form>
    </div>
  </div>
</div>

<!-- Edit Student Modal -->
<div class="modal fade" id="editStudentModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header"><h5 class="modal-title">Edit Student</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <form method="post" action="<%= request.getContextPath() %>/EditStudentServlet">
        <input type="hidden" name="userId">
        <div class="modal-body">
          <div class="row g-3">
            <div class="col-md-4"><label class="form-label">Student Number</label><input name="studentNumber" type="text" class="form-control" required></div>
            <div class="col-md-4"><label class="form-label">First Name</label><input name="firstName" type="text" class="form-control" required></div>
            <div class="col-md-4"><label class="form-label">Last Name</label><input name="lastName" type="text" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label">Email</label><input name="email" type="email" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label">Phone</label><input name="phone" type="text" class="form-control"></div>
            <div class="col-md-6"><label class="form-label">Course</label>
              <select name="courseId" class="form-select">
                <option value="">-- None --</option>
                <%
                  for (Map<String,Object> cRow : courseList) {
                %>
                  <option value="<%= cRow.get("id") %>"><%= cRow.get("name") %></option>
                <%
                  }
                %>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer"><button class="btn btn-primary" type="submit">Save Changes</button><button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Cancel</button></div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function toggleNoticeLinks(){
    const type = document.getElementById('noticeType').value;
    document.getElementById('noticeCourseWrap').style.display = (type==='course')?'block':'none';
    document.getElementById('noticeClubWrap').style.display = (type==='club')?'block':'none';
  }
  function toggleEventLinks(){
    const type = document.getElementById('eventType').value;
    document.getElementById('eventCourseWrap').style.display = (type==='course')?'block':'none';
    document.getElementById('eventClubWrap').style.display = (type==='club')?'block':'none';
  }

  function openEditCourse(id, code, name, lecturer){
    document.getElementById('editCourseId').value = id;
    document.getElementById('editCourseCode').value = code || '';
    document.getElementById('editCourseName').value = name || '';
    document.getElementById('editCourseLecturer').value = lecturer || '';
    new bootstrap.Modal(document.getElementById('editCourseModal')).show();
  }

  function openEditClub(id, name, desc){
    document.getElementById('editClubId').value = id;
    document.getElementById('editClubName').value = name || '';
    document.getElementById('editClubDesc').value = desc || '';
    new bootstrap.Modal(document.getElementById('editClubModal')).show();
  }

  // Populate Edit Student modal from table data
  function openEditStudent(btn){
    const m = document.getElementById('editStudentModal');
    m.querySelector('input[name="userId"]').value = btn.dataset.userId;
    m.querySelector('input[name="studentNumber"]').value = btn.dataset.studentNumber || '';
    m.querySelector('input[name="firstName"]').value = btn.dataset.firstName || '';
    m.querySelector('input[name="lastName"]').value = btn.dataset.lastName || '';
    m.querySelector('input[name="email"]').value = btn.dataset.email || '';
    m.querySelector('input[name="phone"]').value = btn.dataset.phone || '';
    const cid = btn.dataset.courseId || '';
    const select = m.querySelector('select[name="courseId"]');
    if (select) select.value = cid;
    const modal = new bootstrap.Modal(m);
    modal.show();
  }

  // AJAX update for request status without reload
  document.addEventListener('click', function(e){
    const t = e.target;
    if (t.matches('[data-request-toggle]')){
      const id = t.getAttribute('data-id');
      const next = t.getAttribute('data-next');
      fetch('<%= request.getContextPath() %>/UpdateRequestStatusServlet', {
        method: 'POST', headers: {'Content-Type':'application/x-www-form-urlencoded'},
        body: 'id='+encodeURIComponent(id)+'&status='+encodeURIComponent(next)
      }).then(()=>{
        const row = t.closest('tr');
        const badge = row.querySelector('td:nth-child(5) span');
        const isResolved = next === 'Resolved';
        badge.className = 'badge ' + (isResolved ? 'bg-success' : 'bg-warning text-dark');
        badge.textContent = next;
        t.textContent = 'Mark ' + (isResolved ? 'Pending' : 'Resolved');
        t.setAttribute('data-next', isResolved ? 'Pending' : 'Resolved');
      });
    }
  });
</script>

</body>
</html>




