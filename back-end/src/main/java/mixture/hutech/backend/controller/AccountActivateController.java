package mixture.hutech.backend.controller;

import lombok.RequiredArgsConstructor;
import mixture.hutech.backend.dto.response.MessageResponse;
import mixture.hutech.backend.enums.ErrorCodeEnum;
import mixture.hutech.backend.exceptions.ApiException;
import mixture.hutech.backend.service.AuthenticationService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("api/auth")
public class AccountActivateController {
    private final AuthenticationService authenticationService;
    private String frontendUrl = "http://localhost:8080";

    @GetMapping("/direct-verify/{token}")
    public String directVerify(@PathVariable String token, Model model) {
        try {
            MessageResponse response = authenticationService.verifyTokenRegister(token);
            if (response.getErrorCode() == ErrorCodeEnum.OK) {
                model.addAttribute("successful", true);
                model.addAttribute("title", "Kích hoạt tài khoản thành công");
                model.addAttribute("message", "Tài khoản của bạn đã được kích hoạt. Bây giờ bạn có thể đăng nhập và sử dụng dịch vụ của chúng tôi.");
                model.addAttribute("loginUrl", frontendUrl + "/login");
            } else {
                model.addAttribute("successful", false);
                model.addAttribute("title", "Lỗi kích hoạt tài khoản");
                model.addAttribute("message", response.getMessage());
            }
        } catch (ApiException e) {
            model.addAttribute("successful", false);
            model.addAttribute("title", "Lỗi kích hoạt tài khoản");
            model.addAttribute("message", e.getMessage());
        }
        return "account-activation";
    }
}
