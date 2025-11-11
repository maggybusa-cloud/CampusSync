<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="za.campussync.db.DBConnection,java.sql.*,java.util.*" %>
<%
    String adminName = (session != null && session.getAttribute("username") != null)
        ? (String) session.getAttribute("username") : "Admin";

    // Load course/club lists for the Add Event modal
    List<Map<String,Object>> courseList = new ArrayList<>();
    List<Map<String,Object>> clubList = new ArrayList<>();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection c = DBConnection.getConnection()) {
            try (PreparedStatement ps = c.prepareStatement("SELECT course_id, course_name FROM courses ORDER BY course_name")) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,Object> m = new HashMap<>();
                    m.put("id", rs.getObject(1));
                    m.put("name", rs.getString(2));
                    courseList.add(m);
                }
            }
            try (PreparedStatement ps = c.prepareStatement("SELECT club_id, club_name FROM clubs ORDER BY club_name")) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,Object> m = new HashMap<>();
                    m.put("id", rs.getObject(1));
                    m.put("name", rs.getString(2));
                    clubList.add(m);
                }
            }
        }
    } catch (Exception ignore) {}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CampusSync | Admin Calendar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.js"></script>
    <style>
        body { font-family: 'Poppins', Arial, sans-serif; background: #f4f7fc; }
        .navbar-custom { background: linear-gradient(90deg, #1d4ed8, #3b82f6); }
        .navbar-custom .navbar-brand, .navbar-custom .dropdown-toggle { color: #fff; font-weight: 500; }
        #calendarWrap { max-width: 1100px; margin: 20px auto; }
        #calendar { background: #fff; border-radius: 12px; box-shadow: 0 6px 20px rgba(0,0,0,0.08); padding: 14px; }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const events = [
                <% try (Connection c = DBConnection.getConnection();
                       PreparedStatement ps = c.prepareStatement(
                        "SELECT e.event_id, e.title, e.event_date, e.event_time, e.type, e.related_to, c.course_name, cl.club_name " +
                        "FROM events e LEFT JOIN courses c ON e.course_id=c.course_id LEFT JOIN clubs cl ON e.club_id=cl.club_id ")) {
                       ResultSet rs = ps.executeQuery();
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
                <% } } catch (Exception ignore) {} %>
            ];

            const calendarEl = document.getElementById('calendar');
            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'timeGridWeek',
                height: 'auto',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },
                events
            });
            calendar.render();
        });
    </script>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark px-4 navbar-custom">
    <div class="container-fluid d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center">
            <img src="images/campus-sync-logo.png" alt="CampusSync Logo" style="height: 40px; margin-right: 10px;">
            <h4 class="mb-0 fw-bold text-white">CampusSync</h4>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-light btn-sm" href="adminDashboard.jsp">Back to Dashboard</a>
            <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#eventModal">Add Event</button>
        </div>
    </div>
  </nav>

<div id="calendarWrap" class="container">
    <div id="calendar"></div>
  </div>

<!-- Event Modal (same as dashboard) -->
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function toggleEventLinks(){
    const type = document.getElementById('eventType').value;
    document.getElementById('eventCourseWrap').style.display = (type==='course')?'block':'none';
    document.getElementById('eventClubWrap').style.display = (type==='club')?'block':'none';
  }
</script>
</body>
</html>

