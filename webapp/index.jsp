<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%--한글 출력 위해 utf-8로 맞춤--%>
<%@ page import="kopo14.board.dao.*, kopo14.board.domain.*, java.util.*
	, kopo14.board.service.*, kopo14.board.dto.*" %>
<%--자바 클래스 임포트--%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>목록</title>
<style>
	div {
		display: block;
		width: 750px;
		margin-left: auto;
		margin-right: auto;
	}
	table {
		border-collapse: collapse;
	}
	.page {
		border : none;
		width: 750px;
	}
	.list {
		table-layout:fixed;
	}
	th.num , td.num  {
		width: 50px;
		border : solid 1px;
		text-align: center;
	}
	th.title, td.title {
		width: 550px;
		border : solid 1px;
		text-align: left;
		max-width : 550px; white-space: nowrap; text-overflow:ellipsis; overflow:hidden;
	}
	th.vcnt, td.vcnt {
		width: 70px;
		border : solid 1px;
		text-align: center;
	}
	th.date, td.date {
		width: 100px;
		border : solid 1px;
		text-align: center;
	}
	input {
		float: right;
		margin: 5px;
	}
	.deleted {
		text-decoration: line-through;
	    color: gray;
	}
	.titleArea{
		width:550px;
		display: inline-flex;
  		align-items: center;
		border : none;
	}
	.titleCut{
		max-width : 530px; white-space: nowrap; text-overflow:ellipsis; overflow:hidden;
	}
	.newIcon {
		width: 20px; 
		height: 20px; 
		margin-bottom: -5px; 
		opacity: 0;
	}
</style>
</head>
<body>
<%
	BoardItemService boardItemService = new BoardItemServiceImpl(); //자바 클래스 호출
	
	String page2 = request.getParameter("page"); // 현재페이지와 한페이지당 출력 수의 변수를 인자로 받음
	String cnt2 = request.getParameter("cnt");
	
	// 인자 null일때(가장 처음 접속했을 때) 위해 값 초기화
	int currentPage = 1;
	int countPerPage = 10;
	if (page2 != null) {
		currentPage = Integer.parseInt(page2);
	}
	if (cnt2 != null) {
		countPerPage = Integer.parseInt(cnt2);
	}
	
	Pagination p = boardItemService.getPagination(currentPage, countPerPage); // 페이지네이션 호출
	String currentDate = boardItemService.getCurrentDate(); // 현재 날짜 호출
%>
	<div> 
		<table class="page">
			<tr>
				<td style="text-align:left;">
					현재페이지: <%=p.getC() %> 
				</td>
				<td style="text-align:right; border:none; width:auto;">
	 			<!-- 페이지 당 출력 개수 선택 -->
			 		<form method="get" action="index.jsp" onchange="this.submit()">
			 			<label for="countPerPage">페이지 당 개수</label>
			 			<select id="countPerPage" name="cnt" size="1" >
			 				<option value="10" <% if (countPerPage == 10) out.print("selected"); %>>10</option>
			 				<option value="30" <% if (countPerPage == 30) out.print("selected"); %>>30</option>
			 				<option value="50" <% if (countPerPage == 50) out.print("selected"); %>>50</option>
			 				<option value="100" <% if (countPerPage == 100) out.print("selected"); %>>100</option>
			 			</select>
			 		</form>
	 			</td>
			</tr>
		</table>
		<table class="list">
			<thead>
			<tr> 
				<th class="num">번호</th>
				<th class='title' style="text-align:center">제목</th>
				<th class='vcnt'>조회수</th>
				<th class="date">등록일</th>
			</tr></thead>
			<tbody>
			<%
				BoardItemDao boardItemDao = new BoardItemDaoImpl();
				List<BoardItem> showAll = boardItemDao.showList();
				//자바 클래스 & 메소드 호출
				
				
				
				//목록 출력
				for (int i = ((currentPage - 1) * countPerPage); i < ((currentPage - 1) * countPerPage) + countPerPage; i++) { 
					if (i >= p.getTotalCount()) break; // 마지막 페이지 탈출 조건(없으면 outofBoundary 예외 뜸)
					
					// 제목 댓글 및 새 글 표시
					String title = showAll.get(i).getTitle(); 
					String dateDB = showAll.get(i).getDate();
					%>	
					
<script> <!-- 제목 NEW 띄우기 위한 함수 / 조건: 길이가 길어야 하고, 오늘 날짜여야 함-->
	window.addEventListener('DOMContentLoaded', function() {
		  var titleCutElements = document.getElementsByClassName('titleCut');
		  var dateElements = document.getElementsByClassName('date');
		  var currentDate = '<%=currentDate%>';
		  var date = '<%=dateDB%>';
		  
		  for (var i = 0; i < titleCutElements.length; i++) {
		    var element = titleCutElements[i];
		    
		    if ((element.offsetWidth > 500) && (currentDate === date)) {
		      var nextElement = element.nextElementSibling;
		      nextElement.style.opacity = '1';
		    }
		  }
		});
</script>	

					<%
					if (showAll.get(i).getDate().equals(currentDate)) { // 오늘 날짜 글은 모두 새 글
						title += "<img src='./icon/new.png' style='border: none; width: 20px; height: 20px; margin-bottom: -5px'>";
						// 새로운 글 아이콘 입력
					}
					
					String hyphen = ""; // 댓글 앞 빈 공간
					
					if (showAll.get(i).getRelevel() > 0) { // relevel 수 만큼 빈 공간 추가
						for (int j = 0; j < showAll.get(i).getRelevel(); j++) {
							hyphen += "&nbsp; &nbsp;";
						}
						hyphen += "<img src='./icon/reply.png' style='border: none; width: 20px; height: 20px; margin-bottom: -5px'>"; 
						// 댓글 화살표 아이콘 입력
						title = hyphen + title;
					}
					
					out.println("<tr><td class='num'>" + showAll.get(i).getId() + "</td>");	
					
					if (showAll.get(i).getStatus() == -1) {
						out.println("<td class='deleted' style='border: black'>" + title + "</td>");
					} else {
						out.println("<td class='title'><div class='titleArea'><a class='titleCut' style='border: none' href='View.jsp?key=" + showAll.get(i).getId() + "'>" + title + "</a>");
						out.println("<img class='newIcon' src='./icon/new.png'/></div></td>");
					}
					out.println("<td class='vcnt'>" + showAll.get(i).getViewcnt() + "</td>");
					out.println("<td class='date'>" + showAll.get(i).getDate() + "</td></tr>");
				}
				
			%>
			</tbody>
		</table>
		<input type='submit' value='신규' onclick="location.href='Insert.jsp'"/>
		<br>
		<div style="text-align: center">
	<%
		//하단 페이지 부분
		if (currentPage >= 10) {
			out.println("<a href='index.jsp?page=" + p.getPp() + "&cnt=" + countPerPage + "'>&lt;&lt;</a>"); // <<
			out.println("<a href='index.jsp?page=" + p.getP() + "&cnt=" + countPerPage + "'>&lt;</a>"); // <
		}
	
		for (int i = p.getS(); i <= p.getE(); i++) { // 1~10
			if (i > p.getTotalPage()) break;
			if (i == currentPage) {
				out.println("<a href='index.jsp?page=" + p.getC() + "&cnt=" + countPerPage + "' style='font-size: 2em;'>" + p.getC() + "</a>");
			} else {
				out.println("<a href='index.jsp?page=" + i + "&cnt=" + countPerPage + "'>" + i + "</a>");
			}
		}
		if (currentPage < ((p.getTotalPage() - 1) / 10) * 10 + 1) {
			out.println("<a href='index.jsp?page=" + p.getN() + "&cnt=" + countPerPage + "'>&gt;</a>"); // >
			out.println("<a href='index.jsp?page=" + p.getNn() + "&cnt=" + countPerPage + "'>&gt;&gt;</a>"); // >>
		}
	%>
		</div>
	</div>
</body>
</html>