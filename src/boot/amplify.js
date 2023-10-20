import { boot } from 'quasar/wrappers';
import { Amplify } from 'aws-amplify';
import awsExports from '../aws-exports';
import AmplifyVue from '@aws-amplify/ui-vue';

Amplify.configure(awsExports);

export default boot(({ app }) => {
   app.use(AmplifyVue);
});
