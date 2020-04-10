package com.pegasus.kafka.service.kafka;

import com.pegasus.kafka.entity.vo.KafkaBrokerVo;
import com.pegasus.kafka.service.core.KafkaService;

import org.springframework.stereotype.Service;

import java.util.List;

/**
 * The service for Kafka Broker.
 * <p>
 * *****************************************************************
 * Name               Action            Time          Description  *
 * Ning.Zhang       Initialize         11/7/2019      Initialize   *
 * *****************************************************************
 */
@Service
public class KafkaBrokerService {
    private final KafkaService kafkaService;


    public KafkaBrokerService(KafkaService kafkaService) {
        this.kafkaService = kafkaService;
    }

    public List<KafkaBrokerVo> listAllBrokers() throws Exception {
        List<KafkaBrokerVo> result = kafkaService.listBrokerInfos();
        for (KafkaBrokerVo kafkaBrokerVo : result) {
            kafkaBrokerVo.setHost(String.format("%S (%s, %s)", kafkaBrokerVo.getHost(), "kafka", "2.4.1"));
        }
        return result;
    }
}