package model;

import java.sql.Date;
import java.util.List;

public class Invoice {

    private String invoiceId;
    private String appointmentId;
    private Date date;
    private double totalAmount;
    private String status;
    private String patientName;
    private String doctorName;
    private List<InvoiceService> services;

    public Invoice() {}

    public String getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(String invoiceId) {
        this.invoiceId = invoiceId;
    }

    public String getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(String appointmentId) {
        this.appointmentId = appointmentId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public List<InvoiceService> getServices() {
        return services;
    }

    public void setServices(List<InvoiceService> services) {
        this.services = services;
    }
}
