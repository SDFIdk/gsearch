function fn() {
    if (karate.env === 'mock') {
        return { serviceUrl: 'http://localhost:8080' };
    }
    return { serviceUrl: karate.properties['service.url'] };
}