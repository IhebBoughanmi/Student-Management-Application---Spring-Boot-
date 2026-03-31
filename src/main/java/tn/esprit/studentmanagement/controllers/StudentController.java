package tn.esprit.studentmanagement.controllers;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import tn.esprit.studentmanagement.dto.StudentRequest;
import tn.esprit.studentmanagement.entities.Student;
import tn.esprit.studentmanagement.services.IStudentService;

import java.util.List;

@RestController
@RequestMapping("/students")
@CrossOrigin(origins = "http://localhost:4200")
@AllArgsConstructor
public class StudentController {
IStudentService studentService;

    @GetMapping("/getAllStudents")
    public List<Student> getAllStudents() { return studentService.getAllStudents(); }

    @GetMapping("/getStudent/{id}")
    public Student getStudent(@PathVariable Long id) { return studentService.getStudentById(id); }

    @PostMapping("/createStudent")
    public Student createStudent(@RequestBody StudentRequest studentRequest) {
        return studentService.saveStudent(studentRequest);
    }

    @PutMapping("/updateStudent")
    public Student updateStudent(@RequestBody StudentRequest studentRequest) {
        return studentService.saveStudent(studentRequest);
    }

    @DeleteMapping("/deleteStudent/{id}")
    public void deleteStudent(@PathVariable Long id) { studentService.deleteStudent(id); }
}
