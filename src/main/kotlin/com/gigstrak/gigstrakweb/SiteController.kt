package com.gigstrak.gigstrakweb

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.ResponseBody

@Controller
class SiteController {

    @GetMapping("/")
    fun home(): String = "index"

    @GetMapping("/about")
    fun about(): String = "about"

    @GetMapping("/contact")
    fun contact(): String = "contact"

    @GetMapping("/privacy")
    fun privacy(): String = "privacy"

    @GetMapping("/terms")
    fun terms(): String = "terms"

    @GetMapping("/api/hello")
    @ResponseBody
    fun hello(): Map<String, String> {
        return mapOf(
            "message" to "Welcome to Gigstrak.",
            "status" to "running"
        )
    }
}
