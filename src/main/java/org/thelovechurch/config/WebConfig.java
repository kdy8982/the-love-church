package org.thelovechurch.config;


import javax.servlet.Filter;
import javax.servlet.MultipartConfigElement;
import javax.servlet.ServletRegistration;

import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class WebConfig extends AbstractAnnotationConfigDispatcherServletInitializer {

	/* root, 스프링 시큐리티 설정파일 지정 */
	@Override
	protected Class<?>[] getRootConfigClasses() {
		return new Class[] { RootConfig.class, SecurityConfig.class };
	}
	
	/* 서블릿 관련 자바 설정파일 지정 */
	@Override
	protected Class<?>[] getServletConfigClasses() {
		return new Class[] { ServletConfig.class };
	}

	/* 서블릿 매핑 지정 */
	@Override
	protected String[] getServletMappings() {
		return new String[] { "/" };
	}

	// @Override
	// protected void customizeRegistration(ServletRegistration.Dynamic
	// registration) {
	//
	// registration.setInitParameter("throwExceptionIfNoHandlerFound", "true");
	//
	// }

	/* 인코딩 설정 */
	@Override
	protected Filter[] getServletFilters() {
		CharacterEncodingFilter characterEncodingFilter = new CharacterEncodingFilter();
		characterEncodingFilter.setEncoding("UTF-8");
		characterEncodingFilter.setForceEncoding(true);

		return new Filter[] { characterEncodingFilter };
	}

	/* 멀티파트 설정 */
	@Override
	protected void customizeRegistration(ServletRegistration.Dynamic registration) {

		registration.setInitParameter("throwExceptionIfNoHandlerFound", "true");

		MultipartConfigElement multipartConfig = new MultipartConfigElement("\\", 20971520, 41943040,
				20971520);
		registration.setMultipartConfig(multipartConfig);

	}

}
