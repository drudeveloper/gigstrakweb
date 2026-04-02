package com.gigstrak.gigstrakweb

import org.junit.jupiter.api.Test
import kotlin.test.assertEquals
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest

@SpringBootTest
class GigstrakwebApplicationTests {

    @Autowired
    lateinit var siteController: SiteController

    @Test
    fun contextLoads() {
    }

    @Test
    fun controllerReturnsExpectedViews() {
        assertEquals("index", siteController.home())
        assertEquals("about", siteController.about())
        assertEquals("contact", siteController.contact())
        assertEquals("privacy", siteController.privacy())
        assertEquals("terms", siteController.terms())
    }

}
