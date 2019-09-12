package org.zerock.mapper;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.thelovechurch.mapper.MemberMapper;
import org.zerock.domain.MemberVOTests;
import org.springframework.beans.factory.annotation.Autowired;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml"})
@Log4j
public class MemberMapperTests {
	
	
	@Setter(onMethod_=@Autowired)
	private MemberMapper memberMapper;
	
	
	@Test
	public void testMemberSelect() {
		MemberVOTests vo = memberMapper.read("admin90");
		log.info(vo);
		
		vo.getAuthList().forEach(authVO -> {
			log.info(authVO);
		});
	}
	
}
