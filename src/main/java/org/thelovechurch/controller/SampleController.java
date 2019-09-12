package org.thelovechurch.controller;

import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/sample")
public class SampleController {

	/* 스프링 시큐리티 샘플 컨트롤러*/
	@RequestMapping("/all")
	public void doAll() {
		log.info("do All");
	}
	
	@GetMapping("/member")
	public void doMember() {
		log.info("logined member");
	}
	
	@GetMapping("/admin")
	public void doAdmin() {
		log.info("admin only");
	}
	
	/* 애노테이션을 사용한 스프링 시큐리티 제어 ;  *주의 : security-context.xml 이 아닌, servlet-context.xml에서 설정을 해주어야 한다.*/
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@GetMapping("/annoMember")
	public void doMember2() {
		log.info("annoMember");
	}
	
	/* 애노테이션을 사용한 스프링 시큐리티 제어 ;  *주의 : security-context.xml 이 아닌, servlet-context.xml에서 설정을 해주어야 한다.*/
	 @Secured({"ROLE_ADMIN"})
	 @GetMapping("/annoAdmin")
	public void doAdmin2() {
		log.info("annoAdmin");
	}
	
}
