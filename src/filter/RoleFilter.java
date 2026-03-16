// user login nhưng không đúng role → chặn
package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;

public class RoleFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        String uri = req.getRequestURI();

        if (uri.contains("/admin") && !"ADMIN".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        if (uri.contains("/manager") && !"MANAGER".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        if (uri.contains("/doctor") && !"DOCTOR".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        if (uri.contains("/patient") && !"PATIENT".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        chain.doFilter(request, response);
    }
}