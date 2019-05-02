<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">
  <title>Main</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
<script src="resources/js/jquery.min.js"></script>
<script src="resources/js/myquery.js"></script>
<script src="resources/js/parsely.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" integrity="sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp" crossorigin="anonymous">
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script><script src="http://t1.daumcdn.net/postcode/api/core/180619/1529384927473/180619.js" type="text/javascript" charset="UTF-8"></script>
<!-- Bootstrap core CSS -->
  <link href="resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <!-- Custom fonts for this template -->
  <link href="resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <!-- Page level plugin CSS -->
  <link href="resources/vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
  <!-- Custom styles for this template -->
  <link href="resources/css/sb-admin.css" rel="stylesheet">
</head>
<script type="text/javascript">
function onDownload(key) {
	var keyword = encodeURI(key);
	location.href = "boarddownload?attach=" + keyword;
}
function pagemoveup() {
    var pagenum = $('#pn').val();
    var max = $('#max').val();
    var find = $('#find').val();
    var category = $('#category').val();
    var resultpn = Math.floor((pagenum-1)/10+1);
    var resultpm = Math.floor((max-1)/10+1);
    var page = (resultpn*10)+1;
    if(resultpn != resultpm && max > 10){
    	location.href = "boardpageselected?page=" + page + "&find=" + find + "&category=" + category;
    }else {
    	location.href = "boardpageselected?page=" + max + "&find=" + find + "&category=" + category;
    }
}
function pagemovedown() {
    var pagenum = $('#pn').val();
    var pagemax = $('#pm').val();
    var find = $('#find').val();
    var category = $('#category').val();
    var resultpn = Math.floor((pagenum-1)/10+1);
    var resultpm = Math.floor((pagemax-1)/10+1);
    var page = Math.floor((pagenum-1)/10)*10-9;
    if(pagenum > 10){
    	location.href = "boardpageselected?page=" + page + "&find=" + find + "&category=" + category;
    }else {
    	location.href = "boardpageselected?page=1&find=" + find + "&category=" + category;
    }
}
$(document).ready(function(){
	$('#search').on('click', function() {
		var find = $('#find').val().trim();
		if(find == "" || find == null){
			alert('검색어를 입력하세요');
			$('#find').val("");
			$('#find').focus();
			return;
		}else {
			var form = document.board_list;
			    form.submit();
		}
	})
})
</script>
<body>
	<form id="board_list" name="board_list" action="boardpagelist" method="get">
	<iframe id="ifrm_filedown"  style="position:absolute; z-index:1;visibility : hidden;"></iframe> 
	<input type="hidden" id="pn" name="pn" value="${pagenum}">
	<input type="hidden" id="pm" name="pm" value="${pagemax}">
	<input type="hidden" id="max" name="max" value="${max}">
		<div class="container">
			<div class="row" style="margin-top: 30px">
				<div class="col-md-4"></div>
				<div class="col-md-4" style="text-align: center">
					<h1>게시판</h1>
				</div>
				<div class="col-md-4"></div>
			</div>

			<table class="table table-bordered" style="margin-top: 30px">
				<thead class="thead-dark" style="text-align: center">
					<tr>
						<th style="width: 200px">글번호</th>
						<th style="width: 200px">작성자</th>
<!-- 						<th>ip</th> -->
						<th style="width: 500px">제목</th>
<!-- 						<th style="width: 150px">첨부파일</th> -->
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
<!-- 						<td style="text-align: center"> -->
<%-- 							<c:choose> --%>
<%-- 								<c:when test="${boards.attach == null || boards.attach == ''}"> --%>
<%-- 								</c:when> --%>
<%-- 								<c:otherwise> --%>
<%-- 									<a href="#" onclick="onDownload('${boards.attach}')" style="color: #292929"><i id="attach_file" class="fas fa-clipboard"></i></a> --%>
<%-- 								</c:otherwise> --%>
<%-- 							</c:choose> --%>
<!-- 						</td> -->
						<td style="text-align: center">${boards.date}</td>
						<td style="text-align: center">${boards.hit}</td>
					</tr>
				</c:forEach>
				
				</tbody>
			</table>
			<c:if test="${pagemax != 0}">
			<nav aria-label="Page navigation example" style="margin-top:30px">
				<ul class="pagination justify-content-center">
					<c:choose>
						<c:when test="${pagenum != 1}">
							<li class="page-item"><a class="page-link"
								href="boardpageselected?page=1&find=${find}&category=${category}">&laquo;</a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item disabled"><a class="page-link"
								href="boardpageselected?page=1&find=${find}&category=${category}">&laquo;</a></li>
						</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${pagenum > 1}">
							<li class="page-item"><a class="page-link" href="#" onclick="pagemovedown();"
								><span aria-hidden="true">&lsaquo;</span></a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item disabled"><a class="page-link" href="#"
								><span aria-hidden="true">&lsaquo;</span></a></li>
						</c:otherwise>
					</c:choose>
					<c:forEach var="page" items="${pages}">
					<c:choose>
						<c:when test="${page == pagenum}">
							<li class="page-item active"><a class="page-link" href="boardpageselected?page=${page}&find=${find}&category=${category}">${page}<span class="sr-only">(current)</span></a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item"><a class="page-link" href="boardpageselected?page=${page}&find=${find}&category=${category}">${page}</a></li>
						</c:otherwise>
					</c:choose>
					</c:forEach>
					<c:choose>
						<c:when test="${pagenum < pagemax && pagemax > 1}">
							<li class="page-item"><a class="page-link" href="#" onclick="pagemoveup();"
								><span aria-hidden="true">&rsaquo;</span></a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item disabled"><a class="page-link" href="#"><span aria-hidden="true">&rsaquo;</span></a></li>
						</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${pagenum != max}">
							<li class="page-item"><a class="page-link"
								href="boardpageselected?page=${max}&find=${find}&category=${category}">&raquo;</a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item disabled"><a class="page-link"
								href="boardpageselected?page=${max}&find=${find}&category=${category}">&raquo;</a></li>
						</c:otherwise>
					</c:choose>
				</ul>
			</nav>
			</c:if>
			<div class="row" style="margin-top: 30px">
					<select id="category" name="category">
						<option value="searchall"<c:if test="${category == 'searchall' || category == ''}">selected</c:if>>전체검색</option>
						<option value="searchtitle"<c:if test="${category == 'searchtitle'}">selected</c:if>>제목</option>
						<option value="searchcontent"<c:if test="${category == 'searchcontent'}">selected</c:if>>내용</option>
						<option value="searchname"<c:if test="${category == 'searchname'}">selected</c:if>>작성자</option>
					</select>
					<input type="text" title="a" id="find" name="find" value="${find}">
					<button type="button" class="btn btn-primary" id="search"><i class="fas fa-search"></i> 검색</button>
					<a href="boardinsertform"><button type="button" id="write" class="btn btn-success">글쓰기</button></a>
					<a href="boardpagelist"><button type="button" id="list" class="btn btn-primary btn-block">목록</button></a>
					<a href="boardListExcel"><button type="button" class="btn btn-primary btn-block">전체페이지 엑셀</button></a>
					<a href="boardNowListExcel?find=${find}&category=${category}&page=${pagenum}"><button type="button" class="btn btn-primary btn-block">현재페이지 엑셀</button></a>
					<a href="boardSearchListExcel?find=${find}&category=${category}"><button type="button" class="btn btn-primary btn-block">검색리스트 엑셀</button></a>
<!-- 					<a href="smspage"><button type="button" class="btn btn-primary btn-block">문자전송</button></a> -->
			</div>
		</div>
	</form>
</body>
</html>