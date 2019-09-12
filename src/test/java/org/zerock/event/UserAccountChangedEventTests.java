package org.zerock.event;

import static org.junit.Assert.assertThat;
import static org.hamcrest.Matchers.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml", "file:src/main/webapp/WEB-INF/spring/security-context.xml"})
@Log4j
public class UserAccountChangedEventTests {
	
	@Autowired
	TestService service;
	
	@Test
	public void test() {
		assertThat(service.getEventPublisher(), is(notNullValue()));
		service.testMethod();
		
	}
	
}
