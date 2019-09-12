package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardAttachMapper {
	
	public void insert(BoardAttachVO vo);
	
	public int delete(String uuid);
	
	public void deleteAll(Long bno);
	
	public List<BoardAttachVO> findByBno(Long bno);

	public List<BoardAttachVO> getPreviewImg();
	
	public List<BoardVO> getPhotoList(Criteria cri);

	public List getPhotoCount(Criteria cri);
	
	public int getCount(BoardVO vo);
}
