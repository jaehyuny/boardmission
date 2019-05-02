<%@ page language="java" contentType="application/vnd.ms-excel; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<% 

  String filename = request.getAttribute("filename").toString();
  response.setHeader("Content-Type", "application/vnd.ms-xls");
  response.setHeader("Content-Disposition", "inline; filename=List_" + filename + ".xls");
%>​ 
<meta charset="UTF-8">

<title>Insert title here</title>
</head>
<body>
<table class="table table-bordered" style="margin-top: 30px">
				<thead class="thead-dark" style="text-align: center">
					<tr>
						<th style="width: 200px">글번호</th>
						<th style="width: 200px">작성자</th>
<!-- 						<th>ip</th> -->
						<th style="width: 500px">제목</th>
						<th style="width: 150px">첨부파일</th>
						<th style="width: 150px">작성일</th>
						<th style="width: 150px">조회수</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="boards" items="${boards}" varStatus="status">
					<tr>
						<td style="text-align: center">
							<c:choose>
								<c:when test="${find == null || find == ''}">
									<c:if test="${boards.level == 0}">
										${boards.rownum}
									</c:if>
								</c:when>
								<c:otherwise>
									${boards.rownum}
								</c:otherwise>
							</c:choose>
						</td>
						<td><c:out value="${boards.name}" /></td>
<%-- 						<td>${boards.ip}</td> --%>
						<td>
<%-- 							<c:if test="${boards.level >= 1 && boards.remove == 1}"> --%>
<!-- 								<span style="color:red">[원글이 삭제된 답글]</span> -->
<%-- 							</c:if> --%>
							<c:choose>
								<c:when test="${boards.remove == 1}">
									[삭제된 글입니다]
								</c:when>
								<c:otherwise>
									<a href="updatehit?seq=${boards.seq}&ref=${boards.ref}" style="color: #292929">
									<c:if test="${boards.level >= 1 && boards.remove == 2}">
											<c:forEach begin="1" end="${boards.renum}">
												&nbsp;
											 </c:forEach>
											<i class="fab fa-replyd"></i>
									</c:if>
									<c:out value="${boards.title}" /></a>
								</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: center">
							<c:choose>
								<c:when test="${boards.attach == null || boards.attach == ''}">
								</c:when>
								<c:otherwise>
									<a href="#" onclick="onDownload('${boards.attach}')" style="color: #292929"><i id="attach_file" class="fas fa-clipboard"></i></a>
								</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: center">${boards.date}</td>
						<td style="text-align: center">${boards.hit}</td>
					</tr>
				</c:forEach>
				
				</tbody>
			</table>
</body>
</html>