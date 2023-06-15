package kopo14.board.dao;
import java.sql.SQLException;
import java.util.*;
import kopo14.board.domain.BoardItem;

public interface BoardItemDao {
	
	List<BoardItem> showList();
	BoardItem showContent(int key);
	BoardItem writeNew(int key, String title, String content, int rootid, int relevel, int recntFormer);
	boolean delete(int key, int relevel);
	int getTotalCount();
	//방문자 카운터
	void addViewCount(int id);
}
