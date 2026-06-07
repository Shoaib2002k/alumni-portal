package com.alumni.servlet;


import com.alumni.dao.UserDao;
import com.alumni.model.AlumniProfile;
import com.alumni.model.User;
import com.alumni.util.PasswordUtil;
import com.alumni.util.OtpUtil;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Part;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
@MultipartConfig
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String fullName = request.getParameter("fullName");
            String ageStr = request.getParameter("age");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String place = request.getParameter("place");
            String universityRegNo = request.getParameter("universityRegNo");
            String currentCompany = request.getParameter("currentCompany");
            String currentRole = request.getParameter("currentRole");
            String companyChangesCountStr = request.getParameter("companyChangesCount");
            String companyChangesNames = request.getParameter("companyChangesNames");
            String experienceYearsStr = request.getParameter("experienceYears");
            String specialization = request.getParameter("specialization");
            String otherSpecialization = request.getParameter("otherSpecialization");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            Part photoPart = request.getPart("photo");

            if (fullName == null || fullName.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || phone == null || phone.trim().isEmpty()
                    || place == null || place.trim().isEmpty()
                    || universityRegNo == null || universityRegNo.trim().isEmpty()
                    || password == null || password.trim().isEmpty()
                    || confirmPassword == null || confirmPassword.trim().isEmpty()
                    || photoPart == null || photoPart.getSize() == 0) {

                request.setAttribute("error", "Please fill all required fields.");
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }

            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Password and Re-enter Password do not match.");
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }

            if ("Other".equals(specialization)) {
                if (otherSpecialization != null && !otherSpecialization.trim().isEmpty()) {
                    specialization = otherSpecialization.trim();
                } else {
                    request.setAttribute("error", "Please enter your specialization.");
                    request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                    return;
                }
            }

            UserDao dao = new UserDao();

            if (dao.emailExists(email)) {
                request.setAttribute("error", "Email already registered.");
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }

            Integer age = parseInteger(ageStr);
            Integer companyChangesCount = parseInteger(companyChangesCountStr);
            Integer experienceYears = parseInteger(experienceYearsStr);

            String hashedPassword = PasswordUtil.hashPassword(password);

            String fileName = Paths.get(photoPart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);

            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String savedFileName = System.currentTimeMillis() + "_" + fileName;
            photoPart.write(uploadPath + File.separator + savedFileName);

            String photoPath = "uploads/" + savedFileName;

            User user = new User();
            user.setFullName(fullName);
            user.setAge(age);
            user.setEmail(email);
            user.setPhone(phone);
            user.setPlace(place);
            user.setPassHash(hashedPassword);

            AlumniProfile profile = new AlumniProfile();
            profile.setUniversityRegNo(universityRegNo);
            profile.setCurrentCompany(currentCompany);
            profile.setCurrentRole(currentRole);
            profile.setCompanyChangesCount(companyChangesCount);
            profile.setCompanyChangesNames(companyChangesNames);
            profile.setExperienceYears(experienceYears);
            profile.setSpecialization(specialization);
            profile.setPhotoPath(photoPath);

            dao.registerUser(user, profile);

            String otp = OtpUtil.generateOtp();
            dao.saveOtp(email, otp);

            // Send actual email with the OTP using EmailUtil
            //com.alumni.util.EmailUtil.sendOtpEmail(email, otp);

            System.out.println("======================================");
            System.out.println("OTP FOR EMAIL " + email + " IS: " + otp);
            System.out.println("======================================");

            response.sendRedirect(request.getContextPath() + "/auth/verify-otp.jsp?email=" + email);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
        }
    }

    private Integer parseInteger(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }
            return Integer.parseInt(value);
        } catch (Exception e) {
            return null;
        }
    }
}