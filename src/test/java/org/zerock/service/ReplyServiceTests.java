package org.zerock.service;

import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.thelovechurch.domain.Criteria;
import org.thelovechurch.domain.ReplyVO;
import org.thelovechurch.service.ReplyService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;

import org.springframework.beans.factory.annotation.Autowired;

@RunWith(SpringJUnit4ClassRunner.class)
@Log4j
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class ReplyServiceTests {
	
	
	@Setter(onMethod_ = {@Autowired})
	private ReplyService replyService;
	
	@Test
	public void isNull() {
		assertNotNull(replyService);
		log.info(replyService);
	}
	
	@Test
	public void testRegister() {
		ReplyVO vo = new ReplyVO();
		
		vo.setBno(1048600L);
		vo.setReply("Reply Service Register Test 용 데이터 입니다");
		vo.setReplyer("헬로키티");
		
		log.info(replyService.register(vo));
	}
	
	@Test
	public void testGet() {
		Long targetRno = 3L;
		log.info(replyService.get(targetRno));
	}
	
	@Test
	public void testModify() {
		Long targetRno = 3L;
		ReplyVO vo = replyService.get(3L);
		vo.setReply("헬로키티헬로헬로");
		
		int count = replyService.modify(vo);
		log.info("UPDATE DATA : " + count);
	}
	
	@Test
	public void testRemove() {
		log.info(replyService.remove(3L));
		
	}
	
	@Test
	public void testGetList() {
		Criteria cri = new Criteria();
		replyService.getList(cri, 1048597L);
	}
	


}
