function onlyNumber(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ((keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105)
			|| keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39)
		return;
	else
		return false;
}
function removeChar(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if (keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39)
		return;
	else
		event.target.value = event.target.value.replace(/[^0-9]/g, "");
}
function phone2_lengthchk(code) {
	if (code.value.length == 4) {
		document.member_insert_form.phone3.focus();
	}
}
function busno1_lengthchk(code) {
	if (code.value.length == 3) {
		document.vender_insert_form.busno2.focus();
	}
}
function busno2_lengthchk(code) {
	if (code.value.length == 2) {
		document.vender_insert_form.busno3.focus();
	}
}
function officeno2_lengthchk(code) {
	if (code.value.length == 4) {
		document.vender_insert_form.officeno3.focus();
	}
}
function zipcodefind() {

	new daum.Postcode({

		oncomplete : function(data) {

			// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

			// 도로명 주소의 노출 규칙에 따라 주소를 조합한다.

			// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.

			var fullRoadAddr = data.roadAddress; // 도로명 주소 변수

			var extraRoadAddr = ''; // 도로명 조합형 주소 변수

			// 법정동명이 있을 경우 추가한다. (법정리는 제외)

			// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.

			if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {

				extraRoadAddr += data.bname;

			}

			// 건물명이 있고, 공동주택일 경우 추가한다.

			if (data.buildingName !== '' && data.apartment === 'Y') {

				extraRoadAddr += (extraRoadAddr !== '' ? ', '
						+ data.buildingName : data.buildingName);

			}

			// 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.

			if (extraRoadAddr !== '') {

				extraRoadAddr = ' (' + extraRoadAddr + ')';

			}

			// 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.

			if (fullRoadAddr !== '') {

				fullRoadAddr += extraRoadAddr;

			}

			// 우편번호와 주소 정보를 해당 필드에 넣는다.

			document.getElementById('insertpostno').value = data.zonecode; //5자리 새우편번호 사용

			document.getElementById('insertaddr1').value = fullRoadAddr;

			document.getElementById('insertaddr2').value = data.jibunAddress;

		}

	}).open();

}
function selectedSeq(seq){
	$.ajax({
		type : 'POST',
		data : "seq=" + seq,
		url : 'buydetail',
		success : function(data) {
			$('#selectvender').val(data.vendcode).prop('selected', true);
			$('#buysave').hide();
			$('#buyreset').hide();
			$('#buyupdate').show();
			$('#buydelete').show();
			$('#seq').attr('value',data.seq);
			$('#yyyy').attr('value',data.yyyy);
			$('#mm').attr('value',data.mm);
			$('#dd').attr('value',data.dd);
			$('#no').attr('value',data.no);
			$('#hang').attr('value',data.hang);
			$('#selectproduct').val(data.procode).prop('selected', true);
			$('#productcode').attr('value',data.procode);
			$('#beforeprocode').attr('value',data.procode);
			$('#stock').attr('value',data.stock);
			$('#price').attr('value',data.price);
			$('#beforeprice').attr('value',data.price);
			$('#qty').attr('value',data.qty);
			$('#beforeqty').attr('value',data.qty);
			$('#total').attr('value',data.qty*data.price);
			$('#memo').attr('value',data.memo);
		},
		error : function(xr, status, error) {
			alert('ajax error');
		}
	});
}
function selectedpaySeq(seq){
	$.ajax({
		type : 'POST',
		data : "seq=" + seq,
		url : 'paydetail',
		success : function(data) {
			$('#selectpayvender').val(data.vendcode).prop('selected', true);
			$('#paysave').hide();
			$('#payreset').hide();
			$('#payupdate').show();
			$('#paydelete').show();
			$('#seq').attr('value',data.seq);
			$('#yyyy').attr('value',data.yyyy);
			$('#mm').attr('value',data.mm);
			$('#dd').attr('value',data.dd);
			$('#no').attr('value',data.no);
			$('#hang').attr('value',data.hang);
			$('#payway').val(data.payway).prop('selected', true);
			$('#beforepayway').attr('value',data.payway);
			$('#amount').attr('value',data.amount);
			$('#beforeamount').attr('value',data.amount);
			$('#memo').attr('value',data.memo);
		},
		error : function(xr, status, error) {
			alert('ajax error');
		}
	});
}
$(document).ready(function() {
	$('#login').on('click', function() {
		$(location).attr('href', "loginform");
	});
	$('#board').on('click', function() {
		$(location).attr('href', "boardpagelist");
	});
	$('#3').on('click', function() {
		$(location).attr('href', "person");
	});
	$('#insertconfirm').on('click', function() {
		var email = $('#insertemail').val();
		if (email == "") {
			$('#myModal').modal('show');
			$('.modal-body').text("아이디를 입력하세요");
			$('.modal_btn1').text("확인");
			$('.modal_btn2').hide();
		} else {
			$.ajax({
				type : 'POST',
				data : "email=" + email,
				url : 'memberconfirm',
				success : function(data) {
					if (data == 0) {
						// 							alert('사용가능한 아이디');
						$('#myModal').modal('show');
						$('.modal-body').text("사용가능한 아이디");
						$('.modal_btn1').on('click', function() {
							$('#confirm_yn').val("y");
						});
					} else {
						// 							alert('중복 아이디');
						$('#myModal').modal('show');
						$('.modal-body').text("중복 아이디");
						$('.modal_btn1').text("확인");
						$('.modal_btn2').hide();
						$('#insertemail').val("");
						$('#insertemail').focus();
						// 							$('.modal_btn1').on('click',function(){
						// 								$('#email').val("");
						// 								$('#email').focus();
						// 							});
					}
				},
				error : function(xr, status, error) {
					alert('ajax error');
				}
			});
		}
		// 			var name="korea";
		// 			email += "@"+$('#domain').val();
		// 			location.href="memberconfirm?email="+email+"&name="+name;
		// 			alert(email);
	});
	$('#insertsave').on('click', function() {
		if ($('#confirm_yn').val() == "n") {
			$('#myModal').modal('show');
			$('.modal-body').text("email 중복체크를 하세요");
			$('.modal_btn1').text("확인");
			$('.modal_btn2').hide();
			return;
		}
		$('#member_insert_form').parsley().validate();
		$('#member_insert_form').submit();
	});
	$('#insertimage').on('click', function() {
		$('input[type=file]').click();
		return false
	});
	$('#insertphoto').change(function(event) {
		var tmppath = URL.createObjectURL(event.target.files[0]);
		$('#insertimage').attr('src', tmppath);
	});
	$('#emailAuth').on('click', function() {
		var email = $('#insertemail').val();
		$.ajax({
			type : 'POST',
			data : "email=" + email,
			datatype : 'json',
			url : 'emailAuth',
			success : function(data) {
				alert("success");
				return false;
			}
		});
	});
	$('#updateimage').on('click', function() {
		$('input[type=file]').click();
		return false
	});
	$('#updatephoto').change(function(event) {
		var tmppath = URL.createObjectURL(event.target.files[0]);
		$('#updateimage').attr('src', tmppath);
	});
	$('#updatedelete').on('click', function() {
		$('#updateModal').modal('show');
		$('.update-modal-body').text("삭제하시겠습니까?");
		$('.update_modal_btn1').text("YES");
		$('.update_modal_btn2').text("NO");
		$('.update_modal_btn1').on('click', function() {
			var url = "memberdelete?email=" + $('#email').val();
			$(location).attr('href', url);
		});
	});
	$('#ps').on('click', function() {
		$('#loginModal').modal('show');
		$('.login_modal_btn1').on('click', function() {
			$.ajax({
				type : 'POST',
				data : "email=" + $('#findemail').val(),
				url : 'passwordfind',
				success : function(data) {
					if (data == 0) {
						$('#pstext').text("없는 아이디");
					} else {
						$('#pstext').text("있는 아이디");
					}
				},
				error : function(xr, status, error) {
					alert('ajax error');
				}
			});
		})
		$('.login_modal_btn2').on('click', function() {
			$('#pstext').text("");
		})
	})
	$('#boarddelete').on('click', function() {
		var b_seq = $('#b_seq').val();
		var b_ref = $('#b_ref').val();
		$('#boardDeleteModal').modal('show');
		$('.boarddelete-modal-body').text("삭제하시겠습니까?");
		$('.boarddelete_modal_btn1').on('click', function() {
			location.href = "boarddelete?b_seq=" + b_seq + "&b_ref=" + b_ref;
		})
	})
	$('#salaryupdatedelete').on('click', function() {
		$('#salaryupdateModal').modal('show');
		$('.salary-update-modal-body').text("삭제하시겠습니까?");
		$('.salary_update_modal_btn1').text("YES");
		$('.salary_update_modal_btn2').text("NO");
		$('.salary_update_modal_btn1').on('click', function() {
			var url = "salarydelete?empno=" + $('#empno').val();
			$(location).attr('href', url);
		});
	});
	$('#salaryinsertconfirm').on('click', function() {
		var empno = $('#empno').val();
		if (empno == "") {
			$('#salarymyModal').modal('show');
			$('.salary-modal-body').text("사원번호를 입력하세요");
		} else {
			$.ajax({
				type : 'POST',
				data : "empno=" + empno,
				url : 'salaryconfirm',
				success : function(data) {
					if (data == 0) {
						$('#salarymyModal').modal('show');
						$('.salary-modal-body').text("사용가능한 사원번호");
						$('.salary_modal_btn1').on('click', function() {
							$('#salaryconfirm_yn').val("y");
						});
					} else {
						$('#salarymyModal').modal('show');
						$('.salary-modal-body').text("중복 사원번호");
						$('#empno').val("");
						$('#empno').focus();
					}
				},
				error : function(xr, status, error) {
					alert('ajax error');
				}
			});
		}
	});
	$('#salarysave').on('click', function() {
		if ($('#salaryconfirm_yn').val() == "n") {
			$('#salarymyModal').modal('show');
			$('.salary-modal-body').text("사원번호 중복체크를 하세요");
			return;
		}
		$('#salary_form').parsley().validate();
		$('#salary_form').submit();
	});
	$('example').DataTable({
		"order" : [ [ 0, "desc" ] ]
	});
	$('#examplesalary').DataTable();
	$('#salarytaxsave').on('click', function() {
		$('#salarytaxmyModal').modal('show');
		$('.salarytax_modal_btn1').on('click', function() {
			$('#salary_tax').attr('action', 'salarytax');
			$('#salary_tax').submit();
		});
	});
	$('#productupdatedelete').on('click', function() {
		$('#productupdateModal').modal('show');
		$('.productupdate-modal-body').text("삭제하시겠습니까?");
		$('.productupdate_modal_btn1').text("YES");
		$('.productupdate_modal_btn2').text("NO");
		$('.productupdate_modal_btn1').on('click', function() {
			var url = "productdelete?code=" + $('#code').val();
			$(location).attr('href', url);
		});
	});
	$('#productinsertconfirm').on('click', function() {
		var code = $('#code').val();
		if (code == "") {
			$('#productmyModal').modal('show');
			$('.product-modal-body').text("바코드를 입력하세요");
		} else {
			$.ajax({
				type : 'POST',
				data : "code=" + code,
				url : 'productconfirm',
				success : function(data) {
					if (data == 0) {
						$('#productmyModal').modal('show');
						$('.product-modal-body').text("사용가능한 바코드");
						$('.product_modal_btn1').on('click', function() {
							$('#productconfirm_yn').val("y");
						});
					} else {
						$('#prudctmyModal').modal('show');
						$('.product-modal-body').text("중복 바코드");
						$('#code').val("");
						$('#code').focus();
					}
				},
				error : function(xr, status, error) {
					alert('ajax error');
				}
			});
		}
	});
	$('#productsave').on('click', function() {
		if ($('#productconfirm_yn').val() == "n") {
			$('#productmyModal').modal('show');
			$('.product-modal-body').text("바코드 중복체크를 하세요");
			return;
		}
		$('#product_form').parsley().validate();
		$('#product_form').submit();
	});
	$('#venderinsertconfirm').on('click', function() {
		var code = $('#code').val();
		if (code == "") {
			$('#vendermyModal').modal('show');
			$('.vender-modal-body').text("코드를 입력하세요");
		} else {
			$.ajax({
				type : 'POST',
				data : "code=" + code,
				url : 'venderconfirm',
				success : function(data) {
					if (data == 0) {
						$('#vendermyModal').modal('show');
						$('.vender-modal-body').text("사용가능한 코드");
						$('.vender_modal_btn1').on('click', function() {
							$('#venderconfirm_yn').val("y");
						});
					} else {
						$('#vendermyModal').modal('show');
						$('.vender-modal-body').text("중복 코드");
						$('#code').val("");
						$('#code').focus();
					}
				},
				error : function(xr, status, error) {
					alert('ajax error');
				}
			});
		}
	});
	$('#vendersave').on('click', function() {
		if ($('#venderconfirm_yn').val() == "n") {
			$('#vendermyModal').modal('show');
			$('.vender-modal-body').text("코드 중복체크를 하세요");
			return;
		}
		$('#vender_form').parsley().validate();
		$('#vender_form').submit();
	});
	$('#venderupdatedelete').on('click', function() {
		$('#venderupdateModal').modal('show');
		$('.venderupdate-modal-body').text("삭제하시겠습니까?");
		$('.venderupdate_modal_btn1').text("YES");
		$('.venderupdate_modal_btn2').text("NO");
		$('.venderupdate_modal_btn1').on('click', function() {
			var url = "venderdelete?code=" + $('#code').val();
			$(location).attr('href', url);
		});
	});
	$('#selectvender').on('change', function(){
		var vendname = $(this).children('option:selected').text();
		var vendcode = $(this).val();
		$.ajax({
			type : 'POST',
			data : "vendcode=" + vendcode,
			url : 'buynew',
			success : function(data) {
				$('#vendname').attr('value',vendname);
				if(vendcode == '0000'){
					$('#yyyy').attr('value','');
					$('#mm').attr('value','');
					$('#dd').attr('value','');
					$('#no').attr('value','');
					$('#hang').attr('value','');
				}else{
					$('#yyyy').attr('value',data.yyyy);
					$('#mm').attr('value',data.mm);
					$('#dd').attr('value',data.dd);
					$('#no').attr('value',data.no);
					$('#hang').attr('value',data.hang);
				}
			},
			error : function(request, status, error) {
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	});
	$('#selectproduct').on('change', function(){
		var proname = $(this).children('option:selected').text();
		var procode = $(this).val();
		$.ajax({
			type : 'POST',
			data : "procode=" + procode,
			url : 'productselected',
			success : function(data) {
				if(procode == '0000000000000'){
					$('#productcode').attr('value','');
					$('#stock').attr('value','');
					$('#price').attr('value','');
				}else{
					$('#productcode').attr('value',data.code);
					$('#stock').attr('value',data.stock);
					$('#price').attr('value',data.buyprice);
					$('#qty').focus();
				}
			},
			error : function(request, status, error) {
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	});
	$('#qty').on('blur', function(){
		var amount = $('#price').val() * $('#qty').val();
		$('#total').attr('value',amount);
	});
	$('#buysave').on('click', function(){
		var selectedvend = $('#selectvender').val();
		var selectedproduct = $('#selectproduct').val();
		var qty = $('#qty').val();
		if(selectedvend == '0000'){
			$('#modalmsgvender').text('거래처를 선택하세요');
		}else{
			$('#modalmsgvender').text('');
		}
		if(selectedproduct == '0000000000000'){
			$('#modalmsgproduct').text('상품을 선택하세요');
		}else{
			$('#modalmsgproduct').text('');
		}
		if(qty == 0){
			$('#modalmsg').text('수량을 입력하세요');
		}else{
			$('#modalmsg').text('');
		}
		if(selectedvend == '0000' || selectedproduct == '0000000000000' || qty == 0){
			$('#buymyModal').modal('show');
		}else {
			$('#buy_form').submit();
		}
	});
	$('#buysearch').on('click', function(){
		var vendcode = $('#searchvender').children('option:selected').val();
		if(vendcode == '0000'){
			$('#modalmsgvender').text('매입처를 선택하세요');
			$('#modalmsgproduct').text('');
			$('#modalmsg').text('');
			$('#buymyModal').modal('show');
		}else{
			$('#modalmsgvender').text('');
			$('#buysearch_form').submit();
		}
	});
	$('#buyupdate').on('click', function(){
		$('#buy_form').attr('action','buyupdate');
		$('#buy_form').submit();
	});
	$('#buydelete').on('click', function(){
		$('#modalmsgvender').text('삭제하시겠습니까?');
		$('#buymyModal').modal('show');
		$('.buy_modal_btn1').on('click', function() {
			$('#buy_form').attr('action','buydelete');
			$('#buy_form').submit();
		});
	});
	$('#paysave').on('click', function(){
		$('#pay_form').submit();
	});
	$('#paysearch').on('click', function(){
		var vendcode = $('#searchvender').children('option:selected').val();
		if(vendcode == '0000'){
			$('#modalmsgvender').text('매입처를 선택하세요');
			$('#modalmsgproduct').text('');
			$('#modalmsg').text('');
			$('#paymyModal').modal('show');
		}else{
			$('#modalmsgvender').text('');
			$('#paysearch_form').submit();
		}
	});
	$('#payupdate').on('click', function(){
		$('#pay_form').attr('action','payupdate');
		$('#pay_form').submit();
	});
	$('#paydelete').on('click', function(){
		$('#modalmsgvender').text('삭제하시겠습니까?');
		$('#paymyModal').modal('show');
		$('.pay_modal_btn1').on('click', function() {
			$('#pay_form').attr('action','paydelete');
			$('#pay_form').submit();
		});
	});
	$('#selectpayvender').on('change', function(){
		var vendname = $(this).children('option:selected').text();
		var vendcode = $(this).val();
		$.ajax({
			type : 'POST',
			data : "vendcode=" + vendcode,
			url : 'paynew',
			success : function(data) {
				$('#vendname').attr('value',vendname);
				if(vendcode == '0000'){
					$('#yyyy').attr('value','');
					$('#mm').attr('value','');
					$('#dd').attr('value','');
					$('#no').attr('value','');
					$('#hang').attr('value','');
				}else{
					$('#yyyy').attr('value',data.yyyy);
					$('#mm').attr('value',data.mm);
					$('#dd').attr('value',data.dd);
					$('#no').attr('value',data.no);
					$('#hang').attr('value',data.hang);
				}
			},
			error : function(request, status, error) {
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	});
	$('#finalsave').on('click', function(){
		$('#finalModal').modal('show');
		$('.final_modal_btn1').on('click', function() {
			$('#final_form').submit();
		});
	});
});
