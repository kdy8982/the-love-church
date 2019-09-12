package org.thelovechurch.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.thelovechurch.domain.Criteria;
import org.thelovechurch.domain.ReplyVO;


public interface ReplyMapper {

	public int insert(ReplyVO vo);
	public ReplyVO read(Long rno); 
	public int delete(Long rno);
	public int update(ReplyVO vo);
	public List<ReplyVO> getListWithPaging(@Param("cri")Criteria cri, @Param("bno")Long bno);
	public int getCountByBno(Long bno);
	public int insertRereply(ReplyVO vo);
}
