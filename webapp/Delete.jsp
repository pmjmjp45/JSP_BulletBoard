<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%--한글 출력 위해 utf-8로 맞춤--%>
<%@ page import="kopo14.board.dao.*, kopo14.board.domain.*, java.util.*" %>
<%--자바 클래스 임포트--%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>삭제</title>
</head>
<body>
<%
	int number = Integer.parseInt(request.getParameter("key"));
	int relevel = Integer.parseInt(request.getParameter("relevel"));
	//삭제할 글의 id
	
	BoardItemDao boardItemDao = new BoardItemDaoImpl();
	boolean bool = boardItemDao.delete(number, relevel);
	//자바 클래스 & 메소드 호출
	
	if (bool == true) {// 삭제 성공시 경고창 팝업
		out.println("<script>alert('삭제되었습니다');");
        out.println("window.location.href = 'index.jsp';</script>");
    } else { // 실패시 문구 출력
    	out.println("error");
    }
%>
</body>
</html>