package com.backend.controller;

import java.util.List;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.backend.model.Parameter;
import com.backend.model.Subsystem;

import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/main")
class ParameterController {

	private final ParameterRepository repository;
	private final SubsystemRepository repositoryS;

	ParameterController(ParameterRepository repository,SubsystemRepository repositoryS) {
		this.repository = repository;
		this.repositoryS = repositoryS;
	}

	// Aggregate root

	@GetMapping("/params")
	List<Parameter> all() {
		return repository.findAll();
	}

	@PostMapping("/addParams")
	List<Parameter> newParam(@RequestBody Parameter newParameter) {
		repository.save(newParameter);
		return repository.findAll();
	}

	// Single item

	@GetMapping("/params/{id}")
	Parameter one(@PathVariable Long id) {

		return repository.findById(id)
			.orElseThrow(() -> new ParameterNotFoundException(id));
	}

	@PutMapping("/params/{id}")
	Parameter replaceParameter(@RequestBody Parameter newParameter, @PathVariable Long id) {

		return repository.findById(id).map(myParameter -> {
				myParameter.setSubsystemName(newParameter.getSubsystemName());
				myParameter.setEntityName(newParameter.getEntityName());
				myParameter.setValue(newParameter.getValue());
				return repository.save(myParameter);
			})
			.orElseGet(() -> {
				newParameter.setId(id);
				return repository.save(newParameter);
			});
	}

	@DeleteMapping("/params/{id}")
	void deleteParameter(@PathVariable Long id) {
		repository.deleteById(id);
	}
}