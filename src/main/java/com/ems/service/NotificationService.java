package com.ems.service;

import com.ems.dao.NotificationDAO;
import com.ems.model.Notifications;

import java.util.List;

public class NotificationService {
    public List<Notifications>getAllNotifications(Integer userId){
        return NotificationDAO.getNotifications(userId);
    }

    public int countNotifications(Integer userId, String keyword){
        return NotificationDAO.countNotifications(userId, keyword == null ? "" : keyword);
    }

    public List<Notifications> searchNotification(Integer userId, String keyword, String sort, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return NotificationDAO.getNotificationById(userId, keyword == null ? "" : keyword, sort, offset, pageSize);
    }

    public boolean markAsRead(Integer notificationId, Integer userId) {
        if (notificationId == null || userId == null) return false;
        return NotificationDAO.markAsRead(notificationId, userId);
    }
}
