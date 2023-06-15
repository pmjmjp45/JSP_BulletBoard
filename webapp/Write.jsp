<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%--한글 출력 위해 utf-8로 맞춤--%>
<%@ page import="kopo14.board.dao.*, kopo14.board.domain.*, java.util.*" %>
<%--자바 클래스 임포트--%>
<%request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새글쓰기</title>
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
<%!
	public String getEscapedString(String s){ // HTML escape
	    String str = s;
	    str = str.replace("&","&amp;");
	    str = str.replace("<","&lt;");
	    str = str.replace(">","&gt;");
	    str = str.replace("\"","&quot;");
	    str = str.replace("\'","&apos;");
	    return str;
	}
%>
<%
	int key = Integer.parseInt(request.getParameter("key"));
	int rootid = Integer.parseInt(request.getParameter("rootid"));
	int relevel = Integer.parseInt(request.getParameter("relevel"));
	int recnt = Integer.parseInt(request.getParameter("recnt"));
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	// 파라미터 저장하기
	String title_escape = getEscapedString(title);
	String content_escape = getEscapedString(content);
	
	BoardItemDao boardItemDao = new BoardItemDaoImpl();
	BoardItem boardItem = boardItemDao.writeNew(key, title_escape, content_escape, rootid, relevel, recnt);
	//자바 클래스 & 메소드 호출
	
%>
	<div>
		<form method="post">
			<table>
				<tr>
					<th>번호</th>
					<td><input type="hidden" name="key" value="<%=boardItem.getId() %>"/><%=boardItem.getId() %></td>
				</tr>
				<tr>
					<th>제목</th>
					<td><%=boardItem.getTitle() %></td>
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
					<td><textarea name="content" readonly style="width: 670px; height: 400px;"><%=boardItem.getContent() %></textarea></td>
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
					<td><input type="hidden" name="recnt" value="<%=boardItem.getRecnt() %>"/><%=boardItem.getRecnt() %></td>
				</tr>
			</table>
			<span>
				<input type='button' value='목록' onclick="location.href='index.jsp'"/>
				<input type='submit' value='수정' onclick="form.action='Update.jsp'"/>
				<input type='submit' value='삭제' onclick="form.action='Delete.jsp'"/>
				<input type='submit' value='댓글' onclick="form.action='Reply.jsp'"/>
			</span>
		</form>
	</div>
</body>
</html>