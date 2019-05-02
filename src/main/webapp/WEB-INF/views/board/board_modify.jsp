<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
<script src="resources/js/jquery.min.js"></script>
<script src="resources/js/parsely.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" integrity="sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp" crossorigin="anonymous">
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script><script src="http://t1.daumcdn.net/postcode/api/core/180619/1529384927473/180619.js" type="text/javascript" charset="UTF-8"></script>
<script src="//cdn.ckeditor.com/4.6.2/standard/ckeditor.js"></script>
</head>
<script type="text/javascript">
function fnChkByte(obj) {
    var maxByte = 500; //최대 입력 바이트 수
    var str = obj.value;
    var str_len = str.length;
 
    var rbyte = 0;
    var rlen = 0;
    var one_char = "";
    var str2 = "";
 
    for (var i = 0; i < str_len; i++) {
        one_char = str.charAt(i);
 
        if (escape(one_char).length > 4) {
            rbyte += 3; //한글2Byte
        } else {
            rbyte++; //영문 등 나머지 1Byte
        }
 
        if (rbyte <= maxByte) {
            rlen = i + 1; //return할 문자열 갯수
        }
    }
    $('#chkbyte').text(rbyte+"/500");
 
    if (rbyte > maxByte) {
        alert("한글 166자 / 영문 " + maxByte + "자를 초과 입력할 수 없습니다.");
        str2 = str.substr(0, rlen); //문자열 자르기
        obj.value = str2;
        fnChkByte(obj, maxByte);
    } else {
        document.getElementById('byteInfo').innerText = rbyte;
    }
}
	$(document).ready(function(){
		$('#name').focus();
		$('#name').keyup(function (e){
		    var content = $(this).val();

		    if (content.length > 10){
		        alert("최대 10자까지 입력 가능합니다.");
		        $(this).val(content.substring(0, 10));
		    }
		})
		$('#title').keyup(function (e){
		    var content = $(this).val();

		    if (content.length > 25){
		        alert("최대 25자까지 입력 가능합니다.");
		        $(this).val(content.substring(0, 25));
		    }
		})
		$('#badelete').on('click', function() {
			var ba = $('#beforeattach').val();
			if(ba != null && ba != ''){
				$('#boardDeleteModal').modal('show');
				$('.boarddelete-modal-body').text("파일을 삭제하시겠습니까?");
				$('.boarddelete_modal_btn1').on('click', function() {
					$('#beforeattach').val("");
					$('#badelete').hide();
				})
			}
		})
		$('#boarddelete').on('click', function() {
			var pass = $('#password').val();
			var realpass = $('#realpass').val();
				if(pass != realpass) {
					alert('패스워드를 확인하세요');
					return;
				}
			var seq = $('#seq').val();
			var ref = $('#ref').val();
			$('#boardDeleteModal').modal('show');
			$('.boarddelete-modal-body').text("삭제하시겠습니까?");
			$('.boarddelete_modal_btn1').on('click', function() {
				location.href = "boarddelete?seq=" + seq + "&ref=" + ref;
			})
		})
		$('#modify').on('click', function() {
			var name = $('#name').val().trim();
			var password = $('#password').val().trim();
			var title = $('#title').val().trim();
				if(name == "" || name == null) {
					alert('이름을 입력하세요');
					$('#name').focus();
					return;
				}
				if(password == "" || password == null) {
					alert('비밀번호를 입력하세요');
					$('#password').focus();
					return;
				}
				if(title == "" || title == null) {
					alert('제목을 입력하세요');
					$('#title').focus();
					return;
				}
				var UserPassword = document.board_modify.password;
				 
				  if(UserPassword.value.length<8) {
				    alert("비밀번호는 영문(대소문자구분),숫자,특수문자(~!@#$%^&*()-_? 만 허용)를 혼용하여 8~16자를 입력해주세요.");
				    $('#password').val("");
				    return false;
				  }
				  
				  if(!UserPassword.value.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~,-])|([!,@,#,$,%,^,&,*,?,_,~,-].*[a-zA-Z0-9])/)) {
				      alert("비밀번호는 영문(대소문자구분),숫자,특수문자(~!@#$%^&*()-_? 만 허용)를 혼용하여 8~16자를 입력해주세요.");
				    $('#password').val("");
				    return false;
				  }
			$('#boardDeleteModal').modal({backdrop: 'static'});
			$('.boarddelete-modal-body').text("수정하시겠습니까?");
			$('.boarddelete_modal_btn1').on('click', function(e) {
				var form = document.board_modify;
			    form.submit();
			})
		})
		$('.filedelete').on('click', function(){
			var filenum = $(this).val();
			var seq = $('#seq').val();
			location.href = "filedelete?filenum=" + filenum + "&seq=" + seq;
		})
// 		$('#password').on('focus', function() {
// 			var name = $('#name').val().trim();
// 			if(name == "" || name == null) {
// 				alert('이름을 입력하세요');
// 				$('#name').focus();
// 				return;
// 			}
// 		})
// 	$('#title').on('focus', function() {
// 		var name = $('#name').val().trim();
// 		if(name == "" || name == null) {
// 			alert('이름을 입력하세요');
// 			$('#name').focus();
// 			return;
// 		}
// 			var password = $('#password').val().trim();
// 			if(password == "" || password == null) {
// 				alert('비밀번호를 입력하세요');
// 				$('#password').focus();
// 				return;
// 			}
// 		})
// 	$('#content').on('focus', function() {
// 		var name = $('#name').val().trim();
// 		if(name == "" || name == null) {
// 			alert('이름을 입력하세요');
// 			$('#name').focus();
// 			return;
// 		}
// 			var password = $('#password').val().trim();
// 			if(password == "" || password == null) {
// 				alert('비밀번호를 입력하세요');
// 				$('#password').focus();
// 				return;
// 			}
// 			var title = $('#title').val().trim();
// 			if(title == "" || title == null) {
// 				alert('제목을 입력하세요');
// 				$('#title').focus();
// 				return;
// 			}
// 		})
// 	$('#file').on('focus', function() {
// 		var name = $('#name').val().trim();
// 		if(name == "" || name == null) {
// 			alert('이름을 입력하세요');
// 			$('#name').focus();
// 			return;
// 		}
// 			var password = $('#password').val().trim();
// 			if(password == "" || password == null) {
// 				alert('비밀번호를 입력하세요');
// 				$('#password').focus();
// 				return;
// 			}
// 			var title = $('#title').val().trim();
// 			if(title == "" || title == null) {
// 				alert('제목을 입력하세요');
// 				$('#title').focus();
// 				return;
// 			}
// 		})
	})
</script>
<body>
	<form id="board_modify" name="board_modify" action="boardupdate" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
		<div class="container" style="text-align: center">
			<input type="hidden" id="seq" name="seq" value="${board.seq}">
			<input type="hidden" id="ref" name="ref" value="${board.ref}">
			<input type="hidden" id="step" name="step" value="${board.step}">
			<input type="hidden" id="level" name="level" value="${board.level}">
			<input type="hidden" id="realpass" name="realpass" value="${board.password}">
			<div style="margin-top: 30px">
				<h1>　</h1>
			</div>
			<div class="row" style="margin-top: 30px">
<!-- 				<div class="col-md-3"></div> -->
<!-- 				<div class="input-group mb-3 col-md-6 "> -->
<!-- 					<div class="input-group-prepend"> -->
<!-- 						<span class="input-group-text" style="width: 150px"><i -->
<!-- 							class="fas fa-user-plus" style="font-size: 17px"> ip</i></span> -->
<!-- 					</div> -->
<%-- 					<input type="text" class="form-control" id="ip" name="ip" value="${board.ip}" readonly> --%>
<!-- 				</div> -->
<!-- 				<div class="col-md-3"></div> -->
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"><i
							class="fas fa-user-lock" style="font-size: 17px"> 이름</i></span>
					</div>
					<input type="text" id="name" name="name" class="form-control" style="background-color: #fff" maxlenth="10" value="<c:out value="${board.name}" />">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
							<div class="input-group-prepend">
								<span class="input-group-text" style="width: 150px"><i
									class="fas fa-user-lock" style="font-size: 17px"> 비밀번호</i></span>
							</div>
							<input type="password" id="password" name="password"
								class="form-control" style="background-color: #fff" maxlength="16" placeholder="영문,숫자,특수문자를 혼용하여 8~16자 입력" required="true">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
							<div class="input-group-prepend">
								<span class="input-group-text" style="width: 150px"><i
									class="fas fa-user-lock" style="font-size: 17px"> 제목</i></span>
							</div>
							<input type="text" id="title" name="title"
								value="<c:out value="${board.title}" />" class="form-control" style="background-color: #fff" maxlength="30" required="true">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"><i
							class="fas fa-user-lock" style="font-size: 17px"> 첨부파일</i></span>
					</div>
					<input multiple="multiple" type="file" id="file" name="file" class="form-control">
<%-- 					<input type="text" name="beforeattach" class="form-control" value="${board.attach}" readonly> --%>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="col-md-6 ">
					<c:forEach var="file" items="${filelist}">
						<div style="text-align:left" class="form-control">
							<a href="boarddownload?attach=${file.file_name}" style="text-align: left">${file.file_name}</a>
							<button type="button" class="filedelete" value="${file.file_num}">삭제</button><br>
						</div>
					</c:forEach>
<%-- 					<input type="text" id="beforeattach" name="beforeattach" class="form-control" value="${board.attach}" readonly> --%>
<%-- 					<c:choose> --%>
<%-- 						<c:when test="${boards.attach == null || boards.attach == ''}"> --%>
<%-- 						</c:when> --%>
<%-- 						<c:otherwise> --%>
<%-- 						</c:otherwise> --%>
<%-- 					</c:choose> --%>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="col-md-6">
					<textarea id="content" name="content" class="form-control" rows="10" style="background-color: #fff; resize: none" maxlength="501" onkeyup="fnChkByte(this);" required="true"><c:out value="${board.content}" /></textarea>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="col-md-5">
				</div>
				<div class="col-md-1"><h7 id="chkbyte">${getb}/500</h7></div>
				<div class="col-md-3"></div>
			</div>
			
			<div class="row" style="margin-top: 30px">
				<div class="col-md-3"></div>
				<div class="col-md-3">
					<a href="boardpagelist"><button type="button" id="list" class="btn btn-primary btn-block">목록</button></a>
				</div>
				<div class="col-md-3">
							<button type="button" id="modify" class="btn btn-success btn-block">수정</button>
				</div>
				<div class="col-md-3"></div>
				<!-- Modal -->
				<div id="boardDeleteModal" class="modal fade" role="dialog">
					<div class="modal-dialog">

						<!-- Modal content-->
						<div class="modal-content">
							<div class="modal-header" style="background-color: #9999cc">
								<button type="button" class="close" data-dismiss="modal">&times;</button>
								<h4 class="modal-title"></h4>
							</div>
							<div class="boarddelete-modal-body">
								<p>Some text in the modal.</p>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-success boarddelete_modal_btn1"
									data-dismiss="modal">확인</button>
								<button type="button" class="btn btn-success boarddelete_modal_btn2"
									data-dismiss="modal">취소</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
<!-- 	<form id="board_reply" name="board_reply" action="nowreplyinsert" method="post"> -->
<%-- 	<input type="hidden" id="ref" name="ref" value="${board.ref}"> --%>
<!-- 		<div class="container" style="text-align: center"> -->
<!-- 			<div class="row"> -->
<!-- 				<div class="col-md-3"></div> -->
<!-- 				<div class="col-md-6"> -->
<%-- 				<c:forEach var="boards" items="${boards}" varStatus="status"> --%>
<%-- 					<c:set var="ref" value="${boards.ref}"/> --%>
<%-- 					<c:if test="${ref == boards.ref and boards.step > 0}"> --%>
<%-- 						<li>${boards.name} --%>
<%-- 						${boards.ip} --%>
<%-- 						${boards.date}<br> --%>
<%-- 						${boards.content}</li> --%>
<%-- 					</c:if> --%>
<%-- 				</c:forEach> --%>
<!-- 				</div> -->
<!-- 				<div class="col-md-3"></div> -->
<!-- 			</div> -->
<!-- 			<div class="row" style="margin-top: 30px"> -->
<!-- 				<div class="col-md-3"></div> -->
<!-- 				<div class="input-group mb-3 col-md-6 "> -->
<!-- 					<div class="input-group-prepend"> -->
<!-- 						<span class="input-group-text" style="width: 100px">이름</span> -->
<!-- 					</div> -->
<!-- 					<input type="text" class="form-control" id="name" name="name" required="true"> -->
<!-- 					<div class="input-group-prepend"> -->
<!-- 						<span class="input-group-text" style="width: 100px">비밀번호</span> -->
<!-- 					</div> -->
<!-- 					<input type="password" class="form-control" id="password" name="password" required="true"> -->
<!-- 				</div> -->
<!-- 				<div class="col-md-3"></div> -->
<!-- 			</div> -->
<!-- 			<div class="row"> -->
<!-- 				<div class="col-md-3"></div> -->
<!-- 				<div class="col-md-6"> -->
<!-- 					<textarea id="content" name="content" class="form-control" rows="3" style="background-color: #fff; resize: none" placeholder="댓글을 달아주세요" required="true"></textarea> -->
<!-- 				</div> -->
<!-- 				<div class="col-md-3"></div> -->
<!-- 			</div> -->
<!-- 			<div class="row"> -->
<!-- 				<div class="col-md-3"></div> -->
<!-- 				<div class="col-md-4"> -->
<!-- 				</div> -->
<!-- 				<div class="col-md-2"> -->
<!-- 							<button type="submit" id="nowreply" class="btn btn-warning btn-block">댓글달기</button> -->
<!-- 				</div> -->
<!-- 				<div class="col-md-3"> -->
<!-- 				</div> -->
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 	</form> -->
</body>
</html>