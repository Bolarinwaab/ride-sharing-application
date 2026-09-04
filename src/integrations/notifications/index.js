class NotificationDispatcher {
  constructor({providers=[]}={}){this.providers=providers;}
  async send(message){const results=[];for(const provider of this.providers){try{results.push(await provider.send(message));}catch(error){results.push({provider:provider.name||'unknown',ok:false,error:error.message});}}return results;}
}
module.exports={NotificationDispatcher};
