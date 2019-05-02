package com.project.board;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.board.entities.Board;
import com.project.board.entities.BoardPaging;
import com.project.board.entities.BoardReply;
import com.project.board.entities.UploadFileVO;
import com.project.board.service.BoardDao;
import com.project.board.service.Coolsms;

@Controller
public class BoardController {
	@Autowired
	private SqlSession sqlSession;
	@Autowired
	private Board board;
	private BoardReply boardreply;
	@Autowired
	private BoardPaging boardpaging;
	@Autowired
	private UploadFileVO uploadfilevo;
	static String find;
	static String category;
	
	@RequestMapping(value = "/boardinsertform", method = RequestMethod.GET)
	public String boardInsertForm() {
		return "board/board_insert_form";
	}
	@RequestMapping(value = "/boardinsert", method = RequestMethod.POST)
	public String boardInsert(Model model, @ModelAttribute Board board, HttpServletRequest request, MultipartHttpServletRequest mtfRequest) throws UnsupportedEncodingException {
		List<MultipartFile> fileList = mtfRequest.getFiles("file");

//		String originalname = file.getOriginalFilename();
		String path = "C:\\Users\\abc\\Documents\\board\\board\\src\\main\\webapp\\resources\\file\\";
//		if(originalname.equals("")) {
//		}else {
////			String realpath = "resources/file/";
//			try {
//				byte bytes[] = file.getBytes();
//				BufferedOutputStream output = new BufferedOutputStream(new FileOutputStream(path+originalname));
//				output.write(bytes);
//				output.flush();
//				output.close();
//				board.setattach(originalname);
//			}catch (Exception e) {
//				
//			}
//		}


		board.setip(request.getRemoteAddr());
		board.setname(board.getname().trim());
		board.settitle(board.gettitle().trim());
		Date date = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		board.setdate(format.format(date));
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		try {
//			String encodingPassword = passwordEncoder.encode(board.getPassword());
//			board.setPassword(encodingPassword);
			int result = dao.insertRow(board);
		}catch (Exception e) {
		}
		for (MultipartFile mf : fileList) {
			String originFileName = mf.getOriginalFilename(); // 원본 파일 명
			originFileName = new String(originFileName.getBytes("8859_1"), "UTF-8");
			long fileSize = mf.getSize(); // 파일 사이즈
			if(fileSize != 0) {
				String safeFile = path + System.currentTimeMillis() + originFileName;
				uploadfilevo.setFile_name(originFileName);
				uploadfilevo.setFile_size(fileSize);
				int maxseq = dao.selectMaxSeq();
				uploadfilevo.setArticle_num(maxseq);
				dao.uploadFile(uploadfilevo);
				try {
					mf.transferTo(new File(safeFile));
				} catch (IllegalStateException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
		}
		return "redirect:boardpagelist";
	}
	@RequestMapping(value = "/boardpagelist", method = RequestMethod.GET)
	public String boardPageList(Model model, String find, String category) {
		if(find == null) {
			find = "";
		}
		if(category == null) {
			category = "";
		}
		this.find = find;
		this.category = category;
		int pagesize = 10;
		int startrow = 0;
		int endrow = startrow + pagesize;
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		boardpaging.setFind(find);
		boardpaging.setStartrow(startrow);
		boardpaging.setEndrow(endrow);
		if(category.equals("") || category.equals("searchall")) {
			ArrayList<Board> boards = dao.pageList(boardpaging);
			if(find != "") {
				boards = dao.rnpageList(boardpaging);
			}
			int rowcount = dao.selectRowCount(find);
			int abspage = 1;
			if(rowcount % pagesize == 0) {
				abspage = 0;
			}
			int pagecount = rowcount / pagesize + abspage;
			int max = rowcount / pagesize + abspage;
			if(pagecount > 10) {
				pagecount = 10;
			}
			int[] pages = new int[pagecount];
			for(int i = 0; i < pagecount; i++) {
				pages[i] = i+1;
			}
			model.addAttribute("pages",pages);
			model.addAttribute("pagenum",1);
			model.addAttribute("pagemax",pagecount);
			model.addAttribute("max",max);
			model.addAttribute("find",find);
			model.addAttribute("category",category);
			model.addAttribute("boards",boards);
		}else if(category.equals("searchtitle")) {
			ArrayList<Board> boards = dao.titlepageList(boardpaging);
			if(find != "") {
				boards = dao.rntitlepageList(boardpaging);
			}
			int rowcount = dao.selectRowCountTitle(find);
			int abspage = 1;
			if(rowcount % pagesize == 0) {
				abspage = 0;
			}
			int pagecount = rowcount / pagesize + abspage;
			int max = rowcount / pagesize + abspage;
			if(pagecount > 10) {
				pagecount = 10;
			}
			int[] pages = new int[pagecount];
			for(int i = 0; i < pagecount; i++) {
				pages[i] = i+1;
			}
			model.addAttribute("pages",pages);
			model.addAttribute("pagenum",1);
			model.addAttribute("pagemax",pagecount);
			model.addAttribute("max",max);
			model.addAttribute("find",find);
			model.addAttribute("category",category);
			model.addAttribute("boards",boards);
		}else if(category.equals("searchcontent")) {
			ArrayList<Board> boards = dao.contentpageList(boardpaging);
			if(find != "") {
				boards = dao.rncontentpageList(boardpaging);
			}
			int rowcount = dao.selectRowCountContent(find);
			int abspage = 1;
			if(rowcount % pagesize == 0) {
				abspage = 0;
			}
			int pagecount = rowcount / pagesize + abspage;
			int max = rowcount / pagesize + abspage;
			if(pagecount > 10) {
				pagecount = 10;
			}
			int[] pages = new int[pagecount];
			for(int i = 0; i < pagecount; i++) {
				pages[i] = i+1;
			}
			model.addAttribute("pages",pages);
			model.addAttribute("pagenum",1);
			model.addAttribute("pagemax",pagecount);
			model.addAttribute("max",max);
			model.addAttribute("find",find);
			model.addAttribute("category",category);
			model.addAttribute("boards",boards);
		}else if(category.equals("searchname")) {
			ArrayList<Board> boards = dao.namepageList(boardpaging);
			if(find != "") {
				boards = dao.rnnamepageList(boardpaging);
			}
			int rowcount = dao.selectRowCountName(find);
			int abspage = 1;
			if(rowcount % pagesize == 0) {
				abspage = 0;
			}
			int pagecount = rowcount / pagesize + abspage;
			int max = rowcount / pagesize + abspage;
			if(pagecount > 10) {
				pagecount = 10;
			}
			int[] pages = new int[pagecount];
			for(int i = 0; i < pagecount; i++) {
				pages[i] = i+1;
			}
			model.addAttribute("pages",pages);
			model.addAttribute("pagenum",1);
			model.addAttribute("pagemax",pagecount);
			model.addAttribute("max",max);
			model.addAttribute("find",find);
			model.addAttribute("category",category);
			model.addAttribute("boards",boards);
		}
		return "board/board_page_list";
	}
	@RequestMapping(value = "/boardpageselected", method = RequestMethod.GET)
	public String boardPageSelected(Model model, int page, String find, String category) {
		int pagesize = 10;
		int startrow = (page - 1) * (pagesize);
		int endrow = pagesize;
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		boardpaging.setFind(find);
		boardpaging.setStartrow(startrow);
		boardpaging.setEndrow(endrow);
		if(category.equals("") || category.equals("searchall")) {
			ArrayList<Board> boards = dao.pageList(boardpaging);
			if(find != "") {
				boards = dao.rnpageList(boardpaging);
			}
			int rowcount = dao.selectRowCount(find);
			int abspage = 1;
			if(rowcount % pagesize == 0) {
				abspage = 0;
			}
			int pagecount = rowcount / pagesize + abspage;
			int firstpage = 1;
			int lastpage = 10;
			if(page % 10 == 1) {
				firstpage = page;
			}else if(page % 10 != 0 && page > 10){
				firstpage = page / 10 * 10 + 1;
			}else if(page % 10 == 0 && page > 10) {
				firstpage = (page / 10 - 1) * 10 + 1;
			}
			if(page % 10 != 0 && page/10 == pagecount/10) {
				lastpage = pagecount % 10;
			}
			int[] pages = new int[lastpage];
			for(int i = 0; i < lastpage; i++) {
				pages[i] = firstpage++;
			}
			model.addAttribute("pages",pages);
			model.addAttribute("pagenum",page);
			model.addAttribute("pagemax",pagecount);
			model.addAttribute("max",pagecount);
			model.addAttribute("find",find);
			model.addAttribute("category",category);
			model.addAttribute("boards",boards);
		}else if(category.equals("searchtitle")) {
			ArrayList<Board> boards = dao.titlepageList(boardpaging);
			if(find != "") {
				boards = dao.rntitlepageList(boardpaging);
			}
			int rowcount = dao.selectRowCountTitle(find);
			int abspage = 1;
			if(rowcount % pagesize == 0) {
				abspage = 0;
			}
			int pagecount = rowcount / pagesize + abspage;
			int firstpage = 1;
			int lastpage = 10;
			if(page % 10 == 1) {
				firstpage = page;
			}else if(page % 10 != 0 && page > 10){
				firstpage = page / 10 * 10 + 1;
			}else if(page % 10 == 0 && page > 10) {
				firstpage = (page / 10 - 1) * 10 + 1;
			}
			if(page % 10 != 0 && page/10 == pagecount/10) {
				lastpage = pagecount % 10;
			}
			int[] pages = new int[lastpage];
			for(int i = 0; i < lastpage; i++) {
				pages[i] = firstpage++;
			}
			model.addAttribute("pages",pages);
			model.addAttribute("pagenum",page);
			model.addAttribute("pagemax",pagecount);
			model.addAttribute("max",pagecount);
			model.addAttribute("find",find);
			model.addAttribute("category",category);
			model.addAttribute("boards",boards);
		}else if(category.equals("searchcontent")) {
			ArrayList<Board> boards = dao.contentpageList(boardpaging);
			if(find != "") {
				boards = dao.rncontentpageList(boardpaging);
			}
			int rowcount = dao.selectRowCountContent(find);
			int abspage = 1;
			if(rowcount % pagesize == 0) {
				abspage = 0;
			}
			int pagecount = rowcount / pagesize + abspage;
			int firstpage = 1;
			int lastpage = 10;
			if(page % 10 == 1) {
				firstpage = page;
			}else if(page % 10 != 0 && page > 10){
				firstpage = page / 10 * 10 + 1;
			}else if(page % 10 == 0 && page > 10) {
				firstpage = (page / 10 - 1) * 10 + 1;
			}
			if(page % 10 != 0 && page/10 == pagecount/10) {
				lastpage = pagecount % 10;
			}
			int[] pages = new int[lastpage];
			for(int i = 0; i < lastpage; i++) {
				pages[i] = firstpage++;
			}
			model.addAttribute("pages",pages);
			model.addAttribute("pagenum",page);
			model.addAttribute("pagemax",pagecount);
			model.addAttribute("max",pagecount);
			model.addAttribute("find",find);
			model.addAttribute("category",category);
			model.addAttribute("boards",boards);
		}else if(category.equals("searchname")) {
			ArrayList<Board> boards = dao.namepageList(boardpaging);
			if(find != "") {
				boards = dao.rnnamepageList(boardpaging);
			}
			int rowcount = dao.selectRowCountName(find);
			int abspage = 1;
			if(rowcount % pagesize == 0) {
				abspage = 0;
			}
			int pagecount = rowcount / pagesize + abspage;
			int firstpage = 1;
			int lastpage = 10;
			if(page % 10 == 1) {
				firstpage = page;
			}else if(page % 10 != 0 && page > 10){
				firstpage = page / 10 * 10 + 1;
			}else if(page % 10 == 0 && page > 10) {
				firstpage = (page / 10 - 1) * 10 + 1;
			}
			if(page % 10 != 0 && page/10 == pagecount/10) {
				lastpage = pagecount % 10;
			}
			int[] pages = new int[lastpage];
			for(int i = 0; i < lastpage; i++) {
				pages[i] = firstpage++;
			}
			model.addAttribute("pages",pages);
			model.addAttribute("pagenum",page);
			model.addAttribute("pagemax",pagecount);
			model.addAttribute("max",pagecount);
			model.addAttribute("find",find);
			model.addAttribute("category",category);
			model.addAttribute("boards",boards);
		}
		return "board/board_page_list";
	}
	@RequestMapping(value = "/updatehit", method = RequestMethod.GET)
	public String updateHit(@RequestParam int seq, RedirectAttributes ra) {
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		dao.updateHit(seq);
		ra.addAttribute("seq",seq);
		return "redirect:boarddetail";
	}
	@RequestMapping(value = "/boarddetail", method = RequestMethod.GET)
	public String boardDetail(Model model, @RequestParam int seq) {
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		Board board = dao.selectOne(seq);
		ArrayList<BoardReply> replylist = dao.replyList(seq);
		ArrayList<UploadFileVO> uploadFileList = dao.uploadFileList(seq);
		model.addAttribute("filelist", uploadFileList);
		model.addAttribute("board", board);
		model.addAttribute("replylist", replylist);
		return "board/board_detail";
	}
	@RequestMapping(value = "/boardmodify", method = RequestMethod.GET)
	public String boardModify(Model model, @RequestParam int seq) {
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		Board board = dao.selectOne(seq);
		String str = board.getcontent();
		int str_len = str.getBytes().length;
		ArrayList<Board> boards = dao.pageList(boardpaging);
		ArrayList<UploadFileVO> uploadFileList = dao.uploadFileList(seq);
		model.addAttribute("filelist", uploadFileList);
		model.addAttribute("board", board);
		model.addAttribute("boards",boards);
		model.addAttribute("getb",str_len);
		return "board/board_modify";
	}
	@RequestMapping(value = "/boardupdate", method = RequestMethod.POST)
	public String boardUpdate(Model model, @ModelAttribute Board board, HttpServletRequest request, MultipartHttpServletRequest mtfRequest) throws UnsupportedEncodingException {
		List<MultipartFile> fileList = mtfRequest.getFiles("file");
		String path = "C:\\Users\\abc\\Documents\\board\\board\\src\\main\\webapp\\resources\\file\\";
		Date date = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		board.setdate(format.format(date));
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		try {
			int result = dao.updateRow(board);
			if(result > 0) {
				model.addAttribute("msg", "수정되었습니다");
			}
		}catch (Exception e) {
		}
		for (MultipartFile mf : fileList) {
			String originFileName = mf.getOriginalFilename(); // 원본 파일 명
			originFileName = new String(originFileName.getBytes("8859_1"), "UTF-8");
			long fileSize = mf.getSize(); // 파일 사이즈
			if(fileSize != 0) {
				String safeFile = path + System.currentTimeMillis() + originFileName;
				uploadfilevo.setFile_name(originFileName);
				uploadfilevo.setFile_size(fileSize);
				int maxseq = dao.selectMaxSeq();
				uploadfilevo.setArticle_num(maxseq);
				dao.uploadFile(uploadfilevo);
				try {
					mf.transferTo(new File(safeFile));
				} catch (IllegalStateException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
		}
		return "redirect:boardpagelist";
	}
	@RequestMapping(value = "/boarddownload", method = RequestMethod.GET)
	public ModelAndView boardDownload(@RequestParam String attach) {
		String path = "C:\\Users\\abc\\Documents\\board\\board\\src\\main\\webapp\\resources\\file\\";
		File file = new File(path+attach);
		return new ModelAndView("download", "downloadFile", file);
	}
	@RequestMapping(value = "/boardreplyform", method = RequestMethod.GET)
	public String boardReplyForm(Model model, HttpSession session, @RequestParam int renum, @RequestParam int ref, @RequestParam int step, @RequestParam int level) {
//		board.setemail((String) session.getAttribute("sessionemail"));
//		board.setname((String) session.getAttribute("sessionname"));
		board.setRenum(renum);
		board.setref(ref);
		board.setstep(step);
		board.setlevel(level);
		model.addAttribute("board",board);
		return "board/board_reply";
	}
	@RequestMapping(value = "/boardreplyinsert", method = RequestMethod.POST)
	public String boardReplyInsert(Model model, @ModelAttribute Board board, HttpServletRequest request, @RequestParam CommonsMultipartFile file) {
		String originalname = file.getOriginalFilename();
		if(originalname.equals("")) {
		}else {
//			String realpath = "resources/file/";
			try {
				String path = "C:\\Users\\abc\\Documents\\board\\board\\src\\main\\webapp\\resources\\file\\";
				byte bytes[] = file.getBytes();
				BufferedOutputStream output = new BufferedOutputStream(new FileOutputStream(path+originalname));
				output.write(bytes);
				output.flush();
				output.close();
				board.setattach(originalname);
			}catch (Exception e) {
				
			}
		}
		board.setRenum(board.getRenum()+1);
		board.setstep(board.getstep()+1);
		board.setip(request.getRemoteAddr());
		Date date = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		board.setdate(format.format(date));
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		if(board.getlevel() == 0) {
			int level = dao.selectLevel(board.getref());
			board.setlevel(level);
			dao.updateReplyStepRow(board);
			dao.insertReplyRow(board);
		}else {
			dao.updateReplyStepRow(board);
			dao.insertReplyRow(board);
		}
		return "redirect:boardpagelist";
	}
	@RequestMapping(value = "/boarddelete", method = RequestMethod.POST)
	public String boardDelete(@ModelAttribute Board board) {
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
//		if(board.getlevel() == 0) {
//			dao.updateremove(board);
//		}else {
//			dao.updatereplyremove(board);
//		}
		if(board.getseq() == board.getref()) {
			int sr = dao.searchRemove(board.getref());
			if(sr == 0) {
				dao.deleteseq(board.getseq());
			}else {
				dao.updateremove(board.getseq());
			}
		}else {
			int srr = dao.searchRemoveReply(board);
			if(srr == 0) {
				dao.deleteseq(board.getseq());
				int sr = dao.searchRemove(board.getref());
				if(sr == 0) {
					dao.deleteref(board.getref());
				}
			}else {
				dao.updateremove(board.getseq());
			}
		}
		return "redirect:boardpagelist";
	}
	@RequestMapping(value = "/replydelete", method = RequestMethod.GET)
	public String replyDelete(@RequestParam int seq, @RequestParam int repseq, RedirectAttributes ra) {
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		dao.deletereplyseq(repseq);
		ra.addAttribute("seq",seq);
		return "redirect:boarddetail";
	}
	@RequestMapping(value = "/replyupdate", method = RequestMethod.GET)
	public String replyUpdate(BoardReply boardreply, @RequestParam int seq, @RequestParam int repseq, @RequestParam String content, RedirectAttributes ra) {
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		boardreply.setSeq(repseq);
		boardreply.setContent(content);
		dao.updatereplyseq(boardreply);
		ra.addAttribute("seq",seq);
		return "redirect:boarddetail";
	}
	@RequestMapping(value = "/nowreplyinsert", method = RequestMethod.POST)
	public String nowReplyInsert(Model model, @ModelAttribute BoardReply boardreply, RedirectAttributes ra, HttpServletRequest request) {
		boardreply.setIp(request.getRemoteAddr());
		Date date = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		boardreply.setDate(format.format(date));
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		dao.insertReplyBoardRow(boardreply);
		ra.addAttribute("seq", boardreply.getRef());
		return "redirect:boarddetail";
	}
	@RequestMapping(value = "/boardSearchListExcel", method = RequestMethod.GET)
	public ModelAndView boardSearchListExcel(HttpServletRequest request, HttpServletResponse response, Model model, String find, String category) {
//		response.setHeader("Content-disposition", "attachment; filename= board.xlsx");
		if(find == null) {
			find = "";
		}
		if(category == null) {
			category = "";
		}
		this.find = find;
		this.category = category;
		int pagesize = 10;
		int startrow = 0;
		int endrow = startrow + pagesize;
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		boardpaging.setFind(find);
		boardpaging.setStartrow(startrow);
		boardpaging.setEndrow(endrow);
		ModelAndView result = new ModelAndView();
		if(category.equals("") || category.equals("searchall")) {
			ArrayList<Board> boards = dao.pageListNum(boardpaging);
			result.addObject("boards",boards); // 쿼리 결과를 model에 담아줌
		}else if(category.equals("searchtitle")) {
			ArrayList<Board> boards = dao.titlepageListAll(boardpaging);
			result.addObject("boards",boards); // 쿼리 결과를 model에 담아줌
		}else if(category.equals("searchcontent")) {
			ArrayList<Board> boards = dao.contentpageListAll(boardpaging);
			result.addObject("boards",boards); // 쿼리 결과를 model에 담아줌
		}else if(category.equals("searchname")) {
			ArrayList<Board> boards = dao.namepageListAll(boardpaging);
			result.addObject("boards",boards); // 쿼리 결과를 model에 담아줌
		}
		

		StringBuffer str = new StringBuffer();
		str.append( find );
		request.setAttribute("filename", str);
		result.addObject("find", find);

		result.setViewName("/exportToExcel");// 엑셀로 출력하기 위한 jsp 페이지

		return result;

	}
	@RequestMapping(value = "/boardNowListExcel", method = RequestMethod.GET)
	public ModelAndView boardNowListExcel(HttpServletRequest request, HttpServletResponse response, Model model, String find, String category, int page) {
//		response.setHeader("Content-disposition", "attachment; filename= board.xlsx");
		if(find == null) {
			find = "";
		}
		if(category == null) {
			category = "";
		}
		this.find = find;
		this.category = category;
		int pagesize = 10;
		int startrow = (page - 1) * (pagesize);
		int endrow = pagesize;
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		boardpaging.setFind(find);
		boardpaging.setStartrow(startrow);
		boardpaging.setEndrow(endrow);
		ModelAndView result = new ModelAndView();
		if(category.equals("") || category.equals("searchall")) {
			ArrayList<Board> boards = dao.pageList(boardpaging);
			if(find != "") {
				boards = dao.rnpageList(boardpaging);
			}
			result.addObject("boards",boards); // 쿼리 결과를 model에 담아줌
		}else if(category.equals("searchtitle")) {
			ArrayList<Board> boards = dao.titlepageList(boardpaging);
			if(find != "") {
				boards = dao.rntitlepageList(boardpaging);
			}
			result.addObject("boards",boards); // 쿼리 결과를 model에 담아줌
		}else if(category.equals("searchcontent")) {
			ArrayList<Board> boards = dao.contentpageList(boardpaging);
			if(find != "") {
				boards = dao.rncontentpageList(boardpaging);
			}
			result.addObject("boards",boards); // 쿼리 결과를 model에 담아줌
		}else if(category.equals("searchname")) {
			ArrayList<Board> boards = dao.namepageList(boardpaging);
			if(find != "") {
				boards = dao.rnnamepageList(boardpaging);
			}
			result.addObject("boards",boards); // 쿼리 결과를 model에 담아줌
		}
		
		
		StringBuffer str = new StringBuffer();
		str.append( find );
		request.setAttribute("filename", str);
		result.addObject("find", find);
		
		result.setViewName("/exportToExcel");// 엑셀로 출력하기 위한 jsp 페이지
		
		return result;
		
	}
	@RequestMapping(value = "/boardListExcel", method = RequestMethod.GET)
	public ModelAndView boardListExcel(HttpServletRequest request, HttpServletResponse response, Model model, String find, String category) {
//		response.setHeader("Content-disposition", "attachment; filename= board.xlsx");
		if(find == null) {
			find = "";
		}
		if(category == null) {
			category = "";
		}
		this.find = find;
		this.category = category;
		int pagesize = 10;
		int startrow = 0;
		int endrow = startrow + pagesize;
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		boardpaging.setFind(find);
		boardpaging.setStartrow(startrow);
		boardpaging.setEndrow(endrow);
		ModelAndView result = new ModelAndView();
		ArrayList<Board> boards = dao.pageListAll(boardpaging);
		result.addObject("boards",boards); // 쿼리 결과를 model에 담아줌
		
		
		StringBuffer str = new StringBuffer();
		str.append( find );
		request.setAttribute("filename", str);
		
		result.setViewName("/exportToExcel");// 엑셀로 출력하기 위한 jsp 페이지
		
		return result;
		
	}
	
	@RequestMapping(value = "/replyconfirm", method = RequestMethod.POST)
	@ResponseBody
	public int replyConfirm(BoardReply boardreply, @RequestParam int seq, @RequestParam String password) {
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		boardreply.setSeq(seq);
		boardreply.setPassword(password);
		int exists = 0;
		try {
			exists=dao.replyConfirm(boardreply);
		} catch (Exception e) {
			System.out.println("error:"+e.getMessage());
		}
		return exists;
	}
	
	@RequestMapping(value = "/filedelete", method = RequestMethod.GET)
	public String fileDelete(@RequestParam int filenum, @RequestParam int seq, RedirectAttributes ra) {
		BoardDao dao = sqlSession.getMapper(BoardDao.class);
		dao.deletefile(filenum);
		ra.addAttribute("seq",seq);
		return "redirect:boardmodify";
	}
	
	@RequestMapping(value = "/smspage", method = RequestMethod.GET)
	public String smsPage() {
		return "board/sendsms";
	}
	
	@RequestMapping(value = "/sendsms", method = RequestMethod.POST)
	  public String sendSms(HttpServletRequest request) throws Exception {

	    String api_key = "NCSMBMFUQBKSR5JK";
	    String api_secret = "OUGVP86FNLFUZIDEGDFVWBX8C4QSCVJL";
	    Coolsms coolsms = new Coolsms(api_key, api_secret);

	    HashMap<String, String> set = new HashMap<String, String>();
	    set.put("to", "01075504619"); // 수신번호
	    String text = (String)request.getParameter("text");
	    String t = new String(text.getBytes("8859_1"), "UTF-8");
	    set.put("from", (String)request.getParameter("from")); // 발신번호
	    set.put("text", t); // 문자내용
	    set.put("type", "sms"); // 문자 타입

	    System.out.println(set);

	    JSONObject result = coolsms.send(set); // 보내기&전송결과받기

	    if ((boolean)result.get("status") == true) {
	      // 메시지 보내기 성공 및 전송결과 출력
	      System.out.println("성공");
	      System.out.println(result.get("group_id")); // 그룹아이디
	      System.out.println(result.get("result_code")); // 결과코드
	      System.out.println(result.get("result_message")); // 결과 메시지
	      System.out.println(result.get("success_count")); // 메시지아이디
	      System.out.println(result.get("error_count")); // 여러개 보낼시 오류난 메시지 수
	    } else {
	      // 메시지 보내기 실패
	      System.out.println("실패");
	      System.out.println(result.get("code")); // REST API 에러코드
	      System.out.println(result.get("message")); // 에러메시지
	    }

	    return "redirect:smspage";
	  }
	



//	@RequestMapping(value = "/passwordfind", method = RequestMethod.POST)
//	@ResponseBody
//	public int passwordFind(@RequestParam String password) {
//		BoardDao dao = sqlSession.getMapper(BoardDao.class);
//		int exists = 0;
//		try {
//			exists=dao.selectConfirm(email);
//		} catch (Exception e) {
//			System.out.println("error:"+e.getMessage());
//		}
//		if(exists > 0) {
//			
//		}
//		return exists;
//	}
}
