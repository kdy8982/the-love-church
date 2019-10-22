package org.thelovechurch.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

/* SpringMVC를 구성할 때 필요한 Bean 설정들을 자동으로 해주는 애노테이션 ; <mvc:annotation-driven /> */
@EnableWebMvc
/* @Component, @Controller, @Service 애노테이션을 자동으로 스프링 Bean으로 등록함 */
@ComponentScan(basePackages = {"org.thelovechurch.controller, org.thelovechurch.exception"})
/* 애노테이션 기반 MethodSecurity 사용 */
@EnableGlobalMethodSecurity(prePostEnabled = true, securedEnabled = true)
public class ServletConfig implements WebMvcConfigurer{
	
	/* 뷰 리졸버 지정. URL로 경로를 주면, 해당 위치의 JSP파일을 읽음 */
	@Override
	public void configureViewResolvers(ViewResolverRegistry registry) {
	    InternalResourceViewResolver bean = new InternalResourceViewResolver();
	    bean.setViewClass(JstlView.class);
	    bean.setPrefix("/WEB-INF/views/");
	    bean.setSuffix(".jsp");
	    registry.viewResolver(bean);
	}
	
	/* 정적 resource 파일 위치 지정 */
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/resources/**").addResourceLocations("/resources/");
	}

	/* 멀티파트 리졸버 지정 */
	@Bean
	public MultipartResolver multipartResolver() {
		StandardServletMultipartResolver resolver = new StandardServletMultipartResolver();
		return resolver;
	}
	
}
