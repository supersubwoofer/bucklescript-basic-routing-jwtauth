import node_resolve from 'rollup-plugin-node-resolve';

export default {
    input: './lib/es6/src/main.js', 
    output: {
        name: 'starter',
        file: './release/main.js',
        format: 'iife'
    },
    plugins: [
        node_resolve({mainFields: ['module', 'main', 'browser']})
    ]
}
