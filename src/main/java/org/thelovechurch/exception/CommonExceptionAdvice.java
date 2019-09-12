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
	/*
	 * @ExceptionHandler(HttpRequestMethodNotSupportedException.class) public String
	 * notAllowedRequest(Exception ex, Model model) { log.error("Exception .... " +
	 * ex.getMessage()); model.addAttribute("exception", "올바르지 않은 요청입니다."); return
	 * "customNotAllowedRequest"; }
	 * 
	 * 
	 * @ExceptionHandler(Exception.class) public String except(Exception ex, Model
	 * model) { log.error("Exception .... " + ex.getMessage());
	 * model.addAttribute("exception", ex); log.error(model); return "error_page"; }
	 */
	/*
	 * @ExceptionHandler(NoHandlerFoundException.class)
	 * 
	 * @ResponseStatus(HttpStatus.NOT_FOUND) public String
	 * handle404(NoHandlerFoundException ex) { return "custom404"; }
	 */
	/*
	 * @ExceptionHandler(AccessDeniedException.class) public String
	 * accessDenied(AccessDeniedException ex, Model model) {
	 * log.info("call Access Denied Method Call...");
	 * model.addAttribute("exception", "권한이 없습니다."); return
	 * "customNotAllowedRequest"; }
	 */
}
