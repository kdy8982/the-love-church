package org.zerock.aop;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.zerock.exception.AjaxException;

import lombok.extern.log4j.Log4j;

@Aspect
@Log4j
@Component
public class ExceptionAdvcice {

	@AfterThrowing(pointcut = "execution(* org.zerock.controller.*Controller.*(..))", throwing="exception")
	public void ajaxException(Exception exception) {
		log.info("ajaxException method call.. ");
	    ServletRequestAttributes attr = (ServletRequestAttributes)RequestContextHolder.currentRequestAttributes();
	    HttpServletRequest request =  attr.getRequest();

	    if("true".equals(request.getHeader("AjaxCall"))) {
	    	log.info("ajax exception aop .. ");
	        throw new AjaxException("AjaxException 발생", exception);

	    }



	}
}
