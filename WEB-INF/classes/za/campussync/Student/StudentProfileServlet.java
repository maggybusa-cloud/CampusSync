import java.io.IOException;
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
HttpSession session = request.getSession(false);


if (session == null || session.getAttribute("username") == null) {
response.sendRedirect("login.jsp");
return;
}


String username = (String) session.getAttribute("username");


try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/CampusSync", "root", "password")) {


// Get personal info
PreparedStatement userStmt = conn.prepareStatement("SELECT * FROM users WHERE email = ?");
userStmt.setString(1, username);
ResultSet userRs = userStmt.executeQuery();
if (userRs.next()) {
request.setAttribute("studentNumber", userRs.getInt("user_id"));
request.setAttribute("programme", "BSc in IT"); // Hardcoded for now
request.setAttribute("year", "2nd Year"); // Same here
request.setAttribute("campus", "Richfield - Benoni");
}


// Get courses
PreparedStatement courseStmt = conn.prepareStatement(
"SELECT c.course_code, c.course_name, c.lecturer_name FROM courses c " +
"JOIN student_courses sc ON c.course_id = sc.course_id " +
"JOIN users u ON sc.user_id = u.user_id WHERE u.email = ?");
courseStmt.setString(1, username);
ResultSet courseRs = courseStmt.executeQuery();
List<Map<String, String>> courses = new ArrayList<>();
while (courseRs.next()) {
Map<String, String> course = new HashMap<>();
course.put("code", courseRs.getString("course_code"));
course.put("name", courseRs.getString("course_name"));
course.put("lecturer", courseRs.getString("lecturer_name"));
courses.add(course);
}
request.setAttribute("courses", courses);


// Get clubs
PreparedStatement clubStmt = conn.prepareStatement(
"SELECT c.club_name FROM clubs c " +
"JOIN student_clubs sc ON c.club_id = sc.club_id " +
"JOIN users u ON sc.user_id = u.user_id WHERE u.email = ?");
clubStmt.setString(1, username);
ResultSet clubRs = clubStmt.executeQuery();
List<String> clubs = new ArrayList<>();
while (clubRs.next()) {
clubs.add(clubRs.getString("club_name"));
}
request.setAttribute("clubs", clubs);


request.getRequestDispatcher("studentProfile.jsp").forward(request, response);
} catch (SQLException e) {
e.printStackTrace();
response.sendRedirect("error.jsp");
}
}
}