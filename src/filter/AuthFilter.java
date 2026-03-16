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

        if (uri.contains("/auth/login") ||
            uri.contains("/views") ||
            uri.contains("/css") ||
            uri.contains("/js") ||
            uri.contains("/images")) {

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