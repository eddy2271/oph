package com.oph.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.oph.service.CodeServiceI;
import com.oph.vo.CodeVo;

@Controller
public class CodeController {
	
	@Autowired
	CodeServiceI codeService;
	
	/**
	 * 코드관리 화면
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/code.do")
	public ModelAndView codeManageView(HttpServletRequest request,CodeVo codeVo) {
		ModelAndView mv = new ModelAndView("/code/code");
		
		List<Map<String, Object>> divList = codeService.selectCodeDivList();
		mv.addObject("divList", divList);
		
		return mv;
	}
	
	@ResponseBody
	@RequestMapping(value="/codeValList.do")
	public Object codeValList(HttpServletRequest request, HttpServletResponse response, @RequestBody CodeVo codeVo) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> valList = new ArrayList<Map<String,Object>>();
			valList = codeService.selectCodeValList(codeVo);
			map.put("valList", valList);
			map.put("result", 1); // 성공
		} catch(Exception e) {
			map.put("reulst", -1); // 실패
			map.put("message", "코드설명 조회에 실패했습니다."); // 실패
		}
		
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value="/codeList.do")
	public Object codeList(HttpServletRequest request, HttpServletResponse response, @RequestBody CodeVo codeVo) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> codeList = new ArrayList<Map<String,Object>>();
			
			codeList = codeService.selectCodeList(codeVo);
			map.put("codeList", codeList);
			map.put("result", 1); // 성공
		} catch(Exception e) {
			map.put("reulst", -1); // 실패
			map.put("message", "코드목록 조회에 실패했습니다."); // 실패
		}
		
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value="/codeChange.do")
	public Object codeChange(HttpServletRequest request, HttpServletResponse response, @RequestBody CodeVo codeVo) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {
			int codeChange = 0;
			String url = "";
			codeChange = codeService.codeChange(codeVo);
			
			if(codeChange > 0) {
				String msg = "";
				
				if("C".equals(codeVo.getMode())) {
					msg = "코드를 정상적으로 등록하였습니다.";
				} else if("M".equals(codeVo.getMode())) {
					msg = "코드를 정상적으로 수정하였습니다.";
				} else if("D".equals(codeVo.getMode())) {
					msg = "코드를 정상적으로 삭제하였습니다.";
				}
				map.put("message", msg); // 성공
				map.put("result", 1); // 성공
			} else {
				throw new Exception();
			}
		} catch(Exception e) {
			map.put("reulst", -1); // 실패
			map.put("message", "코드목록 조회에 실패했습니다."); // 실패
		}
		
		return map;
	}
}
