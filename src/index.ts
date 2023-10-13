import uc = require("upper-case");
import http = require('http');

const server = http.createServer((req, res) => {
    if (req.url === '/') {
        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.end(`
            <!DOCTYPE html>
            <html>
            <head>
                <title>Sample NODE Page</title>
            </head>
            <body>
                <h1>Hello World</h1>
                <p>${uc.upperCase("Hello World")}</p>
                    
                <button>Buy 1 day</button>
                <button>Buy 3 days</button>
            </body>
            </html>
        `);
    } else {
        res.writeHead(404, { 'Content-Type': 'text/plain' });
        res.end('Page not found');
    }
});

const PORT = 3000;
server.listen(PORT, () => {
    console.log(`Server is running at http://localhost:${PORT}`);
});

