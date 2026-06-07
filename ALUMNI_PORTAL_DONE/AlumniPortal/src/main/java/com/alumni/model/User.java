package com.alumni.model;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String fullName;
    private Integer age;
    private String email;
    private String phone;
    private String place;
    private String passHash;
    private String role;
    private String emailVerified;
    private String status;
    private Timestamp createdAt;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public Integer getAge() { return age; }
    public void setAge(Integer age) { this.age = age; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPlace() { return place; }
    public void setPlace(String place) { this.place = place; }

    public String getPassHash() { return passHash; }
    public void setPassHash(String passHash) { this.passHash = passHash; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getEmailVerified() { return emailVerified; }
    public void setEmailVerified(String emailVerified) { this.emailVerified = emailVerified; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}