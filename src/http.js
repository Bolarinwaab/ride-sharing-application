const http=require('node:http');
const {loadConfig}=require('./config');
function startServer({port=loadConfig().port}={}){return http.createServer((req,res)=>{const correlationId=req.headers['x-correlation-id']||require('node:crypto').randomUUID();res.setHeader('X-Correlation-ID',correlationId);res.setHeader('X-Content-Type-Options','nosniff');res.setHeader('Referrer-Policy','no-referrer');res.setHeader('X-Frame-Options','DENY');if(req.url==='/healthz'){res.writeHead(200,{'Content-Type':'application/json'});return res.end(JSON.stringify({status:'ok'}));}if(req.url==='/readyz'){res.writeHead(200,{'Content-Type':'application/json'});return res.end(JSON.stringify({status:'ready'}));}res.writeHead(404,{'Content-Type':'application/json'});res.end(JSON.stringify({error:'not_found',correlationId}));}).listen(port);}
if(require.main===module)startServer();
module.exports={startServer};
