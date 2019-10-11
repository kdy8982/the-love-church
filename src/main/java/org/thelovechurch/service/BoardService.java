package org.thelovechurch.service;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.List;

import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.thelovechurch.domain.BoardAttachVO;
import org.thelovechurch.domain.BoardVO;
import org.thelovechurch.domain.Criteria;

public interface BoardService {
	public void register(BoardVO board) throws GeneralSecurityException, IOException;
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
