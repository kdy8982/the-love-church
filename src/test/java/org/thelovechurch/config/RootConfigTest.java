package org.thelovechurch.config;

import static org.junit.Assert.fail;

import java.sql.Connection;

import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.thelovechurch.service.SampleService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes =  {RootConfig.class, SecurityConfig.class})
@Log4j
public class RootConfigTest {

	@Setter(onMethod_ = {@Autowired})
	private DataSource dataSource;
	
	@Autowired
	private DataSourceTransactionManager dataSourceTransactionManager;
	
	@Autowired 
	private SampleService service;
	
	
	@Test
	public void testConnection() {
		try (Connection con = dataSource.getConnection()){
			log.info(con);
		} catch (Exception e) {
			fail(e.getMessage());
		}
	}
	
	@Test
	public void testDataSourceTransactionManager() {
		log.info(dataSourceTransactionManager);
	}
	
	@Test
	public void testClass() {
		log.info(service);
		log.info(service.getClass().getName());
	}
	
	@Test
	public void testAdd() throws Exception {
		log.info(service.doAdd("123", "456"));
	}

}
