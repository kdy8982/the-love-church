package org.thelovechurch.service;

import java.util.List;

import org.thelovechurch.domain.AuthVO;
import org.thelovechurch.domain.MemberVO;

public interface MemberService {
	
	public MemberVO get(MemberVO vo);
	public List<MemberVO> getList();
	
	public boolean insert(MemberVO vo);
	public boolean changePassword(MemberVO vo, String newpw);
	public void changeProfilePhoto(MemberVO vo);
	
	public boolean grantAuth(AuthVO authVO);
	
	public int checkIdIsSigned(String userid);
	public int checkEmailIsSigned(String userid);
	
}
