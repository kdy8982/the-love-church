package org.thelovechurch.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.thelovechurch.domain.GalleryVO;
import org.thelovechurch.service.GalleryService;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/gallery/*")
public class GalleryController {
	
	@Autowired
	GalleryService galleryService;
	
	@GetMapping("list")
	public void list(Model model) {
		model.addAttribute("galleryList", galleryService.getList());
		log.info("/gallery/list call...");
	}
	
	/* 게시글 등록 */
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/register")
	public String register (GalleryVO gallery , RedirectAttributes rttr) { // 리다이렉트 시키면서, 화면에 결과를 RedirectAttributes로 넘긴다.
		log.info("gallery register ... ");
		log.info(gallery);
		
		
		galleryService.register(gallery);
		
		
		// if DB등록에 성공하면 ..
		rttr.addFlashAttribute("result", "success"); 
		
		return "redirect:/gallery/list";
	}

}
