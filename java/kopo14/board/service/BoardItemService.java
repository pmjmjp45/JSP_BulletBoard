package kopo14.board.service;

import java.sql.SQLException;
import java.util.Date;

import kopo14.board.dto.Pagination;

public interface BoardItemService {
	
	//페이지네이션
	Pagination getPagination(int page, int countPerPage);
	
	//현재 시간 
	String getCurrentDate();
}
