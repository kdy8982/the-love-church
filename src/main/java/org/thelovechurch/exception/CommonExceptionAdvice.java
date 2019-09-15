package org.thelovechurch.exception;

import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.ui.Model;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;

import lombok.extern.log4j.Log4j;

@ControllerAdvice
@Log4j
public class CommonExceptionAdvice {
	@ExceptionHandler(Exception.class)
	public String except(Exception ex, Model model) {
		log.error("Exception .... " + ex.getMessage());
		model.addAttribute("exception", ex);
		log.error(model);
		return "exception/error_page";
	}

	/** 별도로 web.xml에 throwExceptionIfNoHandlerFound를 설정하였다.**/
	@ExceptionHandler(NoHandlerFoundException.class)
	@ResponseStatus(HttpStatus.NOT_FOUND)
	public String handle404(NoHandlerFoundException ex, Model model) {
		log.error("Exception .... " + ex.getMessage());
		model.addAttribute("exception", "페이지를 찾을 수 없습니다.");
		return "exception/custom404";
	}

	@ExceptionHandler(HttpRequestMethodNotSupportedException.class)
	@ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
	public String notAllowedRequest(Exception ex, Model model) {
		log.error("Exception .... " + ex.getMessage());
		model.addAttribute("exception", "올바르지 않은 요청입니다.");
		return "exception/customNotAllowedRequest";
	}


	@ExceptionHandler(AccessDeniedException.class)
	@ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
	public String accessDenied(AccessDeniedException ex, Model model) {
		log.info("call Access Denied Method Call...");
		model.addAttribute("exception", "권한이 없습니다.");
		return "exception/customNotAllowedRequest";
	}
}
