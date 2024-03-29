<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/common.jsp"%>
<!-- <meta http-equiv="refresh" content="0; url=landing.do"/> -->
</head>
	<script type="text/javascript">
		var tb = "";
		var mode = "";
		var dupcheck = false;
	
		// 화면 진입 호출부
		$(function(){
			init();
			
			$('#codeTable tbody').on('click', 'tr', function () {
		        if ($(this).hasClass('selected')) {
		            $(this).removeClass('selected');
		        } else {
					tb.$('tr.selected').removeClass('selected');
					$(this).addClass('selected');
					var item = $.map(tb.row('.selected').data(), function(item){
						return item;
					});
			        // 상세수정 버튼 클릭 시 이벤트
			    	$("#modalCodeDiv").val(item[0]);
					$("#modalCodeDiv").attr("disabled",true); 
					$("#modalCodeVal").val(item[1]);
					$("#modalCodeVal").attr("disabled",true);
					$("#modalCodeValDesc").val(item[2]);
					$("#modalCodeDivDesc").val(item[3]);
					
		            
					$(".modal-last").append('<button type="button" onclick="del()" id="btnDel" class="w-btn delBtn">코드 삭제</button>');
					
		            modal("M");
		        }
		    });
			
		});
   		
		function del() {
			mode = "D";
			dataAdd();
		}
		
		function init() {
			// 선택된 구분에 대한 값 세팅
			selectValList();
			setDataTable();
		}
		
		function search() {
			tb.ajax.reload( null, false);
		}
		
		function setDataTable() {
			$('#codeTable').DataTable().destroy();
			tb = $("#codeTable").DataTable({
				ajax: {
					type: 'POST',
	                url: './codeList.do',
	                data: {
	                	codeDiv: function() { return $("#codeDiv").val() },
	                	codeVal: function() { return $("#codeVal").val() },
	                	codeValDesc: function() { return $("#codeValDesc").val() }
	                },
	                dataType: "JSON"
	            },
				dom: 'Bfrtip',
				destroy: true,
				bFilter: false, // 검색란 제어
				processing: true,
				pageLength : 10, // 페이징은 10개씩
				columnDefs: [ { // 요건 컬럼 정의 
						'target' : [0],
						'searchable' : false,
						'orderable' : true,
						'className' : 'chkCenter',
					},{
						'target' : [1],
						'searchable' : false,
						'orderable' : true,
						'className' : 'chkCenter',
					},{
						'target' : [2],
						'searchable' : false,
						'orderable' : true,
						'className' : 'chkCenter',
					},{
						'target' : [3],
						'searchable' : false,
						'orderable' : true,
						'className' : 'chkCenter',
					}
				 ],
				order: [ [ 1, 'asc' ] ],
				columns: [
                    {data: 'CODE_DIV', render: $.fn.dataTable.render.text()}, //코드구분
                    {data: 'CODE_DIV_DESC', render: $.fn.dataTable.render.text()}, //코드구분
                    {data: 'CODE_VAL', render: $.fn.dataTable.render.text()}, //코드값
                    {data: 'CODE_VAL_DESC', render: $.fn.dataTable.render.text()}, //코드설명
			  	],
			  	buttons: [{
					text: '등록하기',
					className: 'w-btn w-btn-blue',
					action: function(e, dt, node, config) {
						modal("C");
					}
				}],
			  	drawCallback: function() {
			  		if($.isFunction(tb.data)) {
			  			$("#rowCount").text(tb.data().length);
			  		}
			  	}
			});
			
			tb.rows({selected:true}).data();
		}
	  	$.fn.dataTable.ext.errMode = function (settings, helpPage, message) {
		        console.log(message);
		        console.log(helpPage);
		        // 응답값이 json이 아닐 경우
		        if (helpPage === 1) {
		         	alert("세션이 만료됐습니다.확인 클릭 시 로그인 화면으로 이동합니다.");
		         	location.replace("./login.do");
		            return false;
		        }
		    };
		function modal(type) {
			if(type == "C") {
				$("#headerName").text("코드 등록");
				$("#btnTxt").text("코드 등록");
				$("#modalCodeDiv").val($("#codeDiv").val());
				$("#modalCodeDivDesc").val($("#codeDiv option:checked").text());
				$("#modalCodeVal").val($("#codeDiv").val());
				$("#modal").show();
				mode = "C";
			} else if(type == "M") {
				$("#headerName").text("코드 상세/수정");
				$("#btnTxt").text("코드 수정");
				$("#modal").show();
				mode = "M";
			} else if(type == "D") { // 닫기
				$("#headerName").text("");
				$("#modal").hide();
				
				// modal 안의 모든 input 값 초기화
				$("#modal").find('input[type=text]').each(function() {
					$(this).val("");
				});
				$("#modalCodeDiv").removeAttr("disabled"); 
				$("#modalCodeVal").removeAttr("disabled"); 
				
				$("#btnDel").remove();
				
				search();
			}
		}
		
		// 선택된 코브구분에 따른 코드 값 세팅
		function selectValList() {
			$("#codeVal").empty();
			
			request("./codeValList.do",{codeDiv : $("#codeDiv").val()}, function callback(res) {
				if(res.result > 0) {
					if(res.valList.length > 0) {
						var option = '<option value="">코드 값 선택(전체)</option>';
						for(var i=0; i<res.valList.length; i++) {
							option += '<option value="'+res.valList[i].CODE_VAL+'">'+res.valList[i].CODE_VAL_DESC+'</option>'
						}
						$("#codeVal").append(option);
					}
				} else {
					alert(res.message);
				}
			},
			function error(request,status) {
				alert(status);
			});
		}
		
		// 모달 닫기
		function modalClose() {
			modal("D");
		}
		
		function valCheck() {
			var codeDiv = $("#modalCodeDiv").val();
			var codeVal = $("#modalCodeVal").val();
			
			if(codeDiv == "") {
				alert("구분코드를 입력해주세요.");
				return $("#modalCodeDiv").focus();
			}
			if(codeVal == "") {
				alert("구분코드값을 입력해주세요.");
				return $("#modalCodeVal").focus();
			}
			
			var params = {
				codeDiv : codeDiv,
				codeVal : codeVal
			}
			
			request("./valCheck.do", params, function callback(res) {
				if(res.result > 0) {
					alert(res.message);
					$("#modalCodeVal").val('');
					
					$("#modalCodeVal").focus();
					dupcheck = false;
					return;
				}  else {
					alert(res.message);
					$("#modalCodeValDesc").focus();
					dupcheck = true;
				}
			},
			function error(request,status) {
				alert(status);
			});		
		}
		
		function dataAdd() {
			
			var codeDiv = $("#modalCodeDiv").val();
			var codeVal = $("#modalCodeVal").val();
			var codeDivDesc = $("#modalCodeDivDesc").val();
			var codeValDesc = $("#modalCodeValDesc").val();
			
			if(mode == "C") {
				if(codeDiv == "") {
					alert("구분코드를 입력해주세요.");
					return $("#modalCodeDiv").focus();
				}
				if(codeVal == "") {
					alert("구분코드값을 입력해주세요.");
					return $("#modalCodeVal").focus();
				}
				if(codeDivDesc == "") {
					alert("구분코드에 대한 설명을 입력해주세요.");
					return $("#modalCodeDivDesc").focus();
				}
				if(codeValDesc == "") {
					alert("구분코드값에 대한 설명을 입력해주세요.");
					return $("#modalCodeValDesc").focus();
				}
				if(!dupcheck) {
					alert("중복체크를 진행해주세요.");
					return;
				}
				
			} else if(mode == "M") {
				if(codeDivDesc == "") {
					alert("구분코드에 대한 설명을 입력해주세요.");
					return $("#modalCodeDivDesc").focus();
				}
				if(codeValDesc == "") {
					alert("구분코드값에 대한 설명을 입력해주세요.");
					return $("#modalCodeValDesc").focus();
				}
			}
			
			var params = {
				mode : mode,
				codeDiv : codeDiv,
				codeVal : codeVal,
				codeDivDesc : codeDivDesc,
				codeValDesc : codeValDesc
			}
			
			request("./codeChange.do", params, function callback(res) {
				if(res.result > 0) {
					alert(res.message);
					modal("D");
					tb.ajax.reload( null, false);
				}  else {
					alert(res.message);
				}
			},
			function error(request,status) {
				alert(status);
			});		
		}
    </script>
    
<body> 
	<%@ include file="/WEB-INF/jsp/frame/topFrame.jsp" %>	
	<div class="wrap">
		<div class="title_box">
			<h1>공통코드관리</h1>
			<p>홈 > 공통코드관리</p>
		</div>
		<div class="search_box">
			<p>검색조건 총 (<span id="rowCount">0</span>개)</p>
			<ul>
				<li>
					<select name="codeDiv" id="codeDiv" onchange="selectValList()">
						<c:if test="${!empty divList }">
							<c:forEach items="${divList }" var="divList" varStatus="status">
								<option value="${divList.CODE_DIV }">${divList.CODE_DIV_DESC }</option>
							</c:forEach>
						</c:if>
					</select>
					<select name="codeVal" id="codeVal">
					</select>
				</li>
				<li>
					<input class="search_text" name="codeValDesc" id="codeValDesc" type="text" placeholder="코드 설명">
				</li>
			</ul>
			<button class="search_btn" onclick="search()">검색</button>
		</div>
	</div>
	<table id="codeTable" class="table is-striped" style="width: 100%">
		<thead>
			<tr>
				<th>
					<div>코드 구분</div>
				</th>
				<th>
					<div>코드 구분 설명</div>
				</th>
				<th>
					<div>코드 값</div>
				</th>
				<th>
					<div>코드 설명</div>
				</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	
	<!-- modal Layer -->
	<div id="modal">
	    <div class="modal_content" style="margin: 160px auto !important; height: auto !important;">
	    	<div class="modal-header">
	    		<span id="headerName" class="headerName"></span>
	    		<button type="button" onclick="modalClose()" class="close-area">X</button>
	    	</div>
	    	<div class="modal-body" style="height:30%">
	    		<div class="body_header">기본 정보</div>
	    		<table class="modal_tbl">
	    			<tr>
	    				<th>코드 구분</th>
	    				<td>
	    					<input type="text" id="modalCodeDiv" maxLength="3" name="modalCodeDiv" class="inputFull"/>
	    				</td>
	    				<th>코드 구분 설명</th>
	    				<td>
	    					<input type="text" id="modalCodeDivDesc" name="modalCodeDivDesc" class="inputFull"/>
	    				</td>
	    			</tr>
	    			<tr>
	    				<th>코드 값</th>
	    				<td>
		    				<input type="text" id="modalCodeVal" maxLength="6" name="modalCodeVal" class="inputHalf" onKeypress="javascript:if(event.keyCode==13) {valCheck()}"/>
		    				<button type="button" onclick="valCheck()" class="w-btn-1 checkBtn">중복체크</button>
	    				</td>
	    				<th>코드 값 설명</th>
	    				<td><input type="text" id="modalCodeValDesc" name="modalCodeValDesc" class="inputFull"/></td>
	    			</tr>
	    		</table>
	    	</div>
	    	<div class="modal-last">
		    	<button type="button" onclick="dataAdd()" id="btnTxt" class="w-btn saveBtn"></button>
		    </div>
	    </div>
	    <div class="modal_layer"></div>
	</div>
	
</body>
</html>