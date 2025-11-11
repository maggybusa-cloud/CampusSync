import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;


@WebServlet("/AdminProfileServlet")
public class AdminProfileServlet extends HttpServlet {
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("username") == null) {
response.sendRedirect("login.jsp");
return;
}


// You can add additional admin info fetching logic here if needed
request.getRequestDispatcher("adminProfile.jsp").forward(request, response);
}
}