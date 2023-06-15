<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%--한글 출력 위해 utf-8로 맞춤--%>
<%@ page import="kopo14.board.service.*" %>
<%--자바 클래스 임포트--%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>댓글쓰기</title>
<style>
	div {
		display: block;
		width: 750px;
		margin-left: auto;
		margin-right: auto;
	}
	table {
		width: 100%;
		border-collapse: collapse;
		border : solid 1px;
	}
	th {
		width: 70px;
		border: solid 1px;
	}
	td {
		border: solid 1px;
	}
	span {
		float: right;
		margin: 5px;
	}
</style>
</head>
<body>
	<Script type="text/javascript">
	function checkNull() { // 유효성 검사
	      var title = document.getElementsByName("title")[0].value;
	      var content = document.getElementsByName("content")[0].value;
	      
	      if (title.trim() == '') {
	        alert('제목을 입력하세요');
	      } else if (content.trim() == '') {
	        alert('내용을 입력하세요');
	      } else {
	        document.forms[0].action = 'Write.jsp';
	        document.forms[0].submit();
	      }
		}

	</Script>
	<%
		int rootid = Integer.parseInt(request.getParameter("rootid"));
		int relevel = Integer.parseInt(request.getParameter("relevel"));
		int recnt = Integer.parseInt(request.getParameter("recnt"));
		BoardItemService boardItemService = new BoardItemServiceImpl();
		String now = boardItemService.getCurrentDate();
		//자바 클래스 & 메소드 호출
	%>
	<div>
		<form method="post">
			<table>
				
				<tr>
					<th>번호</th>
					<td><input type="hidden" name="key" value="-2"/>신규(Insert)</td>
				</tr>
				<tr>
					<th>제목</th>
					<td><input type="text" name="title" maxlength="70" style="width: 670px"/></td>
				</tr>
				<tr>
					<th>일자</th>
					<td><%=now %></td>
				</tr>
				<tr>
					<th>내용</th>
					<td><textarea name="content" maxlength="300000" style="width: 670px; height: 400px;"></textarea></td>
				</tr>
				<tr>
					<th>원글</th>
					<td><input type="hidden" name="rootid" value="<%=rootid %>"/><%=rootid %></td>
				</tr>
				<tr>
					<th>댓글수준</th>
					<td><input type="hidden" name="relevel" value="<%=relevel + 1 %>"/><%=relevel + 1 %></td>
				</tr>
				<tr>
					<th>댓글순서</th>
					<td><input type="hidden" name="recnt" value="<%=recnt %>"/><%=recnt + 1 %></td>
				</tr>
			</table>
			<span>
				<input type='button' value='취소' onclick="location.href='index.jsp'"/>
				<input type='button' value='쓰기' onclick="checkNull()"/>
			</span>
		</form>
	</div>
</body>
</html>