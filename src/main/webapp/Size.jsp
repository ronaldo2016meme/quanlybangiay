<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: ADMIN
  Date: 11/19/2026
  Time: 7:44 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<table>
    <thead>
        <tr>
            <th>Mã Size</th>
            <th>Tên Size</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach items="${listSize}" var="size">
            <tr>
                <td>${size.maSize}</td>
                <td>${size.tenSize}</td>
            </tr>
        </c:forEach>
    </tbody>
<%--an --%>
</table>
</body>
</html>
