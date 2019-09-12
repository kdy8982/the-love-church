package org.thelovechurch.event;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.EventListener;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.thelovechurch.security.CustomUserDetailService;
import org.thelovechurch.security.domain.CustomUser;

import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class UserAccountEventListener {

	@Autowired
	CustomUserDetailService customUserDetailService;
	
	@EventListener
	public void handleAccountChangedEvent(UserAccountChangedEvent event) {
		log.info("계정 정보 변경 확인 !!!!!");
		
		Authentication oldAuthentication = SecurityContextHolder.getContext().getAuthentication();

		UserDetails newPrincipal = (UserDetails) customUserDetailService.loadUserByUsername(event.getUserid()); 
		UsernamePasswordAuthenticationToken newAuth = new UsernamePasswordAuthenticationToken(newPrincipal, oldAuthentication.getCredentials(), newPrincipal.getAuthorities());
		newAuth.setDetails(oldAuthentication.getDetails());
		
		CustomUser user = (CustomUser) newAuth.getPrincipal(); // 프로필 사진이 담긴, Custom정보를 넘긴다. 
		
		SecurityContextHolder.getContext().setAuthentication(newAuth);
		
	}

}
