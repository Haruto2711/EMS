package com.ems.controller;

import com.ems.dao.NotificationDAO;
import com.ems.model.Notifications;
import com.ems.service.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/notification"})
public class NotificationServlet extends HttpServlet {

    private NotificationService notificationService;

    @Override
    public void init() {
        notificationService = new NotificationService();
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("accountId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String keyword = request.getParameter("search");
        if (keyword == null) keyword = "";
        else keyword = keyword.trim();

        String sort = request.getParameter("sort");
        if (!"DESC".equals(sort)) sort = "ASC"; // mặc định A→Z

        int pageSize = 5;
        try {
            int ps = Integer.parseInt(request.getParameter("pageSize"));
            if (ps == 10 || ps == 20) pageSize = ps;
        } catch (NumberFormatException ignored) {
        }

        int page = 1;
        try {
            page = Math.max(1, Integer.parseInt(request.getParameter("page")));
        } catch (NumberFormatException ignored) {
        }
        int totalRecords = notificationService.countNotifications(userId, keyword);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalRecords / pageSize));
        if (page > totalPages) page = totalPages;

        List<Notifications> notifications = notificationService.searchNotification(userId, keyword, sort, page, pageSize);

        request.setAttribute("notifications", notifications);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sort", sort);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.getRequestDispatcher("/notification.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("accountId");

        response.setContentType("application/json;charset=UTF-8");

        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"success\":false,\"message\":\"Chưa đăng nhập\"}");
            }
            return;
        }

        String action = request.getParameter("action");
        if (!"markAsRead".equals(action)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"success\":false,\"message\":\"Action không hợp lệ\"}");
            }
            return;
        }

        Integer notificationId = null;
        try {
            notificationId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"success\":false,\"message\":\"id không hợp lệ\"}");
            }
            return;
        }

        boolean updated = notificationService.markAsRead(notificationId, userId);
        try (PrintWriter out = response.getWriter()) {
            out.write("{\"success\":" + updated + "}");
        }
    }

}
