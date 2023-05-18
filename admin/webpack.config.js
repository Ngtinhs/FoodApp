const path = require('path');

module.exports = {
    resolve: {
        fallback: {
            crypto: require.resolve('crypto-browserify'),
            stream: require.resolve('stream-browserify'),
            util: require.resolve('util'),
        },
    },
};
