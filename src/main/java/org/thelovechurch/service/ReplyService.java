package org.thelovechurch.service;

import java.util.List;

import org.thelovechurch.domain.Criteria;
import org.thelovechurch.domain.ReplyPageDTO;
import org.thelovechurch.domain.ReplyVO;

public interface ReplyService {
	public int register(ReplyVO vo);
	public ReplyVO get(Long rno);
	public int modify(ReplyVO vo);
	public int remove(ReplyVO vo);
	public List<ReplyVO> getList(Criteria cri, Long bno);
	public ReplyPageDTO getListPage(Criteria cri, Long bno);
	public int registerRereply(ReplyVO vo);
}
