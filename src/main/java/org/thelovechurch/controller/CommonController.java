package org.thelovechurch.controller;

import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.thelovechurch.domain.MemberVO;
import org.thelovechurch.event.UserAccountChangedEvent;
import org.thelovechurch.security.CustomUserDetailService;
import org.thelovechurch.service.MemberService;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class CommonController {

	@Autowired
	MemberService memberService;

	@Autowired
	CustomUserDetailService customUserDetailService;

	@RequestMapping("/accessError")
	public void accessDenied(Authentication auth, Model model) {

		log.info("access Denied : " + auth);

		model.addAttribute("msg", "Access Denied");
	}

	@GetMapping("/customLogin")
	public void login(String error, String logout, Model model) {
		log.info("error : " + error);
		log.info("logout: " + logout);

		if (error != null) {
			model.addAttribute("error", "아이디와 비밀번호를 확인해주세요.");
		}

		if (logout != null) {
			model.addAttribute("logout", "Logout!!");
		}
	}

	@RequestMapping(value = "/customLogout", method = { RequestMethod.GET })
	public void logout() {
		log.info("custom logout page load.");
	}

	@RequestMapping(value = "/customLogout", method = { RequestMethod.POST })
	public void logoutPost() {
		log.info("post custom logout!!");
	}

	@RequestMapping(value = "/customSignup", method = { RequestMethod.GET, RequestMethod.POST })
	public String signUp(MemberVO vo, HttpServletRequest request, RedirectAttributes rttr) {
		log.info("sign up call .. ");
		log.info("요청 type : " + request.getMethod());

		if (request.getMethod().equals("POST")) {
			if (memberService.insert(vo)) {
				rttr.addFlashAttribute("result", "회원 가입에 성공하였습니다. 환영합니다.");
				return "redirect:/customLogin";
			}
			;
		}
		return "/customSignup";
	}

	@PreAuthorize("isAuthenticated() and principal.username == #vo.userid")
	@RequestMapping(value = "/memberDetail", method = { RequestMethod.GET })
	public void memberDetail(MemberVO vo, Model model) throws UnsupportedEncodingException {
		log.info("member detail call ..");
		// MemberVO getVo = memberService.get(vo);
		// getVo.setThumbPhoto();
		// model.addAttribute("member", getVo);

	}

	@RequestMapping(value = "/memberPhotoModify", method = { RequestMethod.POST })
	public String memberPhotoModify(MemberVO vo, RedirectAttributes rttr) {
		log.info("memberPhotoModify call ..");
		memberService.changeProfilePhoto(vo);

		rttr.addFlashAttribute("result", "성공적으로 처리되었습니다.");

		return "redirect:/memberDetail?userid=" + vo.getUserid();

	}

	@RequestMapping(value = "/memberPasswordModify", method = { RequestMethod.POST })
	public String memberPasswordModify(MemberVO vo, String newpw, RedirectAttributes rttr) {
		log.info("memberPasswordModify call ..");

		if (memberService.changePassword(vo, newpw)) {
			rttr.addFlashAttribute("result", "성공적으로 처리되었습니다.");
		} else {
			rttr.addFlashAttribute("result", "비밀번호가 틀렸습니다.");
		}

		return "redirect:/memberDetail?userid=" + vo.getUserid();

	}

	@RequestMapping(value = "/memberPhotoPasswordModify", method = { RequestMethod.POST })
	public String memberPhotoPasswordModify(MemberVO vo, String newpw, RedirectAttributes rttr) {
		log.info("memberPhotoPasswordModify call ..");

		memberService.changeProfilePhoto(vo);

		if (memberService.changePassword(vo, newpw)) {
			rttr.addFlashAttribute("result", "성공적으로 처리되었습니다.");
		} else {
			rttr.addFlashAttribute("result", "비밀번호가 틀렸습니다.");
		}

		return "redirect:/memberDetail?userid=" + vo.getUserid();
	}

	@ResponseBody
	@RequestMapping(value = "/checkIdIsSigned", method = { RequestMethod.POST })
	public int checkIdIsSigned(MemberVO vo) {
		log.info("checkIdIsSigned call ..");
		return memberService.checkIdIsSigned(vo.getUserid()); // 없는 아이디면(가입 가능하면) true, 이미 존재하는 아이디면 false
	}
	
	@ResponseBody
	@RequestMapping(value = "/checkEmailIsSigned", method = { RequestMethod.POST })
	public int checkEmailIsSigned(MemberVO vo) {
		log.info("checkEmailIsSigned call ..");
		return memberService.checkEmailIsSigned(vo.getUseremail()); // 없는 아이디면(가입 가능하면) true, 이미 존재하는 아이디면 false
	}
	/* 스프링 시큐리티 암호 체크 방식 테스트용 메서드 */
	/*
	 * @RequestMapping(value="/checkBcrypt", method= {RequestMethod.GET,
	 * RequestMethod.POST}) public void checkBcrypt(@RequestParam(value="targetStr",
	 * required=false) String targetStr) { log.info("check Bcrypt!!!!");
	 * 
	 * if(StringUtils.hasText(targetStr)) { String bCrtyptString =
	 * passwordEncoder.encode(targetStr);
	 * 
	 * log.info("targetStr : " + targetStr); log.info("bCrtyptString : " +
	 * bCrtyptString); log.info(passwordEncoder.matches(targetStr,
	 * "$2a$10$vqsyLHb7CG.3JUMY9/R6PO4BA0dyfSA.QPDGWqR4nwRKf7iu8jv36")); } }
	 */

}
