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
		width: 700px;
		margin-left: auto;
		margin-right: auto;
	}
	.list {
		table-layout:fixed;
		border-collapse:collapse;
	}
	th, td  .num {
		width: 50px;
		border : solid 1px;
		text-align: center;
	}
	.list :nth-child(2) {
		width: 550px;
		border : solid 1px;
		text-align: left;
		
	}
	.list :nth-child(3) {
		width: 100px;
		border : solid 1px;
		text-align: center;
	}
	.titleArea{
		width:500px;
		display: flex;
  		align-items: center;
		
	}
	.titleCut{
		max-width : 520px; white-space: nowrap; text-overflow:ellipsis; overflow:hidden;
	}

</style>
</head>
<body>
<%
		BoardItemDao boardItemDao = new BoardItemDaoImpl();
		List<BoardItem> showAll = boardItemDao.showList();
		//자바 클래스 & 메소드 호출
		BoardItemService boardItemService = new BoardItemServiceImpl();
		String currentDate = boardItemService.getCurrentDate(); // 현재 날짜 호출
%>
<script>
window.addEventListener('DOMContentLoaded', function() {
	  var titleCutElements = document.getElementsByClassName('titleCut');
	  var dateElements = document.getElementsByClassName('date');
	  var currentDate = "<%=currentDate%>";
	  
	  for (var i = 0; i < titleCutElements.length; i++) {
	    var element = titleCutElements[i];
	    var date = dateElements[i].textContent;
	    
	    if ((element.offsetWidth > 500) && (currentDate == date)) {
	      var nextElement = element.nextElementSibling;
	      nextElement.style.opacity = '1';
	    }
	  }
	});
</script>

	<div> 
		<table class='list'>
			<tr>
				<th class="num">번호</td>
				<th>제목</td>
				<th>날짜</td>
			</tr>
			<tbody>
			<%
				//목록 출력
				for (int i = 0; i < 10; i++) { 
					if (i >= boardItemDao.getTotalCount()) break;
					// 제목 댓글 및 새 글 표시
					String title = showAll.get(i).getTitle(); 
					
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
			%>
			<tr>
				<td class="num"><%=showAll.get(i).getId() %></td>
				<td class="title">
				<div class="titleArea">
						<a class="titleCut" style='border: none' href='View.jsp?key='<%=showAll.get(i).getId() %>'><%=title %></a>
						<img class="newIcon" src='./icon/new.png' style='border: none; width: 20px; height: 20px; margin-bottom: -5px; opacity: 0;'/></td>
				</div><td class="date"><%=showAll.get(i).getDate() %></td>
			</tr>
			<%} %>
			</tbody>
		</table>
	</div>
</body>
</html>