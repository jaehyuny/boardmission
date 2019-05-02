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
    var maxByte = 300; //최대 입력 바이트 수
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
    $('.chkbyte').text(rbyte+"/300");
 
    if (rbyte > maxByte) {
        alert("한글 100자 / 영문 " + maxByte + "자를 초과 입력할 수 없습니다.");
        str2 = str.substr(0, rlen); //문자열 자르기
        obj.value = str2;
        fnChkByte(obj, maxByte);
    } else {
        document.getElementById('byteInfo').innerText = rbyte;
    }
}
	$(document).ready(function(){
			$('#boardModifyModal').on('shown.bs.modal', function() {
				$('#mpassword').focus();
			});
			$('#boardDeleteModal').on("shown.bs.modal", function() {
				$('#dpassword').focus();
			});
			$('#nowreplyname').keyup(function (e){
			    var content = $(this).val();

			    if (content.length > 6){
			        alert("최대 6자까지 입력 가능합니다.");
			        $(this).val(content.substring(0, 6));
			    }
			})
		$('#boarddelete').on('click', function() {
			$('#boardDeleteModal').modal('show');
			$('.boarddelete-modal-body').text("비밀번호를 입력하세요");
			$('.dp').show();
			$('.boarddelete_modal_btn1').show();
			$('.boarddelete_modal_btn1a').hide();
			$('.boarddelete_modal_btn1').on('click', function() {
				var pass = $('#dpassword').val();
				var realpass = $('#realpass').val();
					if(pass != realpass) {
						alert('비밀번호가 맞지 않습니다');
						$('#dpassword').val('');
						$('#dpassword').focus();
						return false;
					}else {
						$('.boarddelete-modal-body').text("삭제하시겠습니까?");
						$('.dp').hide();
						$('.boarddelete_modal_btn1').hide();
						$('.boarddelete_modal_btn1a').show();
						$('.boarddelete_modal_btn1a').on('click', function() {
							var form = document.board_detail;
	 					    form.submit();
						})
						$('.boarddelete_modal_btn2').on('click', function() {
							$('#dpassword').val('');
						})
						return false;
					}
			})
		})
			$('#boardDeleteModal').on('hide.bs.modal', function() {
				location.reload();
			});
		$('#modify').on('click', function() {
			$('#boardModifyModal').modal({backdrop: 'static'});
			$('.boardmodify-modal-body').text("비밀번호를 입력하세요");
			$('.boardmodify_modal_btn1').on('click', function(e) {
				var pass = $('#mpassword').val();
				var realpass = $('#realpass').val();
				var seq = $('#seq').val();
					if(pass != realpass) {
						alert('비밀번호가 맞지 않습니다');
						$('#mpassword').val('');
						$('#mpassword').focus();
						return false;
					}else {
						location.href="boardmodify?seq=" + seq;
						return false;
					}
// 						var form = document.board_detail;
// 					    form.submit();
			})
		})
		$('#name').on('blur', function() {
			var name = $('#name').val().trim();
			if(name == "" || name == null) {
				alert('이름을 입력하세요');
				$('#name').focus();
				return;
			}
		})
		$('#nowreply').on('click', function(){
			var name = $('#nowreplyname').val().trim();
			var password = $('#nowreplypassword').val().trim();
			var content = $('#nowreplycontent').val().trim();
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
				if(content == "" || content == null) {
					alert('내용을 입력하세요');
					$('#content').focus();
					return;
				}
			var form = document.board_nowreply;
		    form.submit();
		})
		$('.repmodify').on('click', function(){
			var repseq = $(this).val();
			var seq = $('#seq').val();
			var ref = $('#ref').val();
			$('#replyDeleteModal').modal({backdrop: 'static'});
			$('.replydelete-modal-body').text("비밀번호를 입력하세요");
			$('.dp').show();
			$('.replydelete_modal_btn1').show();
			$('.replydelete_modal_btn1a').hide();
			$('.replydelete_modal_btn1').on('click', function() {
			var password = $('#rpassword').val();
				$.ajax({
					type : 'POST',
					data : "seq=" + repseq + "&password=" + password,
					url : 'replyconfirm',
					success : function(data) {
						if (data == 0) {
							alert('비밀번호가 맞지 않습니다');
							$('#rpassword').val('');
							$('#rpassword').focus();
							return false;
						} else {
							$('.reply-modal-title').text("수정할 내용을 입력하세요");
							$('.replydelete-modal-body').text("");
							$('.dp').hide();
							$('.mcontent').show();
							$('.replydelete_modal_btn1').hide();
							$('.replydelete_modal_btn1a').show();
							$('.replydelete_modal_btn1a').on('click', function() {
								var content = $('#mcontent').val();
								alert('수정되었습니다');
								location.href = "replyupdate?seq=" + seq + "&ref=" + ref + "&repseq=" + repseq + "&content=" + content;
							})
							$('.replydelete_modal_btn2').on('click', function() {
								$('#rpassword').val('');
							})
							return false;
						}
					},
					error : function(xr, status, error) {
						alert('ajax error');
					}
				});
			})
		})
		$('.repdelete').on('click', function(){
			var repseq = $(this).val();
			var seq = $('#seq').val();
			var ref = $('#ref').val();
			$('#replyDeleteModal').modal('show');
			$('.replydelete-modal-body').text("비밀번호를 입력하세요");
			$('.dp').show();
			$('.replydelete_modal_btn1').show();
			$('.replydelete_modal_btn1a').hide();
			$('.replydelete_modal_btn1').on('click', function() {
				var password = $('#rpassword').val();
				$.ajax({
					type : 'POST',
					data : "seq=" + repseq + "&password=" + password,
					url : 'replyconfirm',
					success : function(data) {
						if (data == 0) {
							alert('비밀번호가 맞지 않습니다');
							$('#rpassword').val('');
							$('#rpassword').focus();
							return false;
						} else {
							$('.replydelete-modal-body').text("삭제하시겠습니까?");
							$('.dp').hide();
							$('.replydelete_modal_btn1').hide();
							$('.replydelete_modal_btn1a').show();
							$('.replydelete_modal_btn1a').on('click', function() {
								location.href = "replydelete?seq=" + seq + "&ref=" + ref + "&repseq=" + repseq;
							})
							$('.replydelete_modal_btn2').on('click', function() {
								$('#rpassword').val('');
							})
							return false;
						}
					},
					error : function(xr, status, error) {
						alert('ajax error');
					}
				});
			})
		})
		$('#boardModifyModal').on('hide.bs.modal', function() {
			location.reload();
		})
		$('#replyDeleteModal').on('hide.bs.modal', function() {
			location.reload();
		})
		
	})
</script>
<body>
	<form id="board_detail" name="board_detail" action="boarddelete" method="post" enctype="multipart/form-data">
		<div class="container" style="text-align: center">
			<input type="hidden" id="seq" name="seq" value="${board.seq}">
			<input type="hidden" id="ref" name="ref" value="${board.ref}">
			<input type="hidden" id="step" name="step" value="${board.step}">
			<input type="hidden" id="level" name="level" value="${board.level}">
			<input type="hidden" id="renum" name="renum" value="${board.renum}">
			<input type="hidden" id="realpass" name="realpass" value="${board.password}">
			<input type="hidden" name="beforeattach" value="${board.attach}">
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
					<input type="text" id="name" name="name" class="form-control" style="background-color: #fff" value="<c:out value="${board.name}" />" readonly>
				</div>
				<div class="col-md-3"></div>
			</div>
<!-- 			<div class="row"> -->
<!-- 				<div class="col-md-3"></div> -->
<!-- 				<div class="input-group mb-3 col-md-6 "> -->
<!-- 							<div class="input-group-prepend"> -->
<!-- 								<span class="input-group-text" style="width: 150px"><i -->
<!-- 									class="fas fa-user-lock" style="font-size: 17px"> 비밀번호</i></span> -->
<!-- 							</div> -->
<!-- 							<input type="password" id="password" name="password" -->
<!-- 								class="form-control" style="background-color: #fff" maxlength="16" required="true"> -->
<!-- 				</div> -->
<!-- 				<div class="col-md-3"></div> -->
<!-- 			</div> -->
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
							<div class="input-group-prepend">
								<span class="input-group-text" style="width: 150px"><i
									class="fas fa-user-lock" style="font-size: 17px"> 제목</i></span>
							</div>
							<input type="text" id="title" name="title"
								value="<c:out value="${board.title}" />" class="form-control" style="background-color: #fff" maxlength="25" required="true" readonly>
				</div>
				<div class="col-md-3"></div>
			</div>
<!-- 			<div class="row"> -->
<!-- 				<div class="col-md-3"></div> -->
<!-- 				<div class="input-group mb-3 col-md-6 "> -->
<!-- 					<div class="input-group-prepend"> -->
<!-- 						<span class="input-group-text" style="width: 150px"><i -->
<!-- 							class="fas fa-user-lock" style="font-size: 17px"> 첨부파일</i></span> -->
<!-- 					</div> -->
<%-- 							<c:choose> --%>
<%-- 								<c:when test="${board.attach == null || board.attach == ''}"> --%>
<!-- 									<input type="text" class="form-control" disabled> -->
<%-- 								</c:when> --%>
<%-- 								<c:otherwise> --%>
<%-- 									<a href="boarddownload?attach=${board.attach}" class="form-control" style="text-align: left">${board.attach}</a> --%>
<%-- 								</c:otherwise> --%>
<%-- 							</c:choose> --%>
<!-- 				</div> -->
<!-- 				<div class="col-md-3"></div> -->
<!-- 			</div> -->
			<div class="row">
				<div class="col-md-3"></div>
				<div class="col-md-6">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"><i
							class="fas fa-user-lock" style="font-size: 17px"> 첨부파일</i></span>
					</div>
					<c:forEach var="file" items="${filelist}">
					<div style="text-align:left" class="form-control">
						<a href="boarddownload?attach=${file.file_name}" style="text-align: left">${file.file_name}</a>
					</div>
					</c:forEach>
				</div>
				<div class="col-md-3">
				</div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="col-md-6">
					<textarea id="content" name="content" class="form-control" rows="10" style="background-color: #fff; resize: none" maxlength="501" onkeyup="fnChkByte(this);" required="true" readonly><c:out value="${board.content}" /></textarea>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row" style="margin-top: 30px">
				<div class="col-md-3"></div>
				<div class="col-md-1">
					<a href="boardpagelist"><button type="button" id="list" class="btn btn-primary btn-block">목록</button></a>
				</div>
				<div class="col-md-2">
							<button type="button" id="modify" class="btn btn-success btn-block">수정</button>
				</div>
				<div class="col-md-2">
							<button type="button" id="boarddelete" class="btn btn-danger btn-block">삭제</button>
				</div>
				<div class="col-md-1">
						<button type="button" id="reply" onclick="location.href='boardreplyform?renum=${board.renum}&ref=${board.ref}&step=${board.step}&level=${board.level}'" class="btn btn-warning btn-block">답변</button>
				</div>
				<div class="col-md-3"></div>
			</div>
			</div>
			<!-- Modal -->
				<div id="boardModifyModal" class="modal fade" role="dialog">
					<div class="modal-dialog">

						<!-- Modal content-->
						<div class="modal-content" style="text-align:center">
							<div class="modal-header" style="background-color: #9999cc">
								<button type="button" class="close" data-dismiss="modal">&times;</button>
								<h4 class="modal-title"></h4>
							</div>
							<div class="boardmodify-modal-body">
								<p>Some text in the modal.</p>
							</div>
							<div>
								<input type="password" id="mpassword" name="mpassword"
								style="background-color: #fff" maxlength="16" required="true">
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-success boardmodify_modal_btn1"
									>확인</button>
								<button type="button" class="btn btn-success boardmodify_modal_btn2"
									data-dismiss="modal">취소</button>
							</div>
						</div>
					</div>
				</div>
				<div id="boardDeleteModal" class="modal fade" role="dialog">
					<div class="modal-dialog">

						<!-- Modal content-->
						<div class="modal-content" style="text-align:center">
							<div class="modal-header" style="background-color: #9999cc">
								<button type="button" class="close" data-dismiss="modal">&times;</button>
								<h4 class="modal-title"></h4>
							</div>
							<div class="boarddelete-modal-body">
								<p>Some text in the modal.</p>
							</div>
							<div class="dp">
								<input type="password" id="dpassword" name="dpassword"
								style="background-color: #fff" maxlength="16" required="true">
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-success boarddelete_modal_btn1"
									>확인</button>
								<button type="button" class="btn btn-success boarddelete_modal_btn1a"
									>확인</button>
								<button type="button" class="btn btn-success boarddelete_modal_btn2"
									data-dismiss="modal">취소</button>
							</div>
						</div>
					</div>
				</div>
				<div id="replyDeleteModal" class="modal fade" role="dialog">
					<div class="modal-dialog">

						<!-- Modal content-->
						<div class="modal-content" style="text-align:center">
							<div class="modal-header" style="background-color: #9999cc">
								<h4 class="reply-modal-title"></h4>
								<button type="button" class="close" data-dismiss="modal">&times;</button>
							</div>
							<div class="replydelete-modal-body">
								<p>Some text in the modal.</p>
							</div>
							<div class="dp">
								<input type="password" id="rpassword" name="rpassword"
								style="background-color: #fff" maxlength="4" required="true">
							</div>
							<div class="mcontent" style="display:none">
								<textarea id="mcontent" name="mcontent" class="form-control" rows="3" style="background-color: #fff; resize: none" maxlength="301" onkeyup="fnChkByte(this);" required="true"></textarea>
							</div>
							<div class="row mcontent" style="display:none">
								<div class="col-md-3"></div>
								<div class="col-md-5">
								</div>
								<div class="col-md-1"></div>
								<div class="col-md-3"><h7 class="chkbyte">0/300</h7></div>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-success replydelete_modal_btn1"
									>확인</button>
								<button type="button" class="btn btn-success replydelete_modal_btn1a"
									>확인</button>
								<button type="button" class="btn btn-success replydelete_modal_btn2"
									data-dismiss="modal">취소</button>
							</div>
						</div>
					</div>
				</div>
			</form>
		<form id="board_nowreply" name="board_nowreply" action="nowreplyinsert" method="post">
			<input type="hidden" id="repseq" name="repseq" value="${board.seq}">
			<input type="hidden" id="repref" name="ref" value="${board.seq}">
			<div class="container" style="text-align: center">
			<div class="row" style="margin-top: 30px">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
							<div class="input-group-prepend">
								<span class="input-group-text" style="width: 100px">이름</span>
							</div>
							<input type="text" id="nowreplyname" name="name"
								class="form-control" style="background-color: #fff" maxlength="7" required="true">
							<div class="input-group-prepend">
								<span class="input-group-text" style="width: 100px">비밀번호</span>
							</div>
							<input type="password" id="nowreplypassword" name="password"
								class="form-control" style="background-color: #fff" maxlength="4" placeholder="4자리입력" required="true">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="col-md-6">
					<textarea id="nowreplycontent" name="content" class="form-control" rows="3" style="background-color: #fff; resize: none" maxlength="301" onkeyup="fnChkByte(this);" required="true"></textarea>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="col-md-5">
				</div>
				<div class="col-md-1"><h7 class="chkbyte">0/300</h7></div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="col-md-1">
				</div>
				<div class="col-md-2">
				</div>
				<div class="col-md-2">
				</div>
				<div class="col-md-1">
						<button type="button" id="nowreply" class="btn btn-success btn-block">등록</button>
				</div>
				<div class="col-md-3"></div>
			</div>
			</div>
		</form>
				
				<div class="container" style="text-align: center">
				<div style="margin-top:30px"></div>
				<c:forEach var="replylist" items="${replylist}" varStatus="status">
				<div class="row" style="text-align:left">
					<div class="col-md-3"></div>
					<div class="col-md-6 alert alert-success" role="alert">
							<c:out value="${replylist.name}" />&nbsp;&nbsp;&nbsp;${replylist.date}<br>
	<%-- 						<td>${boards.ip}</td> --%>
							<hr class="one">
							<textarea class="form-control" rows="3" style="resize:none" readonly>${replylist.content}</textarea>
							
<%-- 							<div class="modifycontent" id="mc${replylist.seq}" style="display:none"> --%>
<!-- 							<textarea id="repmodify" name="repmodify" class="form-control" rows="3" style="background-color: #fff; resize: none" maxlength="301" onkeyup="fnChkByte(this);" required="true"></textarea> -->
<!-- 							</div> -->
					</div>
					<div class="col-md-3">
						<button type="button" class="repmodify" value="${replylist.seq}">수정</button><br>
						<button type="button" class="repdelete" value="${replylist.seq}">삭제</button>
					</div>
				</div>
				</c:forEach>
				</div>
	
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