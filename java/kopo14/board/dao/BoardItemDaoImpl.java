package kopo14.board.dao;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import kopo14.board.domain.BoardItem;

public class BoardItemDaoImpl implements BoardItemDao{

	@Override
	public List<BoardItem> showList() { // 목차 보기
		List<BoardItem> ret = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver"); //jdbc 드라이버 로딩
	        Connection conn = DriverManager.getConnection("jdbc:mysql://192.168.23.63:33060/kopo14", "root", "0405");
	        //데이터베이스와 연결
	        Statement stmt = conn.createStatement(); // 스테이트먼트 객체 생성
	        ResultSet rset = stmt.executeQuery("select * from board order by rootid desc, recnt;"); //실행문 결과 리절트셋에 저장 
	        
	        List<BoardItem> listAll = new ArrayList<>();
	        while(rset.next()) {
	    		BoardItem showAll = new BoardItem();
	    		showAll.setId(rset.getInt(1));
	    		showAll.setTitle(rset.getString(2));
	    		showAll.setDate(rset.getString(3));
	    		showAll.setRootid(rset.getInt(5));
	    		showAll.setRelevel(rset.getInt(6));
	    		showAll.setRecnt(rset.getInt(7));
	    		showAll.setViewcnt(rset.getInt(8));
	    		showAll.setStatus(rset.getInt(9));
	        	listAll.add(showAll);
	        }
	        rset.close();
	        stmt.close();
			conn.close();
			ret = listAll;
		} catch (Exception e) {
			e.getStackTrace();
		}
	
		return ret;
	}

	@Override
	public BoardItem showContent(int key) { // 글 보기
		
		BoardItem ret = null;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver"); //jdbc 드라이버 로딩
	        Connection conn = DriverManager.getConnection("jdbc:mysql://192.168.23.63:33060/kopo14", "root", "0405");
	        //데이터베이스와 연결
	        Statement stmt = conn.createStatement(); // 스테이트먼트 객체 생성
	        ResultSet rset = stmt.executeQuery("select * from board where id =" + key + ";"); //실행문 결과 리절트셋에 저장 
	        
	        BoardItem boardItem = new BoardItem();
	        while(rset.next()) {
	    		
	        	boardItem.setId(rset.getInt(1));
	        	boardItem.setTitle(rset.getString(2));
	        	boardItem.setDate(rset.getString(3));
	        	boardItem.setContent(rset.getString(4));
	        	boardItem.setRootid(rset.getInt(5));
	        	boardItem.setRelevel(rset.getInt(6));
	        	boardItem.setRecnt(rset.getInt(7));
	        	boardItem.setViewcnt(rset.getInt(8));
	        	boardItem.setStatus(rset.getInt(9));
	        }
	        rset.close();
	        stmt.close();
			conn.close();
			ret = boardItem;
			
		} catch (Exception e) {
			e.getStackTrace();
		}
		return ret;
	}

	@Override
	public BoardItem writeNew(int key, String title, String content, int rootid, int relevel, int recntFormer) {//새글쓰기, 수정
		BoardItem ret = null;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver"); //jdbc 드라이버 로딩
	        Connection conn = DriverManager.getConnection("jdbc:mysql://192.168.23.63:33060/kopo14", "root", "0405");
	        //데이터베이스와 연결
	        Statement stmt = conn.createStatement(); // 스테이트먼트 객체 생성
	        
	        String sql_addcnt = "";
	        String sql_insert = "";
	        String sql_select = "";
	        
	        if (key == -1) { // 새 원글
	        	
	        	String sql_ins = "insert into board (title, date, content, rootid, relevel, recnt, viewcnt) values ('" 
						+ title + "', curdate(), '" + content 
						+ "', -1, 0, 0, 0);";
	        	stmt.execute(sql_ins);
	        	
	        	int lastId = 0;
	        	ResultSet rset_id = stmt.executeQuery("SELECT last_insert_id();");
	        	while(rset_id.next()) {
	        		lastId = rset_id.getInt(1);
	        	}
	        	rset_id.close();
	        	
	        	sql_insert = "update board set rootid =" + lastId + " where id =" + lastId +";";
		        sql_select = "select * from board where id = (select max(id) from board);";
	        } else if (key == -2) { // 댓글
	        	sql_addcnt = "update board set recnt = (recnt + 1) where rootid =" + rootid + " and recnt > " + recntFormer + ";";
	        	sql_insert = "insert into board (title, date, content, rootid, relevel, recnt, viewcnt) values ('" 
						+ title + "', curdate(), '" + content 
						+ "'," + rootid + "," + relevel 
						+ ", " + (recntFormer + 1) + ", 0);";
		        
		        sql_select = "select * from board where id = (select max(id) from board);";
		        stmt.execute(sql_addcnt);
	        } else { // 글 수정
	        	sql_insert = "update board set title ='" + title + "', date = curdate(), content = '" + content + "' where id =" + key + ";";
		        
		        sql_select = "select * from board where id =" + key + ";";
	        	
	        }
	        stmt.execute(sql_insert);
	        ResultSet rset = stmt.executeQuery(sql_select); //실행문 결과 리절트셋에 저장 

			BoardItem boardItem = new BoardItem();
	        while(rset.next()) {
	        	boardItem.setId(rset.getInt(1));
	        	boardItem.setTitle(rset.getString(2));
	        	boardItem.setDate(rset.getString(3));
	        	boardItem.setContent(rset.getString(4));
	        	boardItem.setRootid(rset.getInt(5));
	        	boardItem.setRelevel(rset.getInt(6));
	        	boardItem.setRecnt(rset.getInt(7));
	        	boardItem.setViewcnt(rset.getInt(8));
	        }
	        rset.close();
	        stmt.close();
			conn.close();
			ret = boardItem;
	       
		} catch (Exception e) {
			e.getStackTrace();
		}
		return ret;
	}

	@Override
	public boolean delete(int key, int relevel) { //삭제
		String query = "";
		if (relevel == 0) { // 원글일 경우 댓글까지 모두 삭제
			query = "delete from board where rootid =" + key + ";";
		} else { // 댓글일 경우 그 댓글만 읽지 못하게 막음
			query = "update board set status = -1 where id =" + key + ";";
		}
		try {
			Class.forName("com.mysql.cj.jdbc.Driver"); //jdbc 드라이버 로딩
	        Connection conn = DriverManager.getConnection("jdbc:mysql://192.168.23.63:33060/kopo14", "root", "0405");
	        //데이터베이스와 연결
	        Statement stmt = conn.createStatement(); // 스테이트먼트 객체 생성
	        stmt.execute(query);

	        stmt.close();
			conn.close();
			
			return true; 
		} catch (Exception e) {
			e.getStackTrace();
			return false;
		}
	}

	@Override
	public int getTotalCount() { // 총 데이터 수
		int ret = 0;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver"); //jdbc 드라이버 로딩
	        Connection conn = DriverManager.getConnection("jdbc:mysql://192.168.23.63:33060/kopo14", "root", "0405");
	        //데이터베이스와 연결
	        Statement stmt = conn.createStatement(); // 스테이트먼트 객체 생성
	        ResultSet rset = stmt.executeQuery("select count(*) from board;"); //실행문 결과 리절트셋에 저장 
	        		
	        while(rset.next()) {
	        	ret = rset.getInt(1);
	        }
	        
	        rset.close();
	        stmt.close();
			conn.close();
			 
		} catch (Exception e) {
			e.getStackTrace();
		
		}
		return ret;
	}
	@Override
	public void addViewCount(int id) { // 방문자수
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver"); //jdbc 드라이버 로딩
	        Connection conn = DriverManager.getConnection("jdbc:mysql://192.168.23.63:33060/kopo14", "root", "0405");
	        //데이터베이스와 연결
	        Statement stmt = conn.createStatement(); // 스테이트먼트 객체 생성
	        stmt.execute("update board set viewcnt = 1 + ifnull(viewcnt,0) where id=" + id + ";"); //실행문 결과 리절트셋에 저장 
	        
	        stmt.close();
			conn.close();
			
		} catch (Exception e) {
			e.getStackTrace();
		}
	}

}
