<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%--한글 출력 위해 utf-8로 맞춤--%>
<%@ page import="kopo14.board.dao.*, kopo14.board.domain.*, java.util.*,
kopo14.board.service.*" %>
<%--자바 클래스 임포트--%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 읽기</title>
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
		word-break: break-word;
	}
	span {
		float: right;
		margin: 5px;
	}
</style>
</head>
<body>
<%
	int number = Integer.parseInt(request.getParameter("key"));

	BoardItemDao boardItemDao = new BoardItemDaoImpl();
	boardItemDao.addViewCount(number); // 조회수 증가
	BoardItem boardItem = boardItemDao.showContent(number);
	//자바 클래스 & 메소드 호출
	
%>
	<div>
		<form method="post">
			<table>
				<tr>
					<th>번호</th>
					<td><input type="hidden" name="key" value="<%=number %>"/><%=number %></td>
				</tr>
				<tr>
					<th>제목</th>
					<%
					BoardItemService boardItemService = new BoardItemServiceImpl();
					String currentDate = boardItemService.getCurrentDate();
					String title = boardItem.getTitle(); 
					
					if (boardItem.getDate().equals(currentDate)) { // 오늘 날짜 글은 모두 새 글
						title += "<img src='./icon/new.png' style='border: none; width: 20px; height: 20px; margin-bottom: -5px'>";
					}
					
					String hyphen = ""; 
					
					if (boardItem.getRelevel() > 0) { //답글의 경우 제목 앞에 공간의 띄움
						for (int j = 0; j < boardItem.getRelevel(); j++) {
							hyphen += "&nbsp; &nbsp;";
						}
						hyphen += "<img src='./icon/reply.png' style='border: none; width: 20px; height: 20px; margin-bottom: -5px'>"; 
						title = hyphen + title;
					}
					%>
					<td><%=title %></td>
				</tr>
				<tr>
					<th>일자</th>
					<td><%=boardItem.getDate()%></td>
				</tr>
				<tr>
					<th>조회수</th>
					<td><%=boardItem.getViewcnt()%></td>
				</tr>
				<tr>
					<th>내용</th>
					<%
						if (boardItem.getStatus() == -1) {
							out.println("<td>삭제된 글입니다.</td>");
						} else {
					%>
					<td><textarea name="content" readonly style="width: 670px; height: 400px;"><%=boardItem.getContent() %></textarea></td>
					<%} %>
				</tr>
				<tr>
					<th>원글</th>
					<td><input type="hidden" name="rootid" value="<%=boardItem.getRootid() %>"/><%=boardItem.getRootid() %></td>
				</tr>
				<tr>
					<th>댓글수준</th>
					<td><input type="hidden" name="relevel" value="<%=boardItem.getRelevel() %>"/><%=boardItem.getRelevel() %></td>
				</tr>
				<tr>
					<th>댓글순서</th>
					<td><input type="hidden" name="recnt" value="<%=boardItem.getRecnt()%>"/><%=boardItem.getRecnt() %></td>
				</tr>
			</table>
			<span>
				<input type='button' value='목록' onclick="location.href='index.jsp'"/>
				<%
					if (boardItem.getStatus() != -1) {
				%>
				<input type='submit' value='수정' onclick="form.action='Update.jsp'"/>
				<input type='submit' value='삭제' onclick="form.action='Delete.jsp'"/>
				<input type='submit' value='댓글' onclick="form.action='Reply.jsp'"/>
				<%} %>
			</span>
		</form>
	</div>
</body>
</html>