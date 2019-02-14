package com.backend.controller;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

@ControllerAdvice
class ParameterNotFoundAdvice {

	@ResponseBody
	@ExceptionHandler(ParameterNotFoundException.class)
	@ResponseStatus(HttpStatus.NOT_FOUND)
	String subsystemNotFoundHandler(ParameterNotFoundException ex) {
		return ex.getMessage();
	}
}
