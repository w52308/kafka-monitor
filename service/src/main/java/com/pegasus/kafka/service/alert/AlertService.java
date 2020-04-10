package com.pegasus.kafka.service.alert;

import lombok.Data;

import net.sf.ehcache.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ArrayBlockingQueue;

/**
 * The service for providing an alert when a problem is detected.
 * <p>
 * *****************************************************************
 * Name               Action            Time          Description  *
 * Ning.Zhang       Initialize         11/7/2019      Initialize   *
 * *****************************************************************
 */
@Service
public class AlertService {

    private ArrayBlockingQueue<Alert> alertList;
    private final Map<String, Alert> duplicateMap;

    public AlertService() {
        alertList = new ArrayBlockingQueue<>(1024);
        duplicateMap = new ConcurrentHashMap<>(1024);
    }

    public void offer(String id, Alert alert) {
        if (!duplicateMap.containsKey(id)) {
            duplicateMap.put(id, alert);
            alertList.offer(alert);
        }
    }

    public List<Alert> getAll() {
        List<Alert> result = new ArrayList<>(1024);
        alertList.drainTo(result, 1024);
        return result;
    }

    @Data
    public static class Alert {
        private String email;
        private String emailTitle;
        private String emailContent;
        private String dingContent;
    }

}
