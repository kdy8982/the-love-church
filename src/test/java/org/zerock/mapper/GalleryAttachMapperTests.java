package org.zerock.mapper;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.thelovechurch.mapper.GalleryAttachMapper;
import org.springframework.beans.factory.annotation.Autowired;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class GalleryAttachMapperTests {
	
	@Setter(onMethod_={@Autowired})
	GalleryAttachMapper mapper;
	
	@Test
	public void testSelectList(){
		log.info("select test ... ");
		mapper.getGalleryList();
	}
	
}
