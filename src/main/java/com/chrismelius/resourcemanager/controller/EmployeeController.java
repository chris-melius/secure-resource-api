package com.chrismelius.resourcemanager.controller;

import com.chrismelius.resourcemanager.model.Employee;
import com.chrismelius.resourcemanager.repository.EmployeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/employees")
public class EmployeeController {

    @Autowired
    private EmployeeRepository repository;

    @GetMapping
    public List<Employee> getAllEmployees() {
        return repository.findAll(); // Returns the list as JSON
    }

    @PostMapping
    public Employee createEmployee(@RequestBody Employee employee) {
        return repository.save(employee); // Saves to MySQL and returns the saved object
    }
}