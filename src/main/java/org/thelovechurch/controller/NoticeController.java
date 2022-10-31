package org.thelovechurch.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.GeneralSecurityException;
import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.thelovechurch.domain.BoardAttachVO;
import org.thelovechurch.domain.BoardVO;
import org.thelovechurch.domain.Criteria;
import org.thelovechurch.domain.PageDTO;
import org.thelovechurch.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping(value = { "/notice/*" })
@AllArgsConstructor
public class NoticeController {

	private BoardService boardService;

	@RequestMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("Notice controller list call..");
		cri.setBoardType("notice");
		cri.calcStartEndNum();
		model.addAttribute("noticeList", boardService.getList(cri));

		int total = boardService.getTotalNotice(cri); // 페이징 처리를 위해, 전체 공지글 수를 구한다.
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}

	@GetMapping("/get")
	public void get(BoardVO board, Model model, @ModelAttribute("cri") Criteria cri) {
		log.info("Notice controller get call..");

		model.addAttribute("notice", boardService.getBoard(board));
	}

	@GetMapping("/register")
	public void get(BoardVO board) {
		log.info("Notice controller register get call..");
	}

	@PostMapping("/register")
	public String insert(BoardVO board) throws GeneralSecurityException, IOException {
		log.info("Notice controller register post call..");
		boardService.register(board);

		return "redirect:/notice/list";
	}

	@RequestMapping("/delete")
	public String delete(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("delete call....!!");

		//파일 첨부 기능 주석처리
		//List<BoardAttachVO> attachList = boardService.getAttachList(bno);

		if (boardService.remove(bno)) {
			//deleteFiles(attachList);
			rttr.addAttribute("result", "success");
		}

		return "redirect:/notice/list" + cri.getListLink();
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.POST })
	@PreAuthorize("#vo.writer == principal.username")
	public void modify(BoardVO vo, Model model, @ModelAttribute("cri") Criteria cri) {
		log.info("Notice controller modify call..");

		model.addAttribute("notice", boardService.getBoard(vo));
	}

	@RequestMapping(value = "/modifySubmit", method = { RequestMethod.POST })
	@PreAuthorize("#vo.writer == principal.username")
	public String modifySubmit(BoardVO vo, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify submit post call..!!");

		if (boardService.modify(vo)) {
			rttr.addFlashAttribute("result", "success");
		}
		;

		return "redirect:/notice/list" + cri.getListLink();

	}

	private void deleteFiles(List<BoardAttachVO> attachList) {
		if (attachList == null || attachList.size() == 0) {
			return;
		}

		attachList.forEach(attach -> {
			try {
				Path file = Paths.get(
						"C:\\upload\\" + attach.getUploadPath() + "\\" + attach.getUuid() + "_" + attach.getFileName());

				Files.deleteIfExists(file);
				if (Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\s_" + attach.getUuid() + "_"
							+ attach.getFileName());
					Files.delete(thumbNail);
				}
			} catch (Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		});

	}

}
