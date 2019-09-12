package org.zerock.mapper;

import java.util.List;
import java.util.UUID;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.thelovechurch.domain.BoardAttachVO;
import org.thelovechurch.mapper.BoardAttachMapper;
import org.springframework.beans.factory.annotation.Autowired;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class BoardAttachMapperTests {

	
	@Setter(onMethod_= {@Autowired})
	BoardAttachMapper mapper;
	
	@Before
	public void setUp() {
		
		BoardAttachVO vo = new BoardAttachVO();
		vo.setUuid(UUID.randomUUID().toString());
		vo.setUploadPath("justTestPath1");
		vo.setFileName("justTestFileName1");
		vo.setFileType(true);
		vo.setAno(1L);
		
		BoardAttachVO vo2 = new BoardAttachVO();
		vo2.setUuid(UUID.randomUUID().toString());
		vo2.setUploadPath("justTestPath2");
		vo2.setFileName("justTestFileName2");
		vo2.setFileType(true);
		vo2.setAno(2L);
		mapper.insert(vo2);
	}
	
	@Test
	public void testInsert() {
		
		
	}
	
	@Test
	public void testDeleteAll() {
		log.info("deleteAll");
	}
	
	@Test
	public void testFindByBno() {
		List<BoardAttachVO> list = mapper.findByBno(1L);
		BoardAttachVO vo = list.get(1);
		log.info("testFindByBno");
		log.info(vo);
	}
}
