package mixture.hutech.backend.utils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class DateTimeUtils {
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd-MM-yyyy");
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");

    public static String formatDate(LocalDate date) {
        return date != null ? date.format(DATE_FORMATTER) : "";
    }

    public static String formatTime(LocalTime time) {
        return time != null ? time.format(TIME_FORMATTER) : "";
    }

    public static String formatDateTime(LocalDateTime dateTime) {
        return dateTime != null ? dateTime.format(DATE_TIME_FORMATTER) : "";
    }

    public static LocalDate parseDate(String dateString) {
        return dateString != null && !dateString.isEmpty() ? LocalDate.parse(dateString, DATE_FORMATTER) : null;
    }

    public static LocalTime parseTime(String timeString) {
        return timeString != null && !timeString.isEmpty() ? LocalTime.parse(timeString, TIME_FORMATTER) : null;
    }

    public static LocalDateTime parseDateTime(String dateTimeString) {
        return dateTimeString != null && !dateTimeString.isEmpty() ? LocalDateTime.parse(dateTimeString, DATE_TIME_FORMATTER) : null;
    }

    public static boolean isValidDate(String dateString) {
        try {
            LocalDate.parse(dateString, DATE_FORMATTER);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public static boolean isValidTime(String timeString) {
        try {
            LocalTime.parse(timeString, TIME_FORMATTER);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public static boolean isValidDateTime(String dateTimeString) {
        try {
            LocalDateTime.parse(dateTimeString, DATE_TIME_FORMATTER);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}