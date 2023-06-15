<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%!
	public String getEscapedString(String s){
	    String str = s;
	    str = str.replace("&","&amp;");
	    str = str.replace("<","&lt;");
	    str = str.replace(">","&gt;");
	    str = str.replace("\"","&quot;");
	    return str;
	}
%>
<%
	String text = request.getParameter("te");
	String de = getEscapedString(text);
	out.println(de);
%>
</body>
</html>