package org.zerock.service;

import java.util.List;

import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardService {
	public void register(BoardVO board);
	public BoardVO get(Long bno);
	public boolean modify(BoardVO board);
	public boolean remove(Long bno);
	public Object getList(Criteria cri);
	public int getTotal(Criteria cri);
	
	public List<BoardAttachVO> getAttachList(Long bno);
	public List<BoardAttachVO> getPreviewImg();
	
	public List<BoardVO> getNoticeList(Criteria cri);
	public int getTotalNotice(Criteria cri);
	public BoardVO getBoard(BoardVO board);
	
	public List<Integer> getPhotoCount(Criteria cri);
	
}
