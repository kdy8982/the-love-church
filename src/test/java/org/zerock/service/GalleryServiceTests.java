package org.zerock.service;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.GalleryAttachVO;
import org.zerock.domain.GalleryVO;

import lombok.extern.log4j.Log4j;

@Log4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class GalleryServiceTests {

	@Autowired
	GalleryServiceImpl service;
	
	
	@Test
	public void testGetList() {
		List<GalleryVO> lists = service.getList();
		
		lists.forEach(list -> log.info(list));
	}
}
