<%@ page import="java.sql.*, java.util.*, org.json.*" %>
<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    JSONArray events = new JSONArray();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/campussync", "root", "Nn2025!#MySQL");

        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT id, title, start, end FROM calendar_events");

        while (rs.next()) {
            JSONObject event = new JSONObject();
            event.put("id", rs.getInt("id"));
            event.put("title", rs.getString("title"));
            event.put("start", rs.getString("start"));
            event.put("end", rs.getString("end"));
            events.put(event);
        }

        response.setContentType("application/json");
        response.getWriter().print(events.toString());

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
