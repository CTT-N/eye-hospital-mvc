package model;

public class Department {

    private String departmentId;
    private String hospitalId;
    private String departmentName;
    private String description;

    public Department() {
    }

    public Department(String departmentId, String hospitalId, String departmentName, String description) {
        this.departmentId = departmentId;
        this.hospitalId = hospitalId;
        this.departmentName = departmentName;
        this.description = description;
    }

    public String getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(String departmentId) {
        this.departmentId = departmentId;
    }

    public String getHospitalId() {
        return hospitalId;
    }

    public void setHospitalId(String hospitalId) {
        this.hospitalId = hospitalId;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}