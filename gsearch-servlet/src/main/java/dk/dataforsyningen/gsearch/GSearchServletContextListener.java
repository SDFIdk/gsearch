package dk.dataforsyningen.gsearch;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebListener
public class GSearchServletContextListener implements ServletContextListener {
    static Logger logger = LoggerFactory.getLogger(GSearchServletContextListener.class);

    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        logger.debug("contextInitialized called");
        DatabaseManager.start();
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        logger.debug("contextDestroyed called");
        DatabaseManager.shutdown();
    }
}