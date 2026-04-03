// Nếu chưa login → không cho vào hệ thống
package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;

public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI();

        if (uri.contains("/auth/") ||
            uri.contains("/static/") ||
            uri.contains("/common/find-doctor") ||
            uri.contains("/views") ||
            uri.endsWith("home") ||
            uri.equals(req.getContextPath() + "/")) {

            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {

            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        chain.doFilter(request, response);
    }
}