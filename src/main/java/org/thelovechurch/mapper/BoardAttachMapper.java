package org.thelovechurch.mapper;

import java.util.List;

import org.thelovechurch.domain.BoardAttachVO;
import org.thelovechurch.domain.BoardVO;
import org.thelovechurch.domain.Criteria;

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
