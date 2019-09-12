package org.thelovechurch.exception;

public class AjaxException extends RuntimeException {

	public AjaxException() {
		super();
	}
	
	public AjaxException(String message) {
		super(message);
	}
	
	public AjaxException(String message, Throwable cause) {
		super(message, cause);
	}
}
