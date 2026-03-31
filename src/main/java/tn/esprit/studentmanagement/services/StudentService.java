package tn.esprit.studentmanagement.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import tn.esprit.studentmanagement.dto.StudentRequest;
import tn.esprit.studentmanagement.entities.Department;
import tn.esprit.studentmanagement.entities.Student;
import tn.esprit.studentmanagement.repositories.DepartmentRepository;
import tn.esprit.studentmanagement.repositories.StudentRepository;

import java.util.List;

import static org.springframework.http.HttpStatus.NOT_FOUND;

@Service
public class StudentService implements IStudentService {
    @Autowired
    private StudentRepository studentRepository;
    @Autowired
    private DepartmentRepository departmentRepository;

    public List<Student> getAllStudents() { return studentRepository.findAll(); }

    public Student getStudentById(Long id) { return studentRepository.findById(id).orElse(null); }

    public Student saveStudent(StudentRequest studentRequest) {
        Student student = studentRequest.getIdStudent() == null
                ? new Student()
                : studentRepository.findById(studentRequest.getIdStudent()).orElse(new Student());

        student.setFirstName(studentRequest.getFirstName());
        student.setLastName(studentRequest.getLastName());
        student.setEmail(studentRequest.getEmail());
        student.setPhone(studentRequest.getPhone());
        student.setDateOfBirth(studentRequest.getDateOfBirth());
        student.setAddress(studentRequest.getAddress());

        if (studentRequest.getDepartmentId() != null) {
            Department department = departmentRepository.findById(studentRequest.getDepartmentId())
                    .orElseThrow(() -> new ResponseStatusException(
                            NOT_FOUND,
                            "Department not found with id " + studentRequest.getDepartmentId()
                    ));
            student.setDepartment(department);
        } else {
            student.setDepartment(null);
        }

        return studentRepository.save(student);
    }

    public void deleteStudent(Long id) { studentRepository.deleteById(id); }

}
