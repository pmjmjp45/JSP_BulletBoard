package kopo14.board.service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import java.text.SimpleDateFormat;

import kopo14.board.dao.*;
import kopo14.board.dto.*;

public class BoardItemServiceImpl implements BoardItemService {

	private BoardItemDao boardItemDao = new BoardItemDaoImpl(); // StudentItemDao의 객체 생성

	@Override
	public Pagination getPagination(int page, int countPerPage) {
		// 페이지네이션

		int totalCount = boardItemDao.getTotalCount(); // 총 데이터 수 호출
		
		int totalPage = totalCount / countPerPage; // 총 페이지 수
			if (totalCount % countPerPage != 0) { // 딱 떨어지지 않으면 1 더해야 함
				totalPage += 1;
			}
		
		int cPage = page; // 현재 페이지
			if (cPage <= 0) { // 0보다 작으면 1페이지 호출
				cPage = 1;
			} else if (cPage > totalPage) { // 총페이지보다 크면 총페이지 호출
				cPage = totalPage; 
			}
		
		int startPage = ((page - 1) / 10) * 10 + 1; // 페이지번호 시작
		
		int endPage = startPage + 9; // 페이지번호 끝
			if (endPage > totalPage) { // 총페이지보다 크면 총페이지 호출
				endPage = totalPage;
			}
		
		int nPage = endPage + 1; // >
			if (nPage > totalPage) { // 총페이지보다 크면 생성 안함
				nPage = -1;
			}
		
		int nnPage = totalPage; // >>
			
		int pPage = startPage - 10; // <
			if (pPage < 1) { // 1페이지보다 작으면 생성 안함
				pPage = -1;
			}
		
		int ppPage = 1; // <<
			if (cPage <= 10) { // 현재페이지 10페이지 이하라면 생성 안함
				ppPage = -1;
			}
		
		Pagination pagination = new Pagination(); // 생성자 호출하여 저장
		pagination.setC(cPage);
		pagination.setS(startPage);
		pagination.setE(endPage);
		pagination.setN(nPage);
		pagination.setNn(nnPage);
		pagination.setP(pPage);
		pagination.setPp(ppPage);
		pagination.setTotalCount(totalCount);
		pagination.setTotalPage(totalPage);
		
		return pagination;
	}

	@Override
	public String getCurrentDate() { // 오늘 날짜
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		return sdf.format(date);
	}

	

}
