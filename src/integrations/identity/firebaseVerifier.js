function createFirebaseVerifier({adminSdk, projectId}){
  if(!adminSdk||!projectId)throw new Error('Firebase Admin SDK and projectId are required');
  const app=adminSdk.apps?.length?adminSdk.app():adminSdk.initializeApp({projectId});
  return {verify: token => app.auth().verifyIdToken(token)};
}
module.exports={createFirebaseVerifier};
