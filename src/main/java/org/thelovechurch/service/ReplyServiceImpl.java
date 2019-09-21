package org.thelovechurch.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.thelovechurch.domain.Criteria;
import org.thelovechurch.domain.ReplyPageDTO;
import org.thelovechurch.domain.ReplyVO;
import org.thelovechurch.mapper.BoardMapper;
import org.thelovechurch.mapper.ReplyMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class ReplyServiceImpl implements ReplyService {

	@Setter(onMethod_= {@Autowired})
	private ReplyMapper mapper;

	@Setter(onMethod_= {@Autowired})
	private BoardMapper boardMapper;
	
	@Override
	public int register(ReplyVO vo) {
		log.info("register....." + vo);
		boardMapper.updateReplyCnt(vo.getBno(), 1); // board 객체에 replycnt 값을 update.
		
		return mapper.insert(vo);
	}

	@Override
	public ReplyVO get(Long rno) {
		return mapper.read(rno);
	}

	@Override
	public int modify(ReplyVO vo) {
		return mapper.update(vo);
	}

	@Override
	public int remove(ReplyVO vo) {
		log.info("reply remove call..!!");
		boardMapper.updateReplyCnt(vo.getBno(), -1);
		return mapper.update(vo);
	}

	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		return mapper.getListWithPaging(cri, bno);
	}

	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		return new ReplyPageDTO(mapper.getCountByBno(bno), mapper.getListWithPaging(cri, bno));
	}

	@Override
	public int registerRereply(ReplyVO vo) {
		vo.setParent(vo.getRno());
		boardMapper.updateReplyCnt(vo.getBno(), 1); // board 객체에 replycnt 값을 update.
		return mapper.insertRereply(vo);
	}

}
