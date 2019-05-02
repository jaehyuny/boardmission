package com.project.board.entities;

import org.springframework.stereotype.Component;

@Component
public class Board {
	private int rownum;
	private int seq;
	private String name;
	private String password;
	private String title;
	private String content;
	private String ip;
	private int ref;
	private int step;
	private int hit;
	private int level;
	private String attach;
	private String beforeattach;
	private String date;
	private int renum;
	private int remove;
	public int getRownum() {
		return rownum;
	}
	public void setRownum(int rownum) {
		this.rownum = rownum;
	}
	public int getseq() {
		return seq;
	}
	public void setseq(int seq) {
		this.seq = seq;
	}
	public String getname() {
		return name;
	}
	public void setname(String name) {
		this.name = name;
	}
	public String getpassword() {
		return password;
	}
	public void setpassword(String password) {
		this.password = password;
	}
	public String gettitle() {
		return title;
	}
	public void settitle(String title) {
		this.title = title;
	}
	public String getcontent() {
		return content;
	}
	public void setcontent(String content) {
		this.content = content;
	}
	public String getip() {
		return ip;
	}
	public void setip(String ip) {
		this.ip = ip;
	}
	public int getref() {
		return ref;
	}
	public void setref(int ref) {
		this.ref = ref;
	}
	public int getstep() {
		return step;
	}
	public void setstep(int step) {
		this.step = step;
	}
	public int gethit() {
		return hit;
	}
	public void sethit(int hit) {
		this.hit = hit;
	}
	public int getlevel() {
		return level;
	}
	public void setlevel(int level) {
		this.level = level;
	}
	public String getattach() {
		return attach;
	}
	public void setattach(String attach) {
		this.attach = attach;
	}
	public String getbeforeattach() {
		return beforeattach;
	}
	public void setbeforeattach(String beforeattach) {
		this.beforeattach = beforeattach;
	}
	public String getdate() {
		return date;
	}
	public void setdate(String date) {
		this.date = date;
	}
	public int getRenum() {
		return renum;
	}
	public void setRenum(int renum) {
		this.renum = renum;
	}
	public int getRemove() {
		return remove;
	}
	public void setRemove(int remove) {
		this.remove = remove;
	}
}
