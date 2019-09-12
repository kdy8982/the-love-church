package org.zerock.mapper;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.thelovechurch.domain.Criteria;
import org.thelovechurch.domain.ReplyVO;
import org.thelovechurch.mapper.ReplyMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {
	
	private Long[] bnoArr = {1048601L, 1048600L, 1048598L, 1048597L, 1048596L};
	
	 @Setter(onMethod_= @Autowired)
	private ReplyMapper mapper;


	@Test
	public void testMapper() {
		if(mapper == null) {
			log.info(mapper);
			log.info("널이네요");
		} else {
			log.info(mapper);
			log.info("널이 아니네요");
			
		}
	}

	 @Test
	 public void testCreate() {
		IntStream.rangeClosed(1, 10).forEach(i->{
			ReplyVO vo = new ReplyVO();
			log.info(bnoArr[i % 5]);
			vo.setBno(bnoArr[i % 5]);
			vo.setReply("댓글 테스트 " + i);
			vo.setReplyer("replyer " + i);
			
			mapper.insert(vo);
		}); 
	 }
	 
	 @Test
	 public void testRead() {
		 Long targetRno = 5L;
		 ReplyVO vo = mapper.read(1048601L);
		 log.info(vo);
	 }
	
	 @Test
	 public void testDelete() {
		 Long targetRno = 2L;
		 // log.info(mapper.delete(targetRno));
		 assertThat(mapper.delete(targetRno), is(1));
	 }
	 
	 @Test
	 public void testUpdate() {
		 Long targetRno = 5L;
		 ReplyVO vo = mapper.read(targetRno);
		 
		 log.info("원본 댓글 : " + vo.getReply());
		 
		 vo.setReply("수정수정수정");
		 
		 int count = mapper.update(vo);
		 log.info(count);
		 
		 vo = mapper.read(5L);
		 log.info("수정 후 댓글 : " + vo.getReply());
	 }
	 
	 
	@Test
	public void testList() {
		Criteria cri = new Criteria();
		List<ReplyVO> replies = mapper.getListWithPaging(cri, bnoArr[0]);
		replies.forEach(reply -> log.info(reply));
	}
	
	@Test
	public void testList2() {
		Criteria cri = new Criteria(2, 10);
		List<ReplyVO> replies = mapper.getListWithPaging(cri, 1048601L);
		replies.forEach(reply -> log.info(reply));
	}
	
	@Test
	public void testGetCountByBno() {
		int count = mapper.getCountByBno(1048601L);
		log.info(count);
	}

}
