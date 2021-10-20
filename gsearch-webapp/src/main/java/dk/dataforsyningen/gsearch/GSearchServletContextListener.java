package dk.dataforsyningen.gsearch;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class GSearchServletContextListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        DatabaseManager.start();
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        DatabaseManager.shutdown();
    }
}