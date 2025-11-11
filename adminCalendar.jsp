<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="za.campussync.db.DBConnection,java.sql.*,java.util.*" %>
<%
    // Resolve admin identity and initials for header
    String sessionEmail = null;
    if (session != null) {
        Object em = session.getAttribute("email");
        sessionEmail = (em != null) ? em.toString() : (String) session.getAttribute("username");
    }
    String firstName = "Admin";
    String lastName = "";
    String email = (sessionEmail != null) ? sessionEmail : "";
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT first_name, last_name FROM users WHERE email = ? LIMIT 1")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) { if (rs.getString(1)!=null) firstName = rs.getString(1); if (rs.getString(2)!=null) lastName = rs.getString(2); }
            }
        }
    } catch (Exception ignore) {}
    String initials = (firstName!=null && firstName.length()>0? firstName.substring(0,1):"A") + (lastName!=null && lastName.length()>0? lastName.substring(0,1):"");

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
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>
    <style>
        body { font-family: 'Poppins', Arial, sans-serif; background: #f4f7fc; }
        .navbar-custom { background: linear-gradient(90deg, #1d4ed8, #3b82f6); }
        .navbar-custom .navbar-brand, .navbar-custom .dropdown-toggle { color: #fff; font-weight: 500; }
        #calendarWrap { max-width: 1100px; margin: 20px auto; }
        #calendar { background: #fff; border-radius: 12px; box-shadow: 0 6px 20px rgba(0,0,0,0.08); padding: 14px; }
        .toolbar { max-width: 1100px; margin: 20px auto 0; display:flex; justify-content:flex-end; gap:10px; }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const events = [
                <% try (Connection c = DBConnection.getConnection();
                       PreparedStatement ps = c.prepareStatement(
                        "SELECT e.event_id, e.title, e.event_date, e.event_time, e.type, e.related_to, c.course_name, cl.club_name, e.location, e.description, e.course_id, e.club_id " +
                        "FROM events e LEFT JOIN courses c ON e.course_id=c.course_id LEFT JOIN clubs cl ON e.club_id=cl.club_id ")) {
                       ResultSet rs = ps.executeQuery();
                       while (rs.next()) {
                         String title = rs.getString(2);
                         String date = rs.getString(3);
                         String time = rs.getString(4);
                         String type = rs.getString(5);
                         String related = rs.getString(6);
                         String linked = ("course".equalsIgnoreCase(related)? rs.getString(7): ("club".equalsIgnoreCase(related)? rs.getString(8): "General"));
                         String location = rs.getString(9);
                         String descr = rs.getString(10);
                         Integer courseId = (Integer)rs.getObject(11);
                         Integer clubId = (Integer)rs.getObject(12);
                         String display = title + " (" + type + ") - " + linked;
                %>
                { id: <%= rs.getInt(1) %>, title: "<%= display.replace("\"","\\\"") %>", start: "<%= date %>T<%= time %>", extendedProps: { rawTitle: "<%= title.replace("\"","\\\"") %>", type: "<%= type %>", related: "<%= related %>", linked: "<%= (linked==null?"":linked).replace("\"","\\\"") %>", location: "<%= location==null?"":location.replace("\"","\\\"") %>", description: "<%= descr==null?"":descr.replace("\"","\\\"") %>", courseId: <%= courseId==null?"null":courseId.toString() %>, clubId: <%= clubId==null?"null":clubId.toString() %> } },
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
                events,
                eventClick: function(info) {
                    window.selectedEvent = info.event; // keep globally for Modify button
                    const e = info.event;
                    const p = e.extendedProps || {};
                    document.getElementById('detailTitle').textContent = p.rawTitle || e.title;
                    document.getElementById('detailType').textContent = p.type || '';
                    document.getElementById('detailLinked').textContent = p.linked || '';
                    document.getElementById('detailDate').textContent = e.start ? e.start.toISOString().substring(0,10) : '';
                    document.getElementById('detailTime').textContent = e.start ? e.start.toTimeString().substring(0,5) : '';
                    document.getElementById('detailLocation').textContent = p.location || '';
                    document.getElementById('detailDescription').textContent = p.description || '';
                    document.getElementById('detailEventId').value = e.id;
                    new bootstrap.Modal(document.getElementById('eventDetailsModal')).show();
                }
            });
            calendar.render();
            // Modify button outside modal
            const modifyBtn = document.getElementById('btnModifyEvent');
            if (modifyBtn) {
              modifyBtn.addEventListener('click', function(){
                if (!window.selectedEvent) return;
                const e = window.selectedEvent, p = e.extendedProps || {};
                document.getElementById('editEventId').value = e.id;
                document.getElementById('editEventTitle').value = p.rawTitle || e.title;
                document.getElementById('editEventLocation').value = p.location || '';
                document.getElementById('editEventDate').value = e.start ? e.start.toISOString().substring(0,10) : '';
                document.getElementById('editEventTime').value = e.start ? e.start.toTimeString().substring(0,5) : '';
                document.getElementById('editEventDescription').value = p.description || '';
                document.getElementById('editEventType').value = (p.related||'general');
                toggleEditLinks();
                document.getElementById('editCourseId').value = p.courseId || '';
                document.getElementById('editClubId').value = p.clubId || '';
                new bootstrap.Modal(document.getElementById('editEventModal')).show();
              });
            }
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
        <div class="dropdown">
            <a class="text-white text-decoration-none" href="#" data-bs-toggle="dropdown">
                <span class="rounded-circle bg-white text-primary fw-bold d-inline-flex justify-content-center align-items-center"
                      style="width: 40px; height: 40px; line-height:40px;">
                    <%= initials.toUpperCase() %>
                </span>
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="adminProfile.jsp">Profile</a></li>
                <li><a class="dropdown-item text-danger" href="logout.jsp">Logout</a></li>
            </ul>
        </div>
    </div>
  </nav>

<div class="toolbar">
    <a class="btn btn-outline-primary" href="adminDashboard.jsp">Back to Dashboard</a>
    <button class="btn btn-outline-warning" data-bs-toggle="modal" data-bs-target="#eventModal">Add Event</button>
    <button id="btnModifyEvent" class="btn btn-outline-secondary">Modify Event</button>
</div>

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

<!-- Event Details Modal -->
<div class="modal fade" id="eventDetailsModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header"><h5 class="modal-title">Event Details</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <div class="modal-body">
        <div class="row g-3">
          <div class="col-md-6"><strong>Title:</strong> <span id="detailTitle"></span></div>
          <div class="col-md-6"><strong>Type:</strong> <span id="detailType"></span></div>
          <div class="col-md-6"><strong>Linked To:</strong> <span id="detailLinked"></span></div>
          <div class="col-md-6"><strong>Date:</strong> <span id="detailDate"></span> <strong>Time:</strong> <span id="detailTime"></span></div>
          <div class="col-md-6"><strong>Location:</strong> <span id="detailLocation"></span></div>
          <div class="col-12"><strong>Description:</strong><div id="detailDescription"></div></div>
        </div>
      </div>
      <div class="modal-footer">
        <form method="post" action="<%= request.getContextPath() %>/RemoveEventServlet" onsubmit="return confirm('Delete this event?');">
          <input type="hidden" name="event_id" id="detailEventId">
          <button class="btn btn-outline-danger" type="submit">Remove Event</button>
        </form>
        <button class="btn btn-primary" type="button" onclick="document.getElementById('btnModifyEvent').click()">Edit Event</button>
      </div>
    </div>
  </div>
 </div>

<!-- Edit Event Modal -->
<div class="modal fade" id="editEventModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header"><h5 class="modal-title">Edit Event</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <form method="post" action="<%= request.getContextPath() %>/EditEventServlet">
        <input type="hidden" name="event_id" id="editEventId">
        <div class="modal-body">
          <div class="row g-3">
            <div class="col-md-6"><label class="form-label">Title</label><input id="editEventTitle" name="title" type="text" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label">Location</label><input id="editEventLocation" name="location" type="text" class="form-control"></div>
            <div class="col-md-6"><label class="form-label">Event Date</label><input id="editEventDate" name="event_date" type="date" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label">Event Time</label><input id="editEventTime" name="event_time" type="time" class="form-control" required></div>
            <div class="col-12"><label class="form-label">Description</label><textarea id="editEventDescription" name="description" class="form-control" rows="3"></textarea></div>
            <div class="col-md-6">
              <label class="form-label">Event Type</label>
              <select name="event_type" id="editEventType" class="form-select" onchange="toggleEditLinks()" required>
                <option value="general">General</option>
                <option value="course">Course</option>
                <option value="club">Club</option>
              </select>
            </div>
            <div class="col-md-6" id="editEventCourseWrap" style="display:none;">
              <label class="form-label">Course</label>
              <select name="course_id" id="editCourseId" class="form-select">
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
            <div class="col-md-6" id="editEventClubWrap" style="display:none;">
              <label class="form-label">Club</label>
              <select name="club_id" id="editClubId" class="form-select">
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
        <div class="modal-footer"><button class="btn btn-primary" type="submit">Save Changes</button><button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Cancel</button></div>
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
  function toggleEditLinks(){
    const type = document.getElementById('editEventType').value;
    document.getElementById('editEventCourseWrap').style.display = (type==='course')?'block':'none';
    document.getElementById('editEventClubWrap').style.display = (type==='club')?'block':'none';
  }
</script>
</body>
</html>
