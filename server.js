const http = require('node:http');

const port = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ status: 'ok', node: process.version }));
});

server.listen(port, () => {
  console.log(`listening on ${port}`);
});
