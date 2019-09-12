package org.thelovechurch.event;

import org.springframework.context.ApplicationEvent;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Log4j
public class UserAccountChangedEvent extends ApplicationEvent{
	private String userid;
	
	public UserAccountChangedEvent(Object source, String userid) {
		super(source);
		this.userid = userid;
	}

	public String getUserid() {
		return userid;
	}
}
