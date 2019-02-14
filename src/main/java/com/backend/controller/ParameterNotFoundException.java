package com.backend.controller;

public class ParameterNotFoundException extends RuntimeException {

	ParameterNotFoundException(Long id) {
		super("Could not find parameter " + id);
	}
}
