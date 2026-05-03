package com.edustand.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;

import java.io.IOException;

import com.edustand.model.UserModel;
import com.edustand.service.RememberMeService;
import com.edustand.util.CookieUtil;

/**
 * Servlet Filter implementation class filter
 */
@WebFilter("/*")
public class filter extends HttpFilter {

	/**
	 * @see HttpFilter#HttpFilter()
	 */
	public filter() {
		super();
	}

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		String contextPath = httpRequest.getContextPath();
		String uri = httpRequest.getRequestURI();
		String path = uri.substring(contextPath.length());
		HttpSession session = httpRequest.getSession(false);
		UserModel loggedInUser = session == null ? null : (UserModel) session.getAttribute("loggedInUser");

		// If user is not in session, try to restore from Remember Me token
		if (loggedInUser == null && !isPublicPath(path)) {
			Cookie rememberMeCookie = CookieUtil.getCookie(httpRequest, "rememberMeToken");
			if (rememberMeCookie != null && rememberMeCookie.getValue() != null
					&& !rememberMeCookie.getValue().isBlank()) {
				RememberMeService rmService = new RememberMeService();
				UserModel restoredUser = rmService.validateToken(rememberMeCookie.getValue());
				if (restoredUser != null) {
					System.out.println("[DEBUG] Auto-restored user from Remember Me token: " + restoredUser.getEmail());
					loggedInUser = restoredUser;
					// Restore session
					session = httpRequest.getSession();
					session.setAttribute("loggedInUser", restoredUser);
					session.setAttribute("userRole", restoredUser.getRole());
				}
			}
		}

		if ("/login".equals(path) && loggedInUser != null) {
			httpResponse.sendRedirect(contextPath + resolveDashboardByRole(loggedInUser.getRole()));
			return;
		}

		if (isPublicPath(path)) {
			chain.doFilter(request, response);
			return;
		}

		if (loggedInUser == null) {
			httpResponse.sendRedirect(contextPath + "/login");
			return;
		}

		if (!isRoleAuthorizedForPath(loggedInUser.getRole(), path)) {
			httpResponse.sendRedirect(contextPath + resolveDashboardByRole(loggedInUser.getRole()));
			return;
		}

		chain.doFilter(request, response);
	}

	private boolean isPublicPath(String path) {
		if (path == null || path.isBlank()) {
			return true;
		}

		return path.startsWith("/css/")
				|| path.startsWith("/js/")
				|| path.startsWith("/images/")
				|| path.startsWith("/favicon")
				|| path.equals("/")
				|| path.equals("/login")
				|| path.equals("/forgot-password")
				|| path.equals("/request-access")
				|| path.equals("/logout");
	}

	private boolean isRoleAuthorizedForPath(String role, String path) {
		if (path.startsWith("/Admin")) {
			return "ADMIN".equalsIgnoreCase(role);
		}

		if (path.startsWith("/Teacher")) {
			return "TEACHER".equalsIgnoreCase(role);
		}

		if (path.startsWith("/Student")) {
			return "STUDENT".equalsIgnoreCase(role);
		}

		return true;
	}

	private String resolveDashboardByRole(String role) {
		if ("ADMIN".equalsIgnoreCase(role)) {
			return "/AdminDashboard";
		}
		if ("TEACHER".equalsIgnoreCase(role)) {
			return "/TeacherDashboard";
		}
		return "/StudentDashboard";
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
	}

}
