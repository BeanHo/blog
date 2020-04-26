package com.lynn.blog.user.controller.v1;

import com.lynn.blog.pub.controller.v1.BaseV1Controller;
import com.lynn.blog.user.domain.request.TestRequest;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;

@RequestMapping("{version}")
@RestController
public class TestV1Controller extends BaseV1Controller {

    @GetMapping("index")
    public String index(@Valid TestRequest request, BindingResult result){
        validate(result);
        return "Hello " + request.getName();
    }
}
