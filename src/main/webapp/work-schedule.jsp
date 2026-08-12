<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Work Schedule</title>

    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        input[type="time"] {
            padding: 5px;
        }
    </style>
</head>

<body>

<h2>Work Schedule</h2>

<form action="${pageContext.request.contextPath}/work-schedule" method="post">
    <table>
        <thead>
        <tr>
            <th>Day</th>
            <th>Working</th>
            <th>Start Time</th>
            <th>End Time</th>
            <th>Break Start</th>
            <th>Break End</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach var="shift" items="${shifts}" varStatus="status">
            <tr>
                <td>
                        ${shift.dayOfWeek}
                    <input type="hidden" name="dayOfWeek_${status.index}" value="${shift.dayOfWeek}">
                </td>
                <td>
                    <input type="checkbox" name="working_${status.index}" value="true"${shift.working ? 'checked' : ''}>
                </td>
                <td>
                    <input type="time" name="startTime_${status.index}" value="${shift.startTime}">
                </td>
                <td>
                    <input type="time" name="endTime_${status.index}" value="${shift.endTime}">
                </td>
                <td>
                    <input type="time" name="breakStart_${status.index}" value="${shift.breakStart}">
                </td>
                <td>
                    <input type="time" name="breakEnd_${status.index}" value="${shift.breakEnd}">
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <br>
    <button type="submit">Save Schedule</button>
</form>
</body>
</html>