package com.ems.controller;

import com.ems.dao.RequestDAO;
import com.ems.dto.RequestDTO;
import com.ems.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;

@WebServlet("/requests")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class RequestController extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        try (Connection connection = DBConnection.getConnection()) {

            RequestDAO dao = new RequestDAO(connection);

            switch (action) {

                case "list":
                    list(request, response, dao);
                    break;

                case "detail":
                    detail(request, response, dao);
                    break;

                case "myRequests":
                    myRequests(request, response, dao);
                    break;

                case "pending":
                    pending(request, response, dao);
                    break;

                case "create":
                    request.getRequestDispatcher(
                            "/WEB-INF/views/request/create.jsp"
                    ).forward(request, response);
                    break;

                default:
                    response.sendError(
                            HttpServletResponse.SC_NOT_FOUND
                    );
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try (Connection connection = DBConnection.getConnection()) {

            RequestDAO dao = new RequestDAO(connection);

            switch (action) {

                case "insert":
                    insert(request, response, dao);
                    break;

                case "approve":
                    updateStatus(
                            request,
                            response,
                            dao,
                            "Approved"
                    );
                    break;

                case "reject":
                    updateStatus(
                            request,
                            response,
                            dao,
                            "Rejected"
                    );
                    break;

                case "delete":
                    delete(request, response, dao);
                    break;

                default:
                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST
                    );
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void list(
            HttpServletRequest request,
            HttpServletResponse response,
            RequestDAO dao
    ) throws Exception {

        List<RequestDTO> list = dao.getAll();

        request.setAttribute("requests", list);

        request.getRequestDispatcher(
                "/WEB-INF/views/request/list.jsp"
        ).forward(request, response);
    }

    private void detail(
            HttpServletRequest request,
            HttpServletResponse response,
            RequestDAO dao
    ) throws Exception {

        int id = Integer.parseInt(
                request.getParameter("id")
        );

        RequestDTO requestDTO = dao.getById(id);

        if (requestDTO == null) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND
            );
            return;
        }

        request.setAttribute("request", requestDTO);

        request.getRequestDispatcher(
                "/WEB-INF/views/request/detail.jsp"
        ).forward(request, response);
    }

    private void myRequests(
            HttpServletRequest request,
            HttpServletResponse response,
            RequestDAO dao
    ) throws Exception {

        HttpSession session = request.getSession();

        Integer accountId =
                (Integer) session.getAttribute("accountId");

        if (accountId == null) {
            response.sendRedirect("login");
            return;
        }

        List<RequestDTO> list =
                dao.getByCreatedByAccountId(accountId);

        // Pagination handling
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {}
        }
        if (page < 1) page = 1;

        int pageSize = 5;
        String pageSizeParam = request.getParameter("pageSize");
        if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeParam);
            } catch (NumberFormatException ignored) {}
        }
        if (pageSize < 1) pageSize = 5;

        int totalFilteredItems = list.size();
        int totalPages = (int) Math.ceil((double) totalFilteredItems / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalFilteredItems);

        List<RequestDTO> pagedRequests = (fromIndex < totalFilteredItems)
                ? list.subList(fromIndex, toIndex)
                : java.util.Collections.emptyList();

        request.setAttribute("requests", pagedRequests);
        request.setAttribute("totalFilteredItems", totalFilteredItems);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher(
                "/requestList.jsp"
        ).forward(request, response);
    }

    private void pending(
            HttpServletRequest request,
            HttpServletResponse response,
            RequestDAO dao
    ) throws Exception {

        HttpSession session = request.getSession();

        Integer accountId =
                (Integer) session.getAttribute("accountId");

        if (accountId == null) {
            response.sendRedirect("login");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (role == null || !"manager".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        List<RequestDTO> list =
                dao.getPendingRequests(accountId);

        request.setAttribute("requests", list);

        request.getRequestDispatcher(
                "/request-manager.jsp"
        ).forward(request, response);
    }

    private void insert(
            HttpServletRequest request,
            HttpServletResponse response,
            RequestDAO dao
    ) throws Exception {

        HttpSession session = request.getSession();

        Integer accountId =
                (Integer) session.getAttribute("accountId");

        if (accountId == null) {
            response.sendRedirect("login");
            return;
        }

        String title =
                request.getParameter("title");

        String reason =
                request.getParameter("reason");

        String startDate =
                request.getParameter("startDate");

        String endDate =
                request.getParameter("endDate");

        int requestTypeId =
                Integer.parseInt(
                        request.getParameter("requestTypeId")
                );

        String imageUrl = null;
        String contentType = request.getContentType();
        if (contentType != null && contentType.toLowerCase().startsWith("multipart/")) {
            imageUrl = saveUploadedImage(request);
        }

        RequestDTO dto = new RequestDTO();

        dto.setTitle(title);
        dto.setReason(reason);

        dto.setStartDate(
                Timestamp.valueOf(
                        startDate.replace("T", " ") + ":00"
                )
        );

        dto.setEndDate(
                Timestamp.valueOf(
                        endDate.replace("T", " ") + ":00"
                )
        );

        String value = request.getParameter("value");
        dto.setValue(value == null || value.isBlank() ? 1 : Double.parseDouble(value));
        dto.setImageUrl(imageUrl);

        dto.setRequestTypeId(requestTypeId);

        dto.setCreatedByAccountId(accountId);

        dto.setStatus("Pending");

        dao.insert(dto);

        response.sendRedirect(
                request.getContextPath()
                        + "/requests?action=myRequests"
        );
    }

    private String saveUploadedImage(HttpServletRequest request)
            throws IOException, ServletException {

        Part imagePart = request.getPart("image");
        if (imagePart == null || imagePart.getSize() == 0) {
            return null;
        }

        String contentType = imagePart.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new ServletException("Tệp minh chứng phải là ảnh.");
        }

        String submittedFileName = Path.of(imagePart.getSubmittedFileName()).getFileName().toString();
        String extension = "";
        int extensionIndex = submittedFileName.lastIndexOf('.');
        if (extensionIndex >= 0) {
            extension = submittedFileName.substring(extensionIndex).toLowerCase();
        }
        if (!extension.matches("\\.(png|jpe?g|gif|webp)")) {
            throw new ServletException("Định dạng ảnh không được hỗ trợ.");
        }

        Path uploadDirectory = Path.of(getServletContext().getRealPath("/uploads"));
        Files.createDirectories(uploadDirectory);

        String storedFileName = UUID.randomUUID() + extension;
        try (InputStream input = imagePart.getInputStream()) {
            Files.copy(input, uploadDirectory.resolve(storedFileName), StandardCopyOption.REPLACE_EXISTING);
        }
        return request.getContextPath() + "/uploads/" + storedFileName;
    }

    private void updateStatus(
            HttpServletRequest request,
            HttpServletResponse response,
            RequestDAO dao,
            String status
    ) throws Exception {

        HttpSession session = request.getSession(false);
        Integer accountId = session == null ? null : (Integer) session.getAttribute("accountId");
        String role = session == null ? null : (String) session.getAttribute("role");

        if (accountId == null || role == null || !"manager".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));

        if (!dao.updateStatusForApprover(id, accountId, status)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/requests?action=pending"
        );
    }

    private void delete(
            HttpServletRequest request,
            HttpServletResponse response,
            RequestDAO dao
    ) throws Exception {

        int id = Integer.parseInt(
                request.getParameter("id")
        );

        dao.delete(id);

        response.sendRedirect(
                request.getContextPath()
                        + "/requests?action=myRequests"
        );
    }
}
