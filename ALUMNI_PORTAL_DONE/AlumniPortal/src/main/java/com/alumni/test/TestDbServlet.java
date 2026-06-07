package com.alumni.test;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/test-db")
public class TestDbServlet extends HttpServlet {

	private static final String URL =
	        "jdbc:oracle:thin:@//localhost:1521/XEPDB1";

	private static final String USER = "MEASI_ALUMNI";
	private static final String PASSWORD = "alumni123";

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {

        	Class.forName("oracle.jdbc.OracleDriver");

            Connection con =
                    DriverManager.getConnection(URL, USER, PASSWORD);

            out.println("<h2 style='color:green'>Database Connected Successfully</h2>");

            con.close();

        } catch (Exception e) {

            out.println("<h2 style='color:red'>Database Connection Failed</h2>");
            e.printStackTrace(out);
        }
    }
}