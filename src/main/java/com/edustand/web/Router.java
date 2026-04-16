package com.edustand.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation class Router
 * 
 * @author naitik joshi
 */
@WebServlet(urlPatterns = { "/login", "/AdminDashboard", "/TeacherDashboard", "/StudentDashboard", "/", "/Router",
		"/forgot-password", "/request-access" })
public class Router extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Router() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getServletPath();
		String target = null;
		switch (path) {
			case "/login":
				target = "/WEB-INF/pages/login.jsp";
				break;
			case "/AdminDashboard":
				target = "/WEB-INF/pages/AdminDashboard.jsp";
				break;
			case "/TeacherDashboard":
				target = "/WEB-INF/pages/TeacherDashboard.jsp";
				break;
			case "/StudentDashboard":
				target = "/WEB-INF/pages/StudentDashboard.jsp";
				break;
			case "/forgot-password":
				target = "/WEB-INF/pages/forgot-password.jsp";
				break;
			case "/request-access":
				target = "/WEB-INF/pages/request-access.jsp";
				break;
			case "/":
				target = "/WEB-INF/pages/login.jsp";
				break;
			default:
				response.sendError(HttpServletResponse.SC_NOT_FOUND);
				return;
		}

		request.getRequestDispatcher(target).forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getServletPath();
		if ("/login".equals(path)) {
			// Placeholder authentication: replace with real auth logic
			String username = request.getParameter("username");
			if (username != null && !username.isEmpty()) {
				response.sendRedirect(request.getContextPath() + "/StudentDashboard");
				return;
			}
			// if no credentials, redisplay login
			request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
			return;
		}
		doGet(request, response);
	}

}
