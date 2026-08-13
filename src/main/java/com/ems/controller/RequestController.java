package com.ems.controller;

import com.ems.dao.RequestDAO;
import com.ems.dto.RequestDTO;
import com.ems.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/requests")
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

        request.setAttribute("requests", list);

        request.getRequestDispatcher(
                "/WEB-INF/views/request/my-requests.jsp"
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

        List<RequestDTO> list =
                dao.getPendingRequests(accountId);

        request.setAttribute("requests", list);

        request.getRequestDispatcher(
                "/WEB-INF/views/request/pending.jsp"
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

        double value =
                Double.parseDouble(
                        request.getParameter("value")
                );

        int requestTypeId =
                Integer.parseInt(
                        request.getParameter("requestTypeId")
                );

        String imageUrl =
                request.getParameter("imageUrl");

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

        dto.setValue(value);
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

    private void updateStatus(
            HttpServletRequest request,
            HttpServletResponse response,
            RequestDAO dao,
            String status
    ) throws Exception {

        int id = Integer.parseInt(
                request.getParameter("id")
        );

        dao.updateStatus(id, status);

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