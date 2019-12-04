package com.pegasus.kafka.resolver;

import com.pegasus.kafka.common.constant.Constants;
import com.pegasus.kafka.entity.dto.SysAdmin;
import com.pegasus.kafka.entity.vo.AdminInfo;
import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebArgumentResolver;
import org.springframework.web.context.request.NativeWebRequest;

import javax.servlet.http.HttpServletRequest;

/**
 * The argument resolver for login.
 * <p>
 * *****************************************************************
 * Name               Action            Time          Description  *
 * Ning.Zhang       Initialize         11/7/2019      Initialize   *
 * *****************************************************************
 */
public class LoginArgumentResolver implements WebArgumentResolver {
    @Override
    public Object resolveArgument(MethodParameter methodParameter, NativeWebRequest nativeWebRequest) throws Exception {
        Class<?> parameterType = methodParameter.getParameterType();
        if (parameterType != null) {
            HttpServletRequest request = nativeWebRequest.getNativeRequest(HttpServletRequest.class);
            if (parameterType.equals(AdminInfo.class)) {
                return request.getAttribute(Constants.CURRENT_ADMIN_LOGIN);
            }
        }
        return UNRESOLVED;
    }
}
