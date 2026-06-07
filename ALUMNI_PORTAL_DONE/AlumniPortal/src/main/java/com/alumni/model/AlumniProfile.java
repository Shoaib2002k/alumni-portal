package com.alumni.model;

import java.sql.Timestamp;

public class AlumniProfile {

    private int profileId;
    private int userId;
    private Integer batchId;
    private Integer deptId;
    private String universityRegNo;
    private String currentCompany;
    private String currentRole;
    private Integer experienceYears;
    private Integer companyChangesCount;
    private String companyChangesNames;
    private String specialization;
    private String photoPath;
    private Timestamp createdAt;

    // Added for members page
    private User user;

    public int getProfileId() {
        return profileId;
    }

    public void setProfileId(int profileId) {
        this.profileId = profileId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getBatchId() {
        return batchId;
    }

    public void setBatchId(Integer batchId) {
        this.batchId = batchId;
    }

    public Integer getDeptId() {
        return deptId;
    }

    public void setDeptId(Integer deptId) {
        this.deptId = deptId;
    }

    public String getUniversityRegNo() {
        return universityRegNo;
    }

    public void setUniversityRegNo(String universityRegNo) {
        this.universityRegNo = universityRegNo;
    }

    public String getCurrentCompany() {
        return currentCompany;
    }

    public void setCurrentCompany(String currentCompany) {
        this.currentCompany = currentCompany;
    }

    public String getCurrentRole() {
        return currentRole;
    }

    public void setCurrentRole(String currentRole) {
        this.currentRole = currentRole;
    }

    public Integer getExperienceYears() {
        return experienceYears;
    }

    public void setExperienceYears(Integer experienceYears) {
        this.experienceYears = experienceYears;
    }

    public Integer getCompanyChangesCount() {
        return companyChangesCount;
    }

    public void setCompanyChangesCount(Integer companyChangesCount) {
        this.companyChangesCount = companyChangesCount;
    }

    public String getCompanyChangesNames() {
        return companyChangesNames;
    }

    public void setCompanyChangesNames(String companyChangesNames) {
        this.companyChangesNames = companyChangesNames;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }

    public String getPhotoPath() {
        return photoPath;
    }

    public void setPhotoPath(String photoPath) {
        this.photoPath = photoPath;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}