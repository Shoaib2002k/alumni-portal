package com.alumni.util;

import java.util.Random;

public class OtpUtil {

    public static String generateOtp() {
        Random random = new Random();
        int number = 100000 + random.nextInt(900000);
        return String.valueOf(number);
    }
}