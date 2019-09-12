package org.zerock.event;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.ApplicationEventPublisherAware;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class TestService  {
	
	@Autowired
	private ApplicationEventPublisher eventPublisher;
	

	
	public ApplicationEventPublisher getEventPublisher() {
		return eventPublisher;
	}

	public void testMethod() {
		log.info("메소드 진행 시작..");
		log.info("이벤트 발생 직전..");	
		
		UserAccountChangedEvent event = new UserAccountChangedEvent(this, "HI");
		eventPublisher.publishEvent(event);
		
		log.info("이벤트 발생 직후..");
		
		return;
	}



}
