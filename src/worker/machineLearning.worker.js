import * as Comlink from 'comlink';
import MachineLearningService from 'services/machineLearning/machineLearningService';

export class MachineLearningWorker {
    async sync(token) {
        if (!(typeof navigator !== 'undefined')) {
            console.log(
                'MachineLearning worker will only run in web worker env.'
            );
            return;
        }

        console.log('Running machine learning sync from worker');
        const mlService = new MachineLearningService();
        await mlService.init();
        const results = await mlService.sync(token);
        console.log('Ran machine learning sync from worker', results);
        return results;
    }
}

Comlink.expose(MachineLearningWorker);
