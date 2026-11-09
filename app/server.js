const http = require('node:http');

const port = process.env.PORT || 3000;
const baseImage = process.env.BASE_IMAGE || 'unknown base image';

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ status: 'ok', baseImage, node: process.version }));
});

server.listen(port, () => {
  console.log(`Running on ${baseImage} (node ${process.version}), listening on ${port}`);
});
