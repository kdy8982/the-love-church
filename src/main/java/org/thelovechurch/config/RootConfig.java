package org.thelovechurch.config;

import java.util.Properties;

import javax.sql.DataSource;

import org.apache.commons.dbcp.BasicDataSource;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.core.io.Resource;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

import net.sf.log4jdbc.Log4jdbcProxyDataSource;
import net.sf.log4jdbc.tools.Log4JdbcCustomFormatter;
import net.sf.log4jdbc.tools.LoggingType;

@Configuration
@ComponentScan(basePackages = {"org.thelovechurch.service", "org.thelovechurch.aop", "org.thelovechurch.event", "org.thelovechurch.task"})
@MapperScan(basePackages = {"org.thelovechurch.mapper"})
@EnableTransactionManagement
@EnableAspectJAutoProxy
@EnableScheduling
@PropertySource(
        value={"classpath:properties/application.properties"},
        ignoreResourceNotFound = true)
public class RootConfig {
	
	@Bean 
	public BasicDataSource basicDataSource() {
		BasicDataSource basicDataSource = new BasicDataSource();
		basicDataSource.setDriverClassName("com.mysql.jdbc.Driver");
		basicDataSource.setUrl("jdbc:mysql://localhost:3306/thesarang");
		basicDataSource.setUsername("root");
		basicDataSource.setPassword("1234");
		return basicDataSource;
	}
	
	
	@Bean
	public Log4jdbcProxyDataSource dataSource(BasicDataSource basicDataSource) {
		Log4jdbcProxyDataSource log4jdbcProxyDataSource = new Log4jdbcProxyDataSource(basicDataSource);
		
		Log4JdbcCustomFormatter log4JdbcCustomFormatter = new Log4JdbcCustomFormatter();
		log4JdbcCustomFormatter.setLoggingType(LoggingType.MULTI_LINE);
		log4JdbcCustomFormatter.setSqlPrefix("SQL : \n");

		log4jdbcProxyDataSource.setLogFormatter(log4JdbcCustomFormatter);
		
		return log4jdbcProxyDataSource;
	}
	
	@Bean 
	public SqlSessionFactoryBean sqlSessionFactoryBean(DataSource dataSource) {
		
		SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
		sqlSessionFactoryBean.setDataSource(dataSource);
		
		return sqlSessionFactoryBean;
	}
	
	@Bean
	public DataSourceTransactionManager dataSourceTransactionManager(DataSource dataSource) {
		DataSourceTransactionManager dataSourceTransactionManager = new DataSourceTransactionManager();
		dataSourceTransactionManager.setDataSource(dataSource);
		return dataSourceTransactionManager;
	}
	
	@Bean
	public SimpleMappingExceptionResolver simpleMappingExceptionResolver() {
		
		SimpleMappingExceptionResolver simpleMappingExceptionResolver = new SimpleMappingExceptionResolver();
		simpleMappingExceptionResolver.setDefaultErrorView("exception/error_page");
		simpleMappingExceptionResolver.setDefaultStatusCode(200);
		simpleMappingExceptionResolver.setExceptionAttribute("exception");
		
		Properties properties = new Properties();
		properties.setProperty("AccessDeniedException", "exception/customNotAllowedRequest");
		properties.setProperty("NoHandlerFoundException", "exception/custom404");
		simpleMappingExceptionResolver.setExceptionMappings(properties);
		
		Properties statusProperties = new Properties();
		statusProperties.setProperty("exception/customNotAllowedRequest", "403");
		statusProperties.setProperty("exception/custom404", "404");
		simpleMappingExceptionResolver.setStatusCodes(statusProperties);
		
		return simpleMappingExceptionResolver;
	}
	
    @Bean
    public static PropertySourcesPlaceholderConfigurer propertyConfigurer() {
       return new PropertySourcesPlaceholderConfigurer();
    }
}
