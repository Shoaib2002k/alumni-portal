package com.alumni.dao;

import com.alumni.model.AlumniProfile;
import com.alumni.model.User;
import com.alumni.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

public class UserDao {
	
	
	
	

    public User findByEmailAndPassword(String email, String password) throws Exception {
        String sql = "SELECT user_id, full_name, email, role, status, email_verified " +
                     "FROM users WHERE email = ? AND pass_hash = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setEmail(rs.getString("email"));
                    u.setRole(rs.getString("role"));
                    u.setStatus(rs.getString("status"));
                    u.setEmailVerified(rs.getString("email_verified"));
                    return u;
                }
            }
        }
        return null;
    }

    public boolean emailExists(String email) throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public int registerUser(User user, AlumniProfile profile) throws Exception {
        Connection con = null;
        PreparedStatement psUser = null;
        PreparedStatement psProfile = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String userSql = "INSERT INTO users " +
                    "(full_name, age, email, phone, place, pass_hash, role, email_verified, status, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, 'ALUMNI', 'N', 'PENDING_APPROVAL', SYSTIMESTAMP)";

            psUser = con.prepareStatement(userSql, new String[] { "USER_ID" });
            psUser.setString(1, user.getFullName());
            psUser.setObject(2, user.getAge());
            psUser.setString(3, user.getEmail());
            psUser.setString(4, user.getPhone());
            psUser.setString(5, user.getPlace());
            psUser.setString(6, user.getPassHash());

            int userRows = psUser.executeUpdate();
            if (userRows == 0) {
                throw new Exception("User insert failed.");
            }

            rs = psUser.getGeneratedKeys();
            int userId = 0;
            if (rs.next()) {
                userId = rs.getInt(1);
            } else {
                throw new Exception("Could not get generated user ID.");
            }

            String profileSql = "INSERT INTO alumni_profile " +
                    "(user_id, university_reg_no, current_company, current_role, " +
                    "experience_years, company_changes_count, company_changes_names, specialization, photo_path, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP)";

            psProfile = con.prepareStatement(profileSql);
            psProfile.setInt(1, userId);
            psProfile.setString(2, profile.getUniversityRegNo());
            psProfile.setString(3, profile.getCurrentCompany());
            psProfile.setString(4, profile.getCurrentRole());
            psProfile.setObject(5, profile.getExperienceYears());
            psProfile.setObject(6, profile.getCompanyChangesCount());
            psProfile.setString(7, profile.getCompanyChangesNames());
            psProfile.setString(8, profile.getSpecialization());
            psProfile.setString(9, profile.getPhotoPath());

            int profileRows = psProfile.executeUpdate();
            if (profileRows == 0) {
                throw new Exception("Profile insert failed.");
            }

            con.commit();
            return userId;

        } catch (Exception e) {
            if (con != null) {
                con.rollback();
            }
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (psUser != null) psUser.close();
            if (psProfile != null) psProfile.close();
            if (con != null) con.close();
        }
    }

    public void saveOtp(String email, String otpCode) throws Exception {
        String sql = "INSERT INTO otp_verifications " +
                "(email, otp_code, purpose, is_used, expires_at, created_at) " +
                "VALUES (?, ?, 'REGISTER', 'N', ?, SYSTIMESTAMP)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + (5 * 60 * 1000));

            ps.setString(1, email);
            ps.setString(2, otpCode);
            ps.setTimestamp(3, expiresAt);

            ps.executeUpdate();
        }
    }

    public boolean verifyOtp(String email, String otpCode) throws Exception {
        String sql = "SELECT COUNT(*) FROM otp_verifications " +
                     "WHERE email = ? AND otp_code = ? AND is_used = 'N' AND expires_at >= SYSTIMESTAMP";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, otpCode);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public void markOtpUsed(String email, String otpCode) throws Exception {
        String sql = "UPDATE otp_verifications SET is_used = 'Y' WHERE email = ? AND otp_code = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, otpCode);
            ps.executeUpdate();
        }
    }

    public void markEmailVerified(String email) throws Exception {
        String sql = "UPDATE users SET email_verified = 'Y' WHERE email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.executeUpdate();
        }
    }

    public User findAlumniLogin(String email, String hashedPassword) throws Exception {
        String sql = "SELECT user_id, full_name, email, role, status, email_verified " +
                     "FROM users WHERE email = ? AND pass_hash = ? AND role = 'ALUMNI'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, hashedPassword);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setEmail(rs.getString("email"));
                    u.setRole(rs.getString("role"));
                    u.setStatus(rs.getString("status"));
                    u.setEmailVerified(rs.getString("email_verified"));
                    return u;
                }
            }
        }
        return null;
    }
    public java.util.List<User> getPendingAlumniUsers() throws Exception {
        java.util.List<User> list = new java.util.ArrayList<>();

        String sql = "SELECT user_id, full_name, email, phone, place, status, email_verified, role " +
                     "FROM users " +
                     "WHERE role = 'ALUMNI' AND status = 'PENDING_APPROVAL' " +
                     "ORDER BY user_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setPlace(rs.getString("place"));
                u.setStatus(rs.getString("status"));
                u.setEmailVerified(rs.getString("email_verified"));
                u.setRole(rs.getString("role"));
                list.add(u);
            }
        }

        return list;
    }

    public void approveUser(int userId, int adminUserId) throws Exception {
        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String updateSql = "UPDATE users SET status = 'APPROVED' WHERE user_id = ?";
            ps1 = con.prepareStatement(updateSql);
            ps1.setInt(1, userId);
            ps1.executeUpdate();

            String auditSql = "INSERT INTO approval_audit (user_id, action, action_reason, action_by, action_at) " +
                              "VALUES (?, 'APPROVED', ?, ?, SYSTIMESTAMP)";
            ps2 = con.prepareStatement(auditSql);
            ps2.setInt(1, userId);
            ps2.setString(2, "Approved by admin");
            ps2.setInt(3, adminUserId);
            ps2.executeUpdate();

            con.commit();

        } catch (Exception e) {
            if (con != null) con.rollback();
            throw e;
        } finally {
            if (ps1 != null) ps1.close();
            if (ps2 != null) ps2.close();
            if (con != null) con.close();
        }
    }

    public void rejectUser(int userId, int adminUserId, String reason) throws Exception {
        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String updateSql = "UPDATE users SET status = 'REJECTED' WHERE user_id = ?";
            ps1 = con.prepareStatement(updateSql);
            ps1.setInt(1, userId);
            ps1.executeUpdate();

            String auditSql = "INSERT INTO approval_audit (user_id, action, action_reason, action_by, action_at) " +
                              "VALUES (?, 'REJECTED', ?, ?, SYSTIMESTAMP)";
            ps2 = con.prepareStatement(auditSql);
            ps2.setInt(1, userId);
            ps2.setString(2, reason);
            ps2.setInt(3, adminUserId);
            ps2.executeUpdate();

            con.commit();

        } catch (Exception e) {
            if (con != null) con.rollback();
            throw e;
        } finally {
            if (ps1 != null) ps1.close();
            if (ps2 != null) ps2.close();
            if (con != null) con.close();
        }
    }
    
    public java.util.List<AlumniProfile> getApprovedAlumni() throws Exception {

        java.util.List<AlumniProfile> list = new java.util.ArrayList<>();

        String sql =
            "SELECT u.user_id, u.full_name, ap.photo_path, ap.current_company, ap.current_role, ap.batch_id " +
            "FROM users u " +
            "JOIN alumni_profile ap ON u.user_id = ap.user_id " +
            "WHERE u.role = 'ALUMNI' AND u.status = 'APPROVED' " +
            "ORDER BY u.full_name";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                AlumniProfile p = new AlumniProfile();

                p.setUserId(rs.getInt("user_id"));
                p.setPhotoPath(rs.getString("photo_path"));
                p.setCurrentCompany(rs.getString("current_company"));
                p.setCurrentRole(rs.getString("current_role"));
                p.setBatchId(rs.getInt("batch_id"));

                User u = new User();
                u.setFullName(rs.getString("full_name"));

                p.setUser(u);

                list.add(p);
            }
        }

        return list;
    } 
    
 // ============================================================
 // ADD THESE TWO METHODS INSIDE UserDao.java
 // Place them after the existing getApprovedAlumni() method
 // ============================================================

     /**
      * Authenticate a STAFF user by email + hashed password.
      * Used by StaffLoginServlet.
      */
     public User findStaffLogin(String email, String hashedPassword) throws Exception {
         String sql = "SELECT user_id, full_name, email, role, status, email_verified " +
                      "FROM users WHERE email = ? AND pass_hash = ? AND role = 'STAFF'";

         try (Connection con = DBConnection.getConnection();
              PreparedStatement ps = con.prepareStatement(sql)) {

             ps.setString(1, email);
             ps.setString(2, hashedPassword);

             try (ResultSet rs = ps.executeQuery()) {
                 if (rs.next()) {
                     User u = new User();
                     u.setUserId(rs.getInt("user_id"));
                     u.setFullName(rs.getString("full_name"));
                     u.setEmail(rs.getString("email"));
                     u.setRole(rs.getString("role"));
                     u.setStatus(rs.getString("status"));
                     u.setEmailVerified(rs.getString("email_verified"));
                     return u;
                 }
             }
         }
         return null;
     }

     /**
      * Returns ALL approved alumni with FULL profile details.
      * Used by StaffMembersServlet — staff can see every field.
      */
     public java.util.List<AlumniProfile> getApprovedAlumniFullDetails() throws Exception {

         java.util.List<AlumniProfile> list = new java.util.ArrayList<>();

         String sql =
             "SELECT u.user_id, u.full_name, u.email, u.phone, u.place, u.age, " +
             "       ap.profile_id, ap.batch_id, ap.dept_id, ap.university_reg_no, " +
             "       ap.current_company, ap.current_role, ap.experience_years, " +
             "       ap.company_changes_count, ap.company_changes_names, " +
             "       ap.specialization, ap.photo_path, ap.created_at " +
             "FROM users u " +
             "JOIN alumni_profile ap ON u.user_id = ap.user_id " +
             "WHERE u.role = 'ALUMNI' AND u.status = 'APPROVED' " +
             "ORDER BY u.full_name";

         try (Connection con = DBConnection.getConnection();
              PreparedStatement ps = con.prepareStatement(sql);
              ResultSet rs = ps.executeQuery()) {

             while (rs.next()) {
                 AlumniProfile p = new AlumniProfile();
                 p.setProfileId(rs.getInt("profile_id"));
                 p.setUserId(rs.getInt("user_id"));
                 p.setBatchId(rs.getInt("batch_id"));
                 p.setDeptId(rs.getInt("dept_id"));
                 p.setUniversityRegNo(rs.getString("university_reg_no"));
                 p.setCurrentCompany(rs.getString("current_company"));
                 p.setCurrentRole(rs.getString("current_role"));
                 p.setExperienceYears(rs.getInt("experience_years"));
                 p.setCompanyChangesCount(rs.getInt("company_changes_count"));
                 p.setCompanyChangesNames(rs.getString("company_changes_names"));
                 p.setSpecialization(rs.getString("specialization"));
                 p.setPhotoPath(rs.getString("photo_path"));
                 p.setCreatedAt(rs.getTimestamp("created_at"));

                 User u = new User();
                 u.setUserId(rs.getInt("user_id"));
                 u.setFullName(rs.getString("full_name"));
                 u.setEmail(rs.getString("email"));
                 u.setPhone(rs.getString("phone"));
                 u.setPlace(rs.getString("place"));
                 u.setAge(rs.getInt("age"));

                 p.setUser(u);
                 list.add(p);
             }
         }

         return list;
     }
    
    public java.util.List<User> getAllAlumniUsers(String keyword, String status) throws Exception {
        java.util.List<User> list = new java.util.ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT user_id, full_name, email, phone, place, role, status, email_verified " +
            "FROM users WHERE role = 'ALUMNI' "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(full_name) LIKE ? OR LOWER(email) LIKE ?) ");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND status = ? ");
        }

        sql.append("ORDER BY user_id DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int index = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                String k = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(index++, k);
                ps.setString(index++, k);
            }

            if (status != null && !status.trim().isEmpty()) {
                ps.setString(index++, status);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setEmail(rs.getString("email"));
                    u.setPhone(rs.getString("phone"));
                    u.setPlace(rs.getString("place"));
                    u.setRole(rs.getString("role"));
                    u.setStatus(rs.getString("status"));
                    u.setEmailVerified(rs.getString("email_verified"));
                    list.add(u);
                }
            }
        }

        return list;
    }

    public AlumniProfile getAlumniProfileByUserId(int userId) throws Exception {
        String sql =
            "SELECT ap.profile_id, ap.user_id, ap.batch_id, ap.dept_id, ap.university_reg_no, " +
            "ap.current_company, ap.current_role, ap.experience_years, ap.company_changes_count, " +
            "ap.company_changes_names, ap.specialization, ap.photo_path, ap.created_at, " +
            "u.full_name, u.email, u.phone, u.place, u.status, u.email_verified " +
            "FROM alumni_profile ap " +
            "JOIN users u ON ap.user_id = u.user_id " +
            "WHERE ap.user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AlumniProfile p = new AlumniProfile();
                    p.setProfileId(rs.getInt("profile_id"));
                    p.setUserId(rs.getInt("user_id"));
                    p.setBatchId(rs.getInt("batch_id"));
                    p.setDeptId(rs.getInt("dept_id"));
                    p.setUniversityRegNo(rs.getString("university_reg_no"));
                    p.setCurrentCompany(rs.getString("current_company"));
                    p.setCurrentRole(rs.getString("current_role"));
                    p.setExperienceYears(rs.getInt("experience_years"));
                    p.setCompanyChangesCount(rs.getInt("company_changes_count"));
                    p.setCompanyChangesNames(rs.getString("company_changes_names"));
                    p.setSpecialization(rs.getString("specialization"));
                    p.setPhotoPath(rs.getString("photo_path"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));

                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setEmail(rs.getString("email"));
                    u.setPhone(rs.getString("phone"));
                    u.setPlace(rs.getString("place"));
                    u.setStatus(rs.getString("status"));
                    u.setEmailVerified(rs.getString("email_verified"));

                    p.setUser(u);
                    return p;
                }
            }
        }

        return null;
    }
    
    public AlumniProfile getVirtualIdProfile(int userId) throws Exception {
        String sql =
            "SELECT ap.profile_id, ap.user_id, ap.batch_id, ap.dept_id, ap.university_reg_no, " +
            "ap.current_company, ap.current_role, ap.experience_years, ap.company_changes_count, " +
            "ap.company_changes_names, ap.specialization, ap.photo_path, ap.created_at, " +
            "u.full_name, u.email, u.phone, u.place, u.status, u.email_verified " +
            "FROM alumni_profile ap " +
            "JOIN users u ON ap.user_id = u.user_id " +
            "WHERE ap.user_id = ? AND u.role = 'ALUMNI' AND u.status = 'APPROVED'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AlumniProfile p = new AlumniProfile();
                    p.setProfileId(rs.getInt("profile_id"));
                    p.setUserId(rs.getInt("user_id"));
                    p.setBatchId(rs.getInt("batch_id"));
                    p.setDeptId(rs.getInt("dept_id"));
                    p.setUniversityRegNo(rs.getString("university_reg_no"));
                    p.setCurrentCompany(rs.getString("current_company"));
                    p.setCurrentRole(rs.getString("current_role"));
                    p.setExperienceYears(rs.getInt("experience_years"));
                    p.setCompanyChangesCount(rs.getInt("company_changes_count"));
                    p.setCompanyChangesNames(rs.getString("company_changes_names"));
                    p.setSpecialization(rs.getString("specialization"));
                    p.setPhotoPath(rs.getString("photo_path"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));

                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setEmail(rs.getString("email"));
                    u.setPhone(rs.getString("phone"));
                    u.setPlace(rs.getString("place"));
                    u.setStatus(rs.getString("status"));
                    u.setEmailVerified(rs.getString("email_verified"));

                    p.setUser(u);
                    return p;
                }
            }
        }

        return null;
    }
    
    public boolean deleteMember(int userId) {
        boolean status = false;

        try (Connection con = DBConnection.getConnection()) {

            // Step 1: delete from alumni_profile
            String sql1 = "DELETE FROM alumni_profile WHERE user_id=?";
            PreparedStatement ps1 = con.prepareStatement(sql1);
            ps1.setInt(1, userId);
            ps1.executeUpdate();

            // Step 2: delete from users
            String sql2 = "DELETE FROM users WHERE user_id=?";
            PreparedStatement ps2 = con.prepareStatement(sql2);
            ps2.setInt(1, userId);

            int rows = ps2.executeUpdate();

            if (rows > 0) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
    
    
}