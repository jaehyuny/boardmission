package com.project.board.service;

import java.util.ArrayList;
import java.util.List;

import com.project.board.entities.Board;
import com.project.board.entities.BoardPaging;
import com.project.board.entities.BoardReply;
import com.project.board.entities.UploadFileVO;

public interface BoardDao {
	int insertRow(Board board);
	int insertReplyRow(Board board);
	int insertReplyBoardRow(BoardReply boardreply);
	int selectRowCount(String find);
	int selectRowCountTitle(String find);
	int selectRowCountContent(String find);
	int selectRowCountName(String find);
	ArrayList<Board> pageList(BoardPaging boardpaging);
	ArrayList<Board> titlepageList(BoardPaging boardpaging);
	ArrayList<Board> contentpageList(BoardPaging boardpaging);
	ArrayList<Board> namepageList(BoardPaging boardpaging);
	ArrayList<Board> pageListAll(BoardPaging boardpaging);
	ArrayList<Board> pageListNum(BoardPaging boardpaging);
	ArrayList<Board> titlepageListAll(BoardPaging boardpaging);
	ArrayList<Board> contentpageListAll(BoardPaging boardpaging);
	ArrayList<Board> namepageListAll(BoardPaging boardpaging);
	ArrayList<Board> rnpageList(BoardPaging boardpaging);
	ArrayList<Board> rntitlepageList(BoardPaging boardpaging);
	ArrayList<Board> rncontentpageList(BoardPaging boardpaging);
	ArrayList<Board> rnnamepageList(BoardPaging boardpaging);
	ArrayList<BoardReply> replyList(int seq);
	Board selectOne(int seq);
	int selectStep(Board board);
	int selectLevel(int ref);
	void updateHit(int seq);
	int updateRow(Board board);
	int updateDeleteRow(int ref);
	int updateReplyStepRow(Board board);
	int updateReplyLevelRow(Board board);
	int deleteseq(int seq);
	int deleteref(int ref);
	int updateremove(int seq);
	int updatereplyremove(Board board);
	int deletereplyseq(int seq);
	void updatereplyseq(BoardReply boardreply);
	int replyConfirm(BoardReply boardreply);
	int searchRemove(int ref);
	int searchRemoveReply(Board board);
	void uploadFile(UploadFileVO uploadfilevo);
	ArrayList<UploadFileVO> uploadFileList(int seq);
	int selectMaxSeq();
	void deletefile(int filenum);
}
