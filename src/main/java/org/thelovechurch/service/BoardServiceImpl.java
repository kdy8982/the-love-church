package org.thelovechurch.service;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.thelovechurch.domain.BoardAttachVO;
import org.thelovechurch.domain.BoardVO;
import org.thelovechurch.domain.Criteria;
import org.thelovechurch.google.DriveQuickstart;
import org.thelovechurch.mapper.BoardAttachMapper;
import org.thelovechurch.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor // 해당 클래스의 생성자를 만들때, 등록된 필드를 주입받게 만든다.
public class BoardServiceImpl implements BoardService {
	
	private BoardMapper mapper;
	private BoardAttachMapper attachMapper;

	@Transactional
	@Override
	public void register(BoardVO board) throws GeneralSecurityException, IOException {
		log.info("register......" + board);
		
		mapper.insertSelectKey(board);
		log.info(board);
		
		if(board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}
		
		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}
	
	@Override
	public Object getList(Criteria cri) {
		if(cri.getBoardType() == "notice" || cri.getBoardType() == null) {
			log.info("getList.. - notice or all");
			log.info(cri);
			return mapper.getListWithPaging(cri);
		} else if (cri.getBoardType() == "photo" || cri.getBoardType() == "essay") {
			
			List<BoardVO> list =  attachMapper.getPhotoList(cri);
			/*
			 * for(BoardVO vo : list) { vo.setPhotoCnt(attachMapper.getCount(vo)); }
			 * 
			 */
			return list;
		}
		return null;
		
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get........");
		return mapper.read(bno);
	}

	@Override
	public boolean remove(Long bno) {
		attachMapper.deleteAll(bno);
		return mapper.delete(bno) == 1;
	}
	
	
	@Transactional // 등록된 첨부파일(attach)을 모두 지운 뒤, 게시글(board)을 update한다. 만일 첨부파일을 지우다가 에러가 나면 롤백시킨다.
	@Override
	public boolean modify(BoardVO board) {
		log.info("modify..........." + board);
		attachMapper.deleteAll(board.getBno());
		
		boolean modifyResult = mapper.update(board) == 1;
		
		if (board.getAttachList() != null) {
			if(modifyResult && board.getAttachList().size() > 0) {
				board.getAttachList().forEach(attach -> {
					attach.setBno(board.getBno());
					log.info("attach : ");
					log.info(attach);
					attachMapper.insert(attach);
				});
			}
		} 
		return modifyResult;
	}

	@Override
	public int getTotal(Criteria cri) {
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {

		log.info("get Attach list by bno" + bno);
		
		return attachMapper.findByBno(bno);
	}

	@Override
	public List<BoardAttachVO> getPreviewImg() {
		log.info("get Preview Img...");
		return attachMapper.getPreviewImg();
	}

	
	@Override
	public List<BoardVO> getNoticeList(Criteria cri) {
		log.info("get Notice List...");
		log.info(cri.getPageNum());
		log.info(cri.getAmount());
		return mapper.getNoticeList(cri);
	}
	
	@Override
	public int getTotalNotice(Criteria cri) {
		log.info("get Notice Total...");
		log.info(cri.getPageNum());
		log.info(cri.getAmount());
		
		return mapper.getTotalNoticeCount(cri);
	}

	@Override
	public BoardVO getBoard(BoardVO board) {
		return mapper.getBoard(board);
	}

	@Override
	public List<Integer> getPhotoCount(Criteria cri) {
		return attachMapper.getPhotoCount(cri);
	}


}
